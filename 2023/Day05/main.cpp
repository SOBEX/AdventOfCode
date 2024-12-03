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

#include<limits>
#include<utility>
llint solve1(const std::vector<std::string> &input){
   std::vector<llint>source;
   std::vector<llint>destination;
   bool isFirst=true;
   bool isStart=false;
   for(const std::string &_line:input){
      std::istringstream line{_line};
      if(isFirst){
         isFirst=false;
         line.ignore(7);
         llint seed;
         while(line>>seed){
            destination.push_back(seed);
         }
      } else if(_line.length()==0){
         isStart=true;
         for(llint s:source){
            destination.push_back(s);
         }
         source.clear();
      } else if(isStart){
         isStart=false;
         for(llint d:destination){
            source.push_back(d);
         }
         destination.clear();
      } else{
         llint destinationRange,sourceRange,rangeLength;
         line>>destinationRange>>sourceRange>>rangeLength;
         for(auto it=source.begin();it!=source.end();){
            llint s=*it;
            if(sourceRange<=s&&s<sourceRange+rangeLength){
               destination.push_back(s-sourceRange+destinationRange);
               it=source.erase(it);
            } else{
               it++;
            }
         }
      }
   }
   llint min=std::numeric_limits<llint>::max();
   for(llint s:source){
      if(s<min){
         min=s;
      }
   }
   for(llint d:destination){
      if(d<min){
         min=d;
      }
   }
   return min;
}
llint solve2(const std::vector<std::string> &input){
   using llintp=std::pair<llint,llint>;
   std::vector<llintp>source;
   std::vector<llintp>destination;
   bool isFirst=true;
   bool isStart=false;
   for(const std::string &_line:input){
      std::istringstream line{_line};
      if(isFirst){
         isFirst=false;
         line.ignore(7);
         llintp seed;
         while(line>>seed.first>>seed.second){
            seed.second+=seed.first;
            destination.push_back(seed);
         }
      } else if(_line.length()==0){
         isStart=true;
         for(llintp s:source){
            destination.push_back(s);
         }
         source.clear();
      } else if(isStart){
         isStart=false;
         for(llintp d:destination){
            source.push_back(d);
         }
         destination.clear();
      } else{
         llint destinationRange,sourceRange,rangeLength;
         line>>destinationRange>>sourceRange>>rangeLength;
         for(int i=0;i<source.size();){
            llintp s=source[i];
            llint start=s.first;
            llint end=s.second;
            llint sStart=sourceRange;
            llint sEnd=sourceRange+rangeLength;
            llint mapping=sourceRange-destinationRange;
            if(sStart<=start){
               if(sEnd<=start){
                  i++;
               } else if(sEnd<end){
                  destination.emplace_back(start-mapping,sEnd-mapping);
                  source.emplace_back(sEnd,end);
                  source.erase(source.begin()+i);
               } else{
                  destination.emplace_back(start-mapping,end-mapping);
                  source.erase(source.begin()+i);
               }
            } else if(sStart<end){
               if(sEnd<end){
                  source.emplace_back(start,sStart);
                  destination.emplace_back(sStart-mapping,sEnd-mapping);
                  source.emplace_back(sEnd,end);
                  source.erase(source.begin()+i);
               } else{
                  source.emplace_back(start,sStart);
                  destination.emplace_back(sStart-mapping,end-mapping);
                  source.erase(source.begin()+i);
               }
            } else{
               i++;
            }
         }
      }
   }
   llint min=std::numeric_limits<llint>::max();
   for(llintp s:source){
      if(s.first<min){
         min=s.first;
      }
   }
   for(llintp d:destination){
      if(d.first<min){
         min=d.first;
      }
   }
   return min;
}
int main(){
   std::vector<std::string>example1={
      "seeds: 79 14 55 13",
      "",
      "seed-to-soil map:",
      "50 98 2",
      "52 50 48",
      "",
      "soil-to-fertilizer map:",
      "0 15 37",
      "37 52 2",
      "39 0 15",
      "",
      "fertilizer-to-water map:",
      "49 53 8",
      "0 11 42",
      "42 0 7",
      "57 7 4",
      "",
      "water-to-light map:",
      "88 18 7",
      "18 25 70",
      "",
      "light-to-temperature map:",
      "45 77 23",
      "81 45 19",
      "68 64 13",
      "",
      "temperature-to-humidity map:",
      "0 69 1",
      "1 0 69",
      "",
      "humidity-to-location map:",
      "60 56 37",
      "56 93 4"};

   std::vector<std::string>example2=example1;

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
