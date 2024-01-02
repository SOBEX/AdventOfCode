#include<array>
#include<chrono>
#include<fstream>
#include<iostream>
#include<limits>
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
constexpr llint LLINTMIN=std::numeric_limits<llint>::min();
constexpr llint LLINTMAX=std::numeric_limits<llint>::max();
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
using Cell=llint;
using Row=std::vector<Cell>;
using Board=std::vector<Row>;

llint solve1(const Input &input){
   llint sum=0;
   for(const Line &_line:input){
      std::istringstream line{_line};
   }
   return sum;
}
llint solve2(const Input &input){
   llint sum=0;
   for(const Line &_line:input){
      std::istringstream line{_line};
   }
   return sum;
}
int main(){
   constexpr bool logToFile=false;
   constexpr llint doWarming=0;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   Input example1={
      "",
      ""
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
