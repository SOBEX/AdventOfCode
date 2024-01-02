#include<array>
#include<chrono>
#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<utility>
#include<vector>
#ifdef _MSC_VER
#define UNREACHABLE() __assume(false)
#define ASSUME(C) __assume(C)
#else
#define UNREACHABLE() __builtin_unreachable()
#define ASSUME(C) do{if(!__builtin_expect(C,true)){UNREACHABLE();}}while(false)
#endif
using t_t=decltype(std::chrono::high_resolution_clock::now());
t_t getTime(){
   return std::chrono::high_resolution_clock::now();
}
using d_t=std::chrono::nanoseconds;
double getDurationNs(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1.0;
}
double getDurationUs(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1'000.0;
}
double getDurationMs(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1'000'000.0;
}
double getDurationS(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1'000'000'000.0;
}
using shint=unsigned char;
using llint=long long int;
using Line=std::string;
using Input=std::vector<std::string>;
struct Position{
   llint x;
   llint y;
   bool isIn(llint width,llint height)const{
      return 0<=x&&x<width&&0<=y&&y<height;
   }
   template<typename T>bool isIn(T &t)const{
      return isIn(t[0].size(),t.size());
   }
   template<typename T>decltype(std::declval<T>()[0][0])indexInto(T &t)const{
      return t[y][x];
   }
   friend auto operator<=>(Position l,Position r){
      if(auto dx=l.x<=>r.x;dx!=0){
         return dx;
      }
      return l.y<=>r.y;
   }
};
#include<algorithm>
#include<unordered_map>
struct FlipFlop{
   bool isOn;
   std::vector<std::string>names;
};
struct Conjunction{
   std::unordered_map<std::string,bool>memory;
   std::vector<std::string>names;
};
struct Pulse{
   bool isHigh;
   std::string from;
   std::string to;
};
llint solve1(const Input &input){
   std::unordered_map<std::string,FlipFlop>flipFlops;
   std::unordered_map<std::string,Conjunction>conjunctions;
   std::vector<std::string>broadcaster;
   for(const Line &line:input){
      if(line[0]=='%'){
         llint start=1;
         llint end=line.find_first_of(' ',start);
         FlipFlop &flipFlop=flipFlops.insert({line.substr(start,end-start),{false,{}}}).first->second;
         start=end+4;
         while((end=line.find_first_of(',',start))!=std::string::npos){
            flipFlop.names.push_back(line.substr(start,end-start));
            start=end+2;
         }
         flipFlop.names.push_back(line.substr(start));
      } else if(line[0]=='&'){
         llint start=1;
         llint end=line.find_first_of(' ',start);
         Conjunction &conjunction=conjunctions.insert({line.substr(start,end-start),{}}).first->second;
         start=end+4;
         while((end=line.find_first_of(',',start))!=std::string::npos){
            conjunction.names.push_back(line.substr(start,end-start));
            start=end+2;
         }
         conjunction.names.push_back(line.substr(start));
      } else{
         llint start=15;
         llint end;
         while((end=line.find_first_of(',',start))!=std::string::npos){
            broadcaster.push_back(line.substr(start,end-start));
            start=end+2;
         }
         broadcaster.push_back(line.substr(start));
      }
   }
   for(const std::pair<std::string,FlipFlop> &entry:flipFlops){
      for(const std::string &name:entry.second.names){
         if(conjunctions.contains(name)){
            conjunctions.find(name)->second.memory.insert({entry.first,false});
         }
      }
   }
   for(const std::pair<std::string,Conjunction> &entry:conjunctions){
      for(const std::string &name:entry.second.names){
         if(conjunctions.contains(name)){
            conjunctions.find(name)->second.memory.insert({entry.first,false});
         }
      }
   }
   llint highs=0;
   llint lows=0;
   for(llint i=0;i<1000;i++){
      std::vector<Pulse>pulses;
      for(const std::string &name:broadcaster){
         pulses.push_back({false,"broadcaster",name});
      }
      lows++;
      while(!pulses.empty()){
         std::vector<Pulse>newPulses;
         for(const Pulse &pulse:pulses){
            if(conjunctions.contains(pulse.to)){
               Conjunction &conjunction=conjunctions.find(pulse.to)->second;
               conjunction.memory.find(pulse.from)->second=pulse.isHigh;
               bool sendLow=std::all_of(conjunction.memory.cbegin(),conjunction.memory.cend(),[](const std::pair<std::string,bool> &entry){return entry.second;});
               for(const std::string &name:conjunction.names){
                  newPulses.push_back({!sendLow,pulse.to,name});
               }
            } else if(!pulse.isHigh){
               FlipFlop &flipFlop=flipFlops.find(pulse.to)->second;
               flipFlop.isOn=!flipFlop.isOn;
               for(const std::string &name:flipFlop.names){
                  newPulses.push_back({flipFlop.isOn,pulse.to,name});
               }
            }
            if(pulse.isHigh){
               highs++;
            } else{
               lows++;
            }
         }
         pulses=newPulses;
      }
   }
   return lows*highs;
}
llint solve2(const Input &input){
   std::unordered_map<std::string,FlipFlop>flipFlops;
   std::unordered_map<std::string,Conjunction>conjunctions;
   std::vector<std::string>broadcaster;
   for(const Line &line:input){
      if(line[0]=='%'){
         llint start=1;
         llint end=line.find_first_of(' ',start);
         FlipFlop &flipFlop=flipFlops.insert({line.substr(start,end-start),{false,{}}}).first->second;
         start=end+4;
         while((end=line.find_first_of(',',start))!=std::string::npos){
            flipFlop.names.push_back(line.substr(start,end-start));
            start=end+2;
         }
         flipFlop.names.push_back(line.substr(start));
      } else if(line[0]=='&'){
         llint start=1;
         llint end=line.find_first_of(' ',start);
         Conjunction &conjunction=conjunctions.insert({line.substr(start,end-start),{}}).first->second;
         start=end+4;
         while((end=line.find_first_of(',',start))!=std::string::npos){
            conjunction.names.push_back(line.substr(start,end-start));
            start=end+2;
         }
         conjunction.names.push_back(line.substr(start));
      } else{
         llint start=15;
         llint end;
         while((end=line.find_first_of(',',start))!=std::string::npos){
            broadcaster.push_back(line.substr(start,end-start));
            start=end+2;
         }
         broadcaster.push_back(line.substr(start));
      }
   }
   for(const std::pair<std::string,FlipFlop> &entry:flipFlops){
      for(const std::string &name:entry.second.names){
         if(conjunctions.contains(name)){
            conjunctions.find(name)->second.memory.insert({entry.first,false});
         }
      }
   }
   for(const std::pair<std::string,Conjunction> &entry:conjunctions){
      for(const std::string &name:entry.second.names){
         if(conjunctions.contains(name)){
            conjunctions.find(name)->second.memory.insert({entry.first,false});
         }
      }
   }
   llint count=0;
   while(true){
      std::vector<Pulse>pulses;
      for(const std::string &name:broadcaster){
         pulses.push_back({false,"broadcaster",name});
      }
      count++;
      llint countRx=0;
      while(!pulses.empty()){
         std::vector<Pulse>newPulses;
         for(const Pulse &pulse:pulses){
            if(conjunctions.contains(pulse.to)){
               Conjunction &conjunction=conjunctions.find(pulse.to)->second;
               conjunction.memory.find(pulse.from)->second=pulse.isHigh;
               bool sendLow=std::all_of(conjunction.memory.cbegin(),conjunction.memory.cend(),[](const std::pair<std::string,bool> &entry){return entry.second;});
               for(const std::string &name:conjunction.names){
                  newPulses.push_back({!sendLow,pulse.to,name});
               }
            } else if(!pulse.isHigh){
               FlipFlop &flipFlop=flipFlops.find(pulse.to)->second;
               flipFlop.isOn=!flipFlop.isOn;
               for(const std::string &name:flipFlop.names){
                  newPulses.push_back({flipFlop.isOn,pulse.to,name});
               }
            }
            if(pulse.to=="vr"&&pulse.isHigh){
               std::clog<<count<<' '<<pulse.from<<' '<<pulse.to<<'\n';
            }
            if(pulse.to=="rx"&&!pulse.isHigh){
               countRx++;
            }
         }
         pulses=newPulses;
      }
      if(countRx==1){
         break;
      }
   }
   return count;
}
int main(){
   constexpr bool logToFile=false;
   constexpr llint doWarming=0;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=false;
   constexpr bool doInput2=true;

   Input example1={
      "broadcaster -> a, b, c",
      "%a -> b",
      "%b -> c",
      "%c -> inv",
      "&inv -> a"
   };

   Input example2=example1;

   Input input;
   std::ifstream inputFile("input");
   Line line;
   while(std::getline(inputFile,line)){
      input.push_back(line);
   }
   inputFile.close();

   volatile llint result=0;
   for(llint warming=0;warming<doWarming;warming++){
      result=(doExample1?solve1(example1):-1)+(doInput1?solve1(input):-1)
         +(doExample2?solve2(example2):-1)+(doInput2?solve2(input):-1);
   }

   t_t time0,time1,time2,time3,time4;
   decltype(solve1(example1))answer1example=-1;
   decltype(solve1(input))answer1input=-1;
   decltype(solve1(example2))answer2example=-1;
   decltype(solve1(input))answer2input=-1;

   std::ofstream log;
   std::streambuf *coutBuf;
   if constexpr(logToFile){
      log.open("log.txt");
      coutBuf=std::cout.rdbuf();
      std::cout.rdbuf(log.rdbuf());
   }

   time0=getTime();
   if constexpr(doExample1){
      answer1example=solve1(example1);
   }
   time1=getTime();
   if constexpr(doInput1){
      answer1input=solve1(input);
   }
   time2=getTime();
   if constexpr(doExample2){
      answer2example=solve2(example2);
   }
   time3=getTime();
   if constexpr(doInput2){
      answer2input=solve2(input);
   }
   time4=getTime();

   if constexpr(logToFile){
      std::cout.rdbuf(coutBuf);
      log.close();
   }

   std::cout<<"Example 1 took "<<getDurationMs(time0,time1)<<"ms: "<<answer1example<<'\n';
   std::cout<<"Input   1 took "<<getDurationMs(time1,time2)<<"ms: "<<(answer1input)<<'\n';
   std::cout<<"Example 2 took "<<getDurationMs(time2,time3)<<"ms: "<<answer2example<<'\n';
   std::cout<<"Input   2 took "<<getDurationMs(time3,time4)<<"ms: "<<(answer2input)<<'\n';
}
