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

#include<algorithm>
#include<numeric>
std::vector<llint>parseLine(const std::string &_line){
   std::istringstream line{_line};
   std::vector<llint>numbers;
   llint number;
   while(line>>number){
      numbers.push_back(number);
   }
   return numbers;
}
llint getNext(const std::vector<llint>positions){
   std::vector<llint>velocities(positions.size());
   std::adjacent_difference(positions.cbegin(),positions.cend(),velocities.begin());
   velocities.erase(velocities.cbegin());
   if(std::all_of(velocities.cbegin(),velocities.cend(),[](llint i){return i==0;})){
      return 0;
   } else{
      return velocities.back()+getNext(velocities);
   }
}
llint getPrevious(const std::vector<llint>positions){
   if(positions.size()==1)return 0;
   std::vector<llint>velocities(positions.size());
   std::adjacent_difference(positions.cbegin(),positions.cend(),velocities.begin());
   velocities.erase(velocities.cbegin());
   if(std::all_of(velocities.cbegin(),velocities.cend(),[](llint i){return i==0;})){
      return 0;
   } else{
      return velocities.front()-getPrevious(velocities);
   }
}
llint solve1(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      std::vector<llint>positions=parseLine(line);
      sum+=positions.back()+getNext(positions);
   }
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      std::vector<llint>positions=parseLine(line);
      sum+=positions.front()-getPrevious(positions);
   }
   return sum;
}
int main(){
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   std::vector<std::string>example1={
      "0 3 6 9 12 15",
      "1 3 6 10 15 21",
      "10 13 16 21 30 45"
   };

   std::vector<std::string>example2=example1;

   std::ifstream inputFile("input");
   std::vector<std::string>input;
   std::string line;
   while(std::getline(inputFile,line)){
      input.push_back(line);
   }

   t_t time0=getTime();
   auto answer1example=doExample1?solve1(example1):-1;
   t_t time1=getTime();
   auto answer1input=doInput1?solve1(input):-1;
   t_t time2=getTime();
   auto answer2example=doExample2?solve2(example2):-1;
   t_t time3=getTime();
   auto answer2input=doInput2?solve2(input):-1;
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
