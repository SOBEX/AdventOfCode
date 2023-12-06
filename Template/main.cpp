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

llint solve1(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &_line:input){
      std::istringstream line{_line};
   }
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &_line:input){
      std::istringstream line{_line};
   }
   return sum;
}
int main(){
   std::vector<std::string>example1={
      "",
      ""
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
