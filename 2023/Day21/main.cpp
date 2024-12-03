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
#include<algorithm>
#include<cmath>
#include<functional>
#include<iomanip>
#include<map>
#include<numeric>
#include<queue>
enum class Plot:char{
   Start='S',Garden='.',Rock='#'
};
using Row=std::vector<Plot>;
using Board=std::vector<Row>;
std::pair<Board,Position>parseInput(const Input &input){
   Board board;
   Position start{-1,-1};
   Position current;
   for(current.y=0;current.y<input.size();current.y++){
      Row row;
      for(current.x=0;current.x<input[current.y].size();current.x++){
         if(current.indexInto(input)=='S'){
            start=current;
         }
         row.push_back((Plot)current.indexInto(input));
      }
      board.push_back(row);
   }
   return {board,start};
}
using DistanceRow=std::vector<llint>;
using Distances=std::vector<DistanceRow>;
Distances getDistances(const Board &board,Position start){
   Distances distances(board.size(),DistanceRow(board[0].size(),LLINTMAX));
   start.indexInto(distances)=0;
   std::queue<Position>positions;
   positions.push(start);
   while(!positions.empty()){
      Position current=positions.front();
      positions.pop();
      llint newDistance=current.indexInto(distances)+1;
      std::array<Position,4>adjacents{{{current.x,current.y-1},{current.x+1,current.y},{current.x,current.y+1},{current.x-1,current.y}}};
      for(Position adjacent:adjacents){
         if(adjacent.isIn(board)&&adjacent.indexInto(board)!=Plot::Rock&&newDistance<adjacent.indexInto(distances)){
            adjacent.indexInto(distances)=newDistance;
            positions.push(adjacent);
         }
      }
   }
   return distances;
}
llint solve1(const Input &input){
   auto [board,start]=parseInput(input);
   Distances distances=getDistances(board,start);
   return std::transform_reduce(distances.cbegin(),distances.cend(),0ll,std::plus(),[](const DistanceRow &row){
      return std::count_if(row.cbegin(),row.cend(),[](llint distance){return distance<=64&&distance%2==0;});
      });
}
llint solve2(const Input &input){
   auto [board,start]=parseInput(input);
   //print 1x1
   if(false){
      std::cout<<"1x1:\n";
      for(const Row &row:board){
         for(const Plot &plot:row){
            std::cout<<(char)plot;
         }
         std::cout<<'\n';
      }
      std::cout<<std::endl;
   }
   llint height=board.size();
   llint width=board[0].size();
   //print NxN
   if(false){
      Board _board=board;
      llint side=4;
      llint mult=2*side+1;
      for(Row &row:_board){
         row.reserve(mult*width);
         for(llint i=1;i<mult;i++){
            row.insert(row.end(),row.begin(),row.begin()+width);
         }
      }
      _board.reserve(mult*height);
      for(llint i=1;i<mult;i++){
         _board.insert(_board.end(),_board.begin(),_board.begin()+height);
      }
      Distances distances=getDistances(_board,{start.x+side*width,start.y+side*height});
      std::cout<<mult<<'x'<<mult<<'\n';
      for(const DistanceRow &row:distances){
         for(llint distance:row){
            std::cout<<std::setw(4)<<(distance!=LLINTMAX?distance:-1);
         }
         std::cout<<'\n';
      }
      std::cout<<std::endl;
   }
   llint side=3;//magic variable
   llint mult=2*side+1;
   for(Row &row:board){
      row.reserve(mult*width);
      for(llint i=1;i<mult;i++){
         row.insert(row.end(),row.begin(),row.begin()+width);
      }
   }
   board.reserve(mult*height);
   for(llint i=1;i<mult;i++){
      board.insert(board.end(),board.begin(),board.begin()+height);
   }
   Distances distances=getDistances(board,{start.x+side*width,start.y+side*height});
   //print distance differences for middle row
   if(false){
      std::cout<<mult<<'x'<<'['<<side<<']'<<'\n';
      for(llint y=side*height;y<(side+1)*height;y++){
         for(llint x=0;x<(mult-1)*width;x++){
            std::cout<<std::setw(4)<<(distances[y][x]-distances[y][x+width]);
         }
         std::cout<<'\n';
      }
      std::cout<<std::endl;
   }
   llint limit=26501365;
   llint modded=limit%2;
   auto checkDistance=[&limit,&modded](llint distance){return distance<=limit&&distance%2==modded;};
   llint count=std::transform_reduce(distances.cbegin(),distances.cend(),0ll,std::plus(),[&checkDistance](const DistanceRow &row){return std::count_if(row.cbegin(),row.cend(),checkDistance);});
   if(width!=height){
      std::cout<<"Sorry, I'm assuming height==width.\n";
   };
   std::array<Position,4>corners{{{0,0},{0,(mult-1)*height},{(mult-1)*width,0},{(mult-1)*width,(mult-1)*height}}};
   for(Position corner:corners){
      for(llint y=0;y<height;y++){
         for(llint x=0;x<width;x++){
            llint base=distances[corner.y+y][corner.x+x];
            llint innerCount=0;
            if(base!=LLINTMAX){
               if(width%2==1){
                  for(llint dy=height;dy<=limit-base;dy+=height){
                     llint innerBase=base+dy;
                     if(innerBase%2==modded){
                        innerCount+=(limit-innerBase)/width/2;
                     } else{
                        innerCount+=((limit-innerBase)/width+1)/2;
                     }
                  }
               } else if(base%2==modded){
                  for(llint dy=height;dy<=limit-base;dy+=height){
                     llint innerBase=base+dy;
                     for(llint dx=width;dx<=limit-innerBase;dx+=width){
                        if(checkDistance(innerBase+dx)){
                           innerCount++;
                        }
                     }
                  }
               }
            }
            count+=innerCount;
            //std::cout<<std::setw(4)<<innerCount;
         }
         //std::cout<<'\n';
      }
      //std::cout<<std::endl;
   }
   std::vector<Position>sides;
   sides.reserve(4*mult);
   for(llint i=0;i<mult;i++){
      sides.push_back({i*width,0});
      sides.push_back({0,i*height});
      sides.push_back({(mult-1)*width,i*height});
      sides.push_back({i*width,(mult-1)*height});
   }
   for(Position side:sides){
      for(llint y=0;y<height;y++){
         for(llint x=0;x<width;x++){
            llint base=distances[side.y+y][side.x+x];
            llint innerCount=0;
            if(base!=LLINTMAX){
               if(height%2==1){
                  if(base%2==modded){
                     innerCount=(limit-base)/height/2;
                  } else{
                     innerCount=((limit-base)/height+1)/2;
                  }
               } else if(base%2==modded){
                  for(llint dy=height;dy<=limit-base;dy+=height){
                     if(checkDistance(base+dy)){
                        innerCount++;
                     }
                  }
               }
            }
            count+=innerCount;
            //std::cout<<std::setw(4)<<innerCount;
         }
         //std::cout<<'\n';
      }
      //std::cout<<std::endl;
   }
   return count;
}
int main(){
   constexpr bool logToFile=false;
   constexpr llint doWarming=0;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   Input example1={
      "...........",
      ".....###.#.",
      ".###.##..#.",
      "..#.#...#..",
      "....#.#....",
      ".##..S####.",
      ".##..#...#.",
      ".......##..",
      ".##.#.####.",
      ".##..##.##.",
      "..........."
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
