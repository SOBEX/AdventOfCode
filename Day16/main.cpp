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
#include<iterator>
#include<numeric>
enum class Direction{
   NORTH=0b1000,EAST=0b0100,SOUTH=0b0010,WEST=0b0001
};
std::array<Direction,4>directions{Direction::NORTH,Direction::EAST,Direction::SOUTH,Direction::WEST};
enum class Mirror{
   EMPTY=0,VERTICAL=1,HORIZONTAL=2,FORWARD=3,BACKWARD=4
};
std::array<Direction,20>mirroring{
   /*                   going North       going East        going South       going West*/
   /* . Empty         */Direction(0b1000),Direction(0b0100),Direction(0b0010),Direction(0b0001),
   /* | Vertical      */Direction(0b1000),Direction(0b1010),Direction(0b0010),Direction(0b1010),
   /* - Horizontal    */Direction(0b0101),Direction(0b0100),Direction(0b0101),Direction(0b0001),
   /* / Forward slash */Direction(0b0100),Direction(0b1000),Direction(0b0001),Direction(0b0010),
   /* \ Backward slash*/Direction(0b0001),Direction(0b0010),Direction(0b0100),Direction(0b1000)
};
struct Position{
   llint x;
   llint y;
};
using Row=std::vector<Mirror>;
using Board=std::vector<Row>;
using Bitrow=std::vector<bool>;
using Bitmask=std::vector<Bitrow>;
Mirror mapMirror(char c){
   using enum Mirror;
   switch(c){
   case '|':
      return VERTICAL;
   case '-':
      return HORIZONTAL;
   case '/':
      return FORWARD;
   case '\\':
      return BACKWARD;
   case '.':
   default:
      return EMPTY;
   }
}
Direction turn(Direction d,Mirror m){
   return mirroring[(int)m*4+std::distance(directions.cbegin(),std::find(directions.cbegin(),directions.cend(),d))];
}
Position walk(Position p,Direction d){
   using enum Direction;
   switch(d){
   case NORTH:
      return Position{p.x,p.y-1};
   case EAST:
      return Position{p.x+1,p.y};
   case SOUTH:
      return Position{p.x,p.y+1};
   case WEST:
      return Position{p.x-1,p.y};
   }
}
Board parseInput(const std::vector<std::string> &input){
   Board board;
   for(const std::string &line:input){
      Row row;
      for(char c:line){
         Mirror m=mapMirror(c);
         row.push_back(m);
      }
      board.push_back(row);
   }
   return board;
}
void addBeam(const Board &board,Bitmask &isEnergized,Position current,Direction direction){
start:
   if(!(0<=current.y&&current.y<board.size()&&0<=current.x&&current.x<board[current.y].size())){
      return;
   }
   direction=turn(direction,board[current.y][current.x]);
   if(std::find(directions.cbegin(),directions.cend(),direction)!=directions.cend()){
      isEnergized[current.y][current.x]=true;
      current=walk(current,direction);
      goto start;
   } else if(!isEnergized[current.y][current.x]){
      isEnergized[current.y][current.x]=true;
      for(Direction d:directions){
         if((char)direction&(char)d){
            addBeam(board,isEnergized,walk(current,d),d);
         }
      }
   }
}
llint solve1(const std::vector<std::string> &input){
   Board board=parseInput(input);
   Bitmask isEnergized(board.size(),Bitrow(board[0].size(),false));
   addBeam(board,isEnergized,{0,0},Direction::EAST);
   return std::transform_reduce(isEnergized.cbegin(),isEnergized.cend(),0ll,std::plus(),[](const Bitrow &row){return std::count(row.cbegin(),row.cend(),true);});
}
llint solve2(const std::vector<std::string> &input){
   Board board=parseInput(input);
   llint height=board.size();
   llint width=board[0].size();
   llint max=0;
   for(llint x=0;x<width;x++){
      Bitmask isEnergized(height,Bitrow(width,false));
      addBeam(board,isEnergized,{x,height-1},Direction::NORTH);
      llint count=std::transform_reduce(isEnergized.cbegin(),isEnergized.cend(),0ll,std::plus(),[](const Bitrow &row){return std::count(row.cbegin(),row.cend(),true);});
      if(count>max){
         max=count;
      }
   }
   for(llint y=0;y<height;y++){
      Bitmask isEnergized(height,Bitrow(width,false));
      addBeam(board,isEnergized,{0,y},Direction::EAST);
      llint count=std::transform_reduce(isEnergized.cbegin(),isEnergized.cend(),0ll,std::plus(),[](const Bitrow &row){return std::count(row.cbegin(),row.cend(),true);});
      if(count>max){
         max=count;
      }
   }
   for(llint x=0;x<width;x++){
      Bitmask isEnergized(height,Bitrow(width,false));
      addBeam(board,isEnergized,{x,0},Direction::SOUTH);
      llint count=std::transform_reduce(isEnergized.cbegin(),isEnergized.cend(),0ll,std::plus(),[](const Bitrow &row){return std::count(row.cbegin(),row.cend(),true);});
      if(count>max){
         max=count;
      }
   }
   for(llint y=0;y<height;y++){
      Bitmask isEnergized(height,Bitrow(width,false));
      addBeam(board,isEnergized,{width-1,y},Direction::WEST);
      llint count=std::transform_reduce(isEnergized.cbegin(),isEnergized.cend(),0ll,std::plus(),[](const Bitrow &row){return std::count(row.cbegin(),row.cend(),true);});
      if(count>max){
         max=count;
      }
   }
   return max;
}
int main(){
   constexpr llint doWarming=100;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   std::vector<std::string>example1={
      ".|...\\....",
      "|.-.\\.....",
      ".....|-...",
      "........|.",
      "..........",
      ".........\\",
      "..../.\\\\..",
      ".-.-/..|..",
      ".|....-|.\\",
      "..//.|...."
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
