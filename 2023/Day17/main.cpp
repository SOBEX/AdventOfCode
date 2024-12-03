#include<array>
#include<chrono>
#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<utility>
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
};
using Cell=llint;
using Row=std::vector<Cell>;
using Map=std::vector<Row>;
#include<algorithm>
#include<cmath>
#include<map>
#include<queue>
enum class Direction{
   NORTH,EAST,SOUTH,WEST
};
Map getMap(const Input &input){
   Map map;
   for(const Line &line:input){
      Row row;
      for(char c:line){
         row.push_back(c-'0');
      }
      map.push_back(row);
   }
   return map;
}
using Cost=std::map<std::pair<Direction,llint>,llint>;
using Costs=std::vector<std::vector<Cost>>;
struct Adjacent{
   Position position;
   Direction direction;
};
llint solve1(const Input &input){
   Map map=getMap(input);
   llint width=map[0].size();
   llint height=map.size();
   Costs costs(height,std::vector<Cost>(width));
   costs[height-1][width-1].insert({{Direction::EAST,0},0});
   costs[height-1][width-1].insert({{Direction::SOUTH,0},0});
   std::queue<Position>positions;
   positions.push(Position(width-1,height-1));
   while(!positions.empty()){
      Position position=positions.front();
      positions.pop();
      const Cost &positionCost=position.indexInto(costs);
      llint additionalCost=position.indexInto(map);
      std::array<Adjacent,4>adjacents{
         Adjacent(Position(position.x,position.y+1),Direction::NORTH),
         Adjacent(Position(position.x-1,position.y),Direction::EAST),
         Adjacent(Position(position.x,position.y-1),Direction::SOUTH),
         Adjacent(Position(position.x+1,position.y),Direction::WEST)
      };
      for(const Adjacent &adjacent:adjacents){
         if(adjacent.position.isIn(width,height)){
            bool needsUpdate=false;
            Cost &adjacentCost=adjacent.position.indexInto(costs);
            for(auto &it:positionCost){
               Direction newDirection=adjacent.direction;
               if(std::abs((int)it.first.first-(int)adjacent.direction)!=2){
                  llint newLength=it.first.first==newDirection?it.first.second+1:1;
                  if(newLength<=3){
                     llint newCost=it.second+additionalCost;
                     auto found=adjacentCost.find({newDirection,newLength});
                     if(found==adjacentCost.end()){
                        adjacentCost.insert({{newDirection,newLength},newCost});
                        needsUpdate=true;
                     } else if(newCost<found->second){
                        found->second=newCost;
                        needsUpdate=true;
                     }
                  }
               }
            }
            if(needsUpdate){
               positions.push(adjacent.position);
            }
         }
      }
   }
   llint min=10*width*height;
   for(const auto &it:costs[0][0]){
      if(it.second<min){
         min=it.second;
      }
   }
   return min;
}
llint solve2(const std::vector<std::string> &input){
   Map map=getMap(input);
   llint width=map[0].size();
   llint height=map.size();
   Costs costs(height,std::vector<Cost>(width));
   costs[height-1][width-1].insert({{Direction::EAST,0},0});
   costs[height-1][width-1].insert({{Direction::EAST,1},0});
   costs[height-1][width-1].insert({{Direction::EAST,2},0});
   costs[height-1][width-1].insert({{Direction::EAST,3},0});
   costs[height-1][width-1].insert({{Direction::EAST,4},0});
   costs[height-1][width-1].insert({{Direction::SOUTH,0},0});
   costs[height-1][width-1].insert({{Direction::SOUTH,1},0});
   costs[height-1][width-1].insert({{Direction::SOUTH,2},0});
   costs[height-1][width-1].insert({{Direction::SOUTH,3},0});
   costs[height-1][width-1].insert({{Direction::SOUTH,4},0});
   std::queue<Position>positions;
   positions.push(Position(width-1,height-1));
   while(!positions.empty()){
      Position position=positions.front();
      positions.pop();
      const Cost &positionCost=position.indexInto(costs);
      llint additionalCost=position.indexInto(map);
      std::array<Adjacent,4>adjacents{
         Adjacent(Position(position.x,position.y+1),Direction::NORTH),
         Adjacent(Position(position.x-1,position.y),Direction::EAST),
         Adjacent(Position(position.x,position.y-1),Direction::SOUTH),
         Adjacent(Position(position.x+1,position.y),Direction::WEST)
      };
      for(const Adjacent &adjacent:adjacents){
         if(adjacent.position.isIn(width,height)){
            bool needsUpdate=false;
            Cost &adjacentCost=adjacent.position.indexInto(costs);
            for(auto &it:positionCost){
               Direction newDirection=adjacent.direction;
               if(std::abs((int)it.first.first-(int)adjacent.direction)!=2){
                  llint newLength=it.first.first==newDirection?it.first.second+1:1;
                  if((it.first.first==newDirection||4<=it.first.second)&&newLength<=10){
                     llint newCost=it.second+additionalCost;
                     auto found=adjacentCost.find({newDirection,newLength});
                     if(found==adjacentCost.end()){
                        adjacentCost.insert({{newDirection,newLength},newCost});
                        needsUpdate=true;
                     } else if(newCost<found->second){
                        found->second=newCost;
                        needsUpdate=true;
                     }
                  }
               }
            }
            if(needsUpdate){
               positions.push(adjacent.position);
            }
         }
      }
   }
   llint min=10*width*height;
   for(const auto &it:costs[0][0]){
      if(4<=it.first.second&&it.second<min){
         min=it.second;
      }
   }
   return min;
}
int main(){
   constexpr llint doWarming=0;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   Input example1={
      "2413432311323",
      "3215453535623",
      "3255245654254",
      "3446585845452",
      "4546657867536",
      "1438598798454",
      "4457876987766",
      "3637877979653",
      "4654967986887",
      "4564679986453",
      "1224686865563",
      "2546548887735",
      "4322674655533"
   };

   Input example2=example1;

   Input input;
   {
      std::ifstream inputFile("input");
      Line line;
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
