#include<array>
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
using llint=long long int;

#include<cmath>
#include<utility>
using Galaxy=std::pair<llint,llint>;
using Galaxies=std::vector<Galaxy>;
template<llint expansion>Galaxies getGalaxies(const std::vector<std::string> &input){
   llint height=input.size();
   llint width=input[0].size();
   std::vector<bool>isYEmpty(height,true);
   std::vector<bool>isXEmpty(width,true);
   llint galaxyCount=0;
   for(llint y=0;y<height;y++){
      for(llint x=0;x<height;x++){
         if(input[y][x]=='#'){
            isYEmpty[y]=false;
            isXEmpty[x]=false;
            galaxyCount++;
         }
      }
   }
   Galaxies galaxies(galaxyCount);
   llint galaxyIndex=0;
   for(llint y=0,yy=0;y<height;yy+=isYEmpty[y++]?expansion:1){
      for(llint x=0,xx=0;x<height;xx+=isXEmpty[x++]?expansion:1){
         if(input[y][x]=='#'){
            galaxies[galaxyIndex++]={xx,yy};
         }
      }
   }
   return galaxies;
}
llint sumDistances(const Galaxies &galaxies){
   llint sum=0;
   for(llint i=0;i<galaxies.size()-1;i++){
      Galaxy first=galaxies[i];
      for(llint j=i+1;j<galaxies.size();j++){
         Galaxy second=galaxies[j];
         sum+=std::abs(second.first-first.first)+std::abs(second.second-first.second);
      }
   }
   return sum;
}
llint solve1(const std::vector<std::string> &input){
   return sumDistances(getGalaxies<2>(input));
}
llint solve2(const std::vector<std::string> &input){
   return sumDistances(getGalaxies<1000000>(input));
}
int main(){
   constexpr llint doWarming=10000;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   std::vector<std::string>example1={
      "...#......",
      ".......#..",
      "#.........",
      "..........",
      "......#...",
      ".#........",
      ".........#",
      "..........",
      ".......#..",
      "#...#....."
   };

   std::vector<std::string>example2=example1;

   std::ifstream inputFile("input");
   std::vector<std::string>input;
   std::string line;
   while(std::getline(inputFile,line)){
      input.push_back(line);
   }

   llint result=0;
   for(llint warming=0;warming<doWarming;warming++){
      result=(doExample1?solve1(example1):-1)+(doInput1?solve1(input):-1)
         +(doExample2?solve2(example2):-1)+(doInput2?solve2(input):-1);
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

   std::cout<<"Example 1 took "<<getDurationMs(time0,time1)<<"ms: "<<answer1example<<'\n';
   std::cout<<"Input   1 took "<<getDurationMs(time1,time2)<<"ms: "<<(answer1input)<<'\n';
   std::cout<<"Example 2 took "<<getDurationMs(time2,time3)<<"ms: "<<answer2example<<'\n';
   std::cout<<"Input   2 took "<<getDurationMs(time3,time4)<<"ms: "<<(answer2input)<<'\n';
}
