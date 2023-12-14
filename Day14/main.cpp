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

#include<algorithm>
#include<utility>
enum class Rock:char{
   Empty='.',Cube='#',Round='O'
};
using Row=std::vector<Rock>;
using Platform=std::vector<Row>;
Platform getPlatform(const std::vector<std::string> &input){
   Platform platform;
   for(const std::string &line:input){
      Row row;
      for(char c:line){
         row.push_back(Rock(c));
      }
      platform.push_back(row);
   }
   return platform;
}
template<llint dy,llint dx>llint tryTilt(Platform &platform,llint y,llint x){
   using enum Rock;
   if(platform[y][x]==Round){
      while(0<=y+dy&&y+dy<platform.size()&&0<=x+dx&&x+dx<platform[0].size()&&platform[y+dy][x+dx]==Empty){
         std::swap(platform[y][x],platform[y+dy][x+dx]);
         y+=dy;
         x+=dx;
      }
      return platform.size()-y;
   }
   return 0;
}
llint tiltNorth(Platform &platform){
   llint sum=0;
   for(llint y=0;y<platform.size();y++){
      for(llint x=0;x<platform[0].size();x++){
         sum+=tryTilt<-1,0>(platform,y,x);
      }
   }
   return sum;
}
llint tiltWest(Platform &platform){
   llint sum=0;
   for(llint x=0;x<platform[0].size();x++){
      for(llint y=platform.size();y-->0;){
         sum+=tryTilt<0,-1>(platform,y,x);
      }
   }
   return sum;
}
llint tiltSouth(Platform &platform){
   llint sum=0;
   for(llint y=platform.size();y-->0;){
      for(llint x=platform[0].size();x-->0;){
         sum+=tryTilt<1,0>(platform,y,x);
      }
   }
   return sum;
}
llint tiltEast(Platform &platform){
   llint sum=0;
   for(llint x=platform[0].size();x-->0;){
      for(llint y=0;y<platform.size();y++){
         sum+=tryTilt<0,1>(platform,y,x);
      }
   }
   return sum;
}
llint tiltAround(Platform &platform){
   std::vector<std::pair<Platform,llint>>previous;
   llint sum=0;
   for(llint i=1'000'000'000;i-->0;){
      tiltNorth(platform);
      tiltWest(platform);
      tiltSouth(platform);
      sum=tiltEast(platform);
      for(llint j=previous.size(),k=1;j-->0;k++){
         if(platform==previous[j].first){
            return previous[j+(i%k)].second;
         }
      }
      previous.push_back({platform,sum});
   }
   return sum;
}
llint solve1(const std::vector<std::string> &input){
   Platform platform=getPlatform(input);
   return tiltNorth(platform);
}
llint solve2(const std::vector<std::string> &input){
   Platform platform=getPlatform(input);
   return tiltAround(platform);
}
int main(){
   constexpr llint doWarming=100;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   std::vector<std::string>example1={
      "O....#....",
      "O.OO#....#",
      ".....##...",
      "OO.#O....O",
      ".O.....O#.",
      "O.#..O.#.#",
      "..O..#O..O",
      ".......O..",
      "#....###..",
      "#OO..#...."
   };

   std::vector<std::string>example2=example1;

   std::vector<std::string>input;
   {
      std::ifstream inputFile("input");
      std::string line;
      while(std::getline(inputFile,line)){
         input.push_back(line);
      }
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
