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

#include<array>
enum class Direction{
   NONE=0b0000,N=0b1000,E=0b0100,S=0b0010,W=0b0001
};
std::array<Direction,4>directions{Direction::N,Direction::E,Direction::S,Direction::W};
enum class Pipe{
   V=0b1010,H=0b0101,L=0b1100,J=0b1001,SEVEN=0b0011,F=0b0110,DOT=0b0000,S=0b1111
};
struct Position{
   llint x;
   llint y;
};
using Row=std::vector<Pipe>;
using Board=std::vector<Row>;
using Bitrow=std::vector<bool>;
using Bitmask=std::vector<Bitrow>;
Pipe mapPipe(char c){
   using enum Pipe;
   switch(c){
   case '|':
      return V;
   case '-':
      return H;
   case 'L':
      return L;
   case 'J':
      return J;
   case '7':
      return SEVEN;
   case 'F':
      return F;
   case 'S':
      return S;
   case '.':
   default:
      return DOT;
   }
}
Direction flip(Direction d){
   return Direction((((char)d<<2)|((char)d>>2))&0b1111);
}
Direction turn(Direction d,Pipe p){
   return Direction((char)flip(d)^(char)p);
}
Position walk(Position p,Direction d){
   using enum Direction;
   switch(d){
   case N:
      return Position{p.x,p.y-1};
   case E:
      return Position{p.x+1,p.y};
   case S:
      return Position{p.x,p.y+1};
   case W:
      return Position{p.x-1,p.y};
   case NONE:
   default:
      return p;
   }
}
std::pair<Board,Position>parseInput(const std::vector<std::string> &input){
   Board board;
   Position startPosition={-1,-1};
   for(llint y=0;y<input.size();y++){
      Row row;
      for(llint x=0;x<input[y].size();x++){
         Pipe p=mapPipe(input[y][x]);
         if(p==Pipe::S){
            startPosition={x,y};
         }
         row.push_back(p);
      }
      board.push_back(row);
   }
   return {board,startPosition};
}
std::pair<Direction,llint>findLoop(const Board &board,Position startPosition){
   for(Direction startDirection:directions){
      Position current=startPosition;
      Direction direction=startDirection;
      llint steps=0;
      while(true){
         steps++;
         current=walk(current,direction);
         if(!(0<=current.y&&current.y<board.size()&&0<=current.x&&current.x<board[current.y].size())){
            break;
         }
         Pipe pipe=board[current.y][current.x];
         if(pipe==Pipe::S){
            return {startDirection,steps};
         } else if(pipe==Pipe::DOT||!((char)flip(direction)&(char)pipe)){
            break;
         }
         direction=turn(direction,pipe);
      }
   }
   return {Direction::NONE,-1};
}
Bitmask getBitmask(Board &board,Position startPosition,Direction startDirection){
   Bitmask isPipes(board.size(),Bitrow(board[0].size(),false));
   Position current=startPosition;
   Direction direction=startDirection;
   while(true){
      isPipes[current.y][current.x]=true;
      current=walk(current,direction);
      Pipe pipe=board[current.y][current.x];
      if(pipe==Pipe::S){
         board[current.y][current.x]=Pipe((char)startDirection&(char)flip(direction));
         return isPipes;
      }
      direction=turn(direction,pipe);
   }
}
llint countInside(const Board &board,const Bitmask &isPipes){
   llint count=0;
   for(llint y=0;y<isPipes.size();y++){
      bool isInside=false;
      bool cameFromNorth=false;
      bool cameFromSouth=false;
      for(llint x=0;x<isPipes[y].size();x++){
         if(isPipes[y][x]){
            Pipe p=board[y][x];
            if(p==Pipe::V){
               isInside=!isInside;
               cameFromNorth=false;
               cameFromSouth=false;
            } else{
               bool goingToNorth=((char)p&(char)Direction::N);
               bool goingToSouth=((char)p&(char)Direction::S);
               if(!cameFromNorth&&!cameFromSouth){
                  cameFromNorth=goingToNorth;
                  cameFromSouth=goingToSouth;
               } else if((cameFromNorth&&goingToNorth)||(cameFromSouth&&goingToSouth)){
                  cameFromNorth=false;
                  cameFromSouth=false;
               } else if((cameFromNorth&&goingToSouth)||(cameFromSouth&&goingToNorth)){
                  isInside=!isInside;
                  cameFromNorth=false;
                  cameFromSouth=false;
               }
            }
         } else{
            if(isInside){
               count++;
            }
         }
      }
   }
   return count;
}
llint solve1(const std::vector<std::string> &input){
   auto [board,startPosition]=parseInput(input);
   return findLoop(board,startPosition).second/2;
}
llint solve2(const std::vector<std::string> &input){
   auto [board,startPosition]=parseInput(input);
   Position current{0,0};
   Direction startDirection=findLoop(board,startPosition).first;
   if(startDirection==Direction::NONE){
      return -1;
   }
   Bitmask isPipes=getBitmask(board,startPosition,startDirection);
   return countInside(board,isPipes);
}
int main(){
   constexpr llint doWarming=1000;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   std::vector<std::string>example1={
      "7-F7-",
      ".FJ|7",
      "SJLL7",
      "|F--J",
      "LJ.LJ"
   };

   std::vector<std::string>example2={
      "FF7FSF7F7F7F7F7F---7",
      "L|LJ||||||||||||F--J",
      "FL-7LJLJ||||||LJL-77",
      "F--JF--7||LJLJ7F7FJ-",
      "L---JF-JLJ.||-FJLJJ7",
      "|F|F-JF---7F7-L7L|7|",
      "|FFJF7L7F-JF7|JL---7",
      "7-L-JL7||F7|L7F-7F7|",
      "L.L7LFJ|||||FJL7||LJ",
      "L7JLJL-JLJLJL--JLJ.L"
   };

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
