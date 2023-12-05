#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<vector>
#include<limits>
#include<utility>
using llint=long long int;
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

   std::cout<<solve1(example1)<<'\n';
   std::cout<<solve1(input)<<'\n';

   std::cout<<solve2(example2)<<'\n';
   std::cout<<solve2(input)<<'\n';
}
