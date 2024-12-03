#include<chrono>
#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<vector>
using t_t=decltype(std::chrono::high_resolution_clock::now());
t_t getTime(){
   return std::chrono::high_resolution_clock::now();
}
using d_t=std::chrono::nanoseconds;
double getDurationNanoseconds(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1.0;
}
double getDurationMicroseconds(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1'000.0;
}
double getDurationMilliseconds(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1'000'000.0;
}
double getDurationSeconds(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1'000'000'000.0;
}
using llint=long long int;

#include<array>
#include<unordered_map>
#include<utility>
enum class LR{
   Left,Right
};
using LRS=std::vector<LR>;
using Mapping=std::pair<std::string,std::string>;
using MappingMap=std::unordered_map<std::string,Mapping>;
using Result=std::pair<std::string,llint>;
using Results=std::vector<Result>;
using ResultsMap=std::unordered_map<std::string,Results>;
std::pair<LRS,MappingMap>parseInput(const std::vector<std::string> &input){
   LRS lrs;
   MappingMap map;
   bool first=true;
   bool second=true;
   for(const std::string &line:input){
      if(first){
         first=false;
         second=true;
         for(char c:line){
            lrs.push_back(c=='L'?LR::Left:LR::Right);
         }
      } else if(second){
         second=false;
      } else{
         map.insert(std::make_pair(line.substr(0,3),std::make_pair(line.substr(7,3),line.substr(12,3))));
      }
   }
   return std::make_pair(lrs,map);
}
Result simulate(const LRS &lrs,const MappingMap &map,std::string current,llint period=0,bool part2=false,llint max=1'000'000){
   do{
      auto it=map.find(current);
      if(lrs[period++%lrs.size()]==LR::Left){
         current=it->second.first;
      } else{
         current=it->second.second;
      }
   } while((part2?current[2]!='Z':current!="ZZZ")&&period<max);
   return std::make_pair(current,period);
}
llint solve1(const std::vector<std::string> &input){
   auto [lrs,map]=parseInput(input);
   return simulate(lrs,map,"AAA").second;
}
llint solve2(const std::vector<std::string> &input){
   auto [lrs,map]=parseInput(input);
   ResultsMap periods;
#if 1
   Results defaultPeriod;
   defaultPeriod.resize(lrs.size(),std::make_pair("ZZZ",-1));
   for(auto it:map){
      periods.insert(std::make_pair(it.first,defaultPeriod));
   }
#else
   for(auto it:map){
      Results results;
      for(llint i=0;i<lrs.size();i++){
         Result result=simulate(lrs,map,it.first,i,true);
         result.second-=i;
         results.emplace_back(result);
      }
      periods.insert(std::make_pair(it.first,results));
   }
#endif
   Results currents;
   for(auto it:map){
      if(it.first[2]=='A'){
         currents.push_back(std::make_pair(it.first,0));
      }
   }
   llint minPeriod=0;
   bool skipFirstAllZero=true;
   while(true){
      minPeriod=currents[0].second;
      bool same=true;
      for(int i=1;i<currents.size();i++){
         const Result &current=currents[i];
         if(current.second!=minPeriod){
            same=false;
         }
         if(current.second<minPeriod){
            minPeriod=current.second;
         }
      }
      if(same){
         if(skipFirstAllZero){
            skipFirstAllZero=false;
         } else{
            break;
         }
      }
      for(Result &current:currents){
         if(current.second==minPeriod){
            auto found=periods.find(current.first);
            Result &mapResult=found->second[current.second%lrs.size()];
            if(mapResult.second==-1){
               Result result=simulate(lrs,map,current.first,current.second,true);
               result.second-=current.second;
               std::clog<<current.first<<' '<<current.second<<' '<<result.first<<' '<<result.second<<'\n';
               mapResult=result;
            }
            current.first=mapResult.first;
            current.second+=mapResult.second;
         }
      }
   }
   return minPeriod;
}
int main(){
   std::vector<std::string>example1={
      "RL",
      "",
      "AAA = (BBB, CCC)",
      "BBB = (DDD, EEE)",
      "CCC = (ZZZ, GGG)",
      "DDD = (DDD, DDD)",
      "EEE = (EEE, EEE)",
      "GGG = (GGG, GGG)",
      "ZZZ = (ZZZ, ZZZ)"
   };

   std::vector<std::string>example2={
      "LR",
      "",
      "11A = (11B, XXX)",
      "11B = (XXX, 11Z)",
      "11Z = (11B, XXX)",
      "22A = (22B, XXX)",
      "22B = (22C, 22C)",
      "22C = (22Z, 22Z)",
      "22Z = (22B, 22B)",
      "XXX = (XXX, XXX)"
   };

   std::ifstream inputFile("input");
   std::vector<std::string>input;
   std::string line;
   while(std::getline(inputFile,line)){
      input.push_back(line);
   }

   t_t time0=getTime();
   auto answer1example=solve1(example1);
   t_t time1=getTime();
   auto answer1input=solve1(input);
   t_t time2=getTime();
   auto answer2example=solve2(example2);
   t_t time3=getTime();
   auto answer2input=solve2(input);
   t_t time4=getTime();

   double duration0=getDurationMilliseconds(time0,time1);
   double duration1=getDurationMilliseconds(time1,time2);
   double duration2=getDurationMilliseconds(time2,time3);
   double duration3=getDurationMilliseconds(time3,time4);

   std::cout<<"Example 1 took "<<duration0<<"ms: "<<answer1example<<'\n';
   std::cout<<"Input   1 took "<<duration1<<"ms: "<<(answer1input)<<'\n';
   std::cout<<"Example 2 took "<<duration2<<"ms: "<<answer2example<<'\n';
   std::cout<<"Input   2 took "<<duration3<<"ms: "<<(answer2input)<<'\n';
}
