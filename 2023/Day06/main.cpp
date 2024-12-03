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

llint doRace(llint time, llint distance){
   llint wins=0;
   for(llint held=0;held<time;held++){
      llint speed=held;
      llint pos=speed*(time-held);
      if(pos>distance){
         wins++;
      }
   }
   return wins;
}
llint solve1(const std::vector<std::string> &input){
   std::vector<llint>times;
   std::vector<llint>distances;
   std::istringstream timesStream{input[0]};
   std::istringstream distancesStream{input[1]};
   timesStream.ignore(5);
   distancesStream.ignore(9);
   llint number;
   while(timesStream>>number){
      times.push_back(number);
   }
   while(distancesStream>>number){
      distances.push_back(number);
   }
   llint sum=1;
   for(llint i=0;i<times.size();i++){
      sum*=doRace(times[i],distances[i]);
   }
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   std::vector<llint>times;
   std::vector<llint>distances;
   std::istringstream timesStream{input[0]};
   std::istringstream distancesStream{input[1]};
   timesStream.ignore(5);
   distancesStream.ignore(9);
   std::stringstream timesParser;
   std::stringstream distanceParser;
   llint number;
   while(timesStream>>number){
      timesParser<<number;
   }
   while(distancesStream>>number){
      distanceParser<<number;
   }
   timesParser>>number;
   times.push_back(number*100);
   distanceParser>>number;
   distances.push_back(number);
   llint sum=1;
   for(llint i=0;i<times.size();i++){
      sum*=doRace(times[i],distances[i]);
   }
   return sum;
}
int main(){
   std::vector<std::string>example1={
      "Time:      7  15   30",
      "Distance:  9  40  200"
   };

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
