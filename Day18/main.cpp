#include<array>
#include<chrono>
#include<iostream>
#include<fstream>
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
using Cell=bool;
using Row=std::vector<Cell>;
using Board=std::vector<Row>;
#include<ios>
llint solve1(const Input &input){
   constexpr llint BOARDSIZE=300;
   Board board(2*BOARDSIZE,Row(2*BOARDSIZE,false));
   Position position{BOARDSIZE,BOARDSIZE};
   for(const Line &_line:input){
      std::istringstream line{_line};
      shint direction;
      line>>direction;
      line.ignore(1);
      llint length;
      line>>length;
      while(length--){
         position.indexInto(board)=true;
         switch(direction){
         case 'U':position.y--;break;
         case 'R':position.x++;break;
         case 'D':position.y++;break;
         case 'L':position.x--;break;
         }
      }
   }
   llint count=0;
   for(position.y=0;position.y<2*BOARDSIZE;position.y++){
      bool isInside=false;
      bool cameDown=false;
      bool cameUp=false;
      for(position.x=0;position.x<2*BOARDSIZE;position.x++){
         if(position.indexInto(board)){
            bool goingUp=0<=position.y-1&&board[position.y-1][position.x];
            bool goingDown=position.y+1<2*BOARDSIZE&&board[position.y+1][position.x];
            if(goingUp&&goingDown){
               isInside=!isInside;
            } else if(!cameDown&&!cameUp){
               cameDown=goingUp;
               cameUp=goingDown;
            } else if((cameDown&&goingUp)||(cameUp&&goingDown)){
               cameDown=false;
               cameUp=false;
            } else if((cameDown&&goingDown)||(cameUp&&goingUp)){
               isInside=!isInside;
               cameDown=false;
               cameUp=false;
            }
            count++;
         } else{
            if(isInside){
               count++;
            }
         }
      }
   }
   return count;
}
llint solve2(const Input &input){
   std::vector<Position>corners;
   Position position(0,0);
   corners.push_back(position);
   llint borderCount=0;
   for(const Line &line:input){
      -
         std::istringstream line{_line};
      shint direction;
      line>>direction;
      line.ignore(1);
      llint length;
      line>>length;
      line.ignore(3);
      llint color;
      line>>std::hex>>color;
      length=color/16;
      switch(color%16){
      case 0:position.x+=length;break;
      case 1:position.y+=length;break;
      case 2:position.x-=length;break;
      case 3:position.y-=length;break;
      }
      corners.push_back(position);
      borderCount+=length;
   }
   llint count=0;
   for(llint i=0;i<corners.size()-1;i++){
      Position start=corners[i];
      Position end=corners[i+1];
      llint cross=start.x*end.y-end.x*start.y;
      count+=cross;
   }
   return std::abs(count/2)+borderCount/2+1;
}
int main(){
   constexpr bool logToFile=false;
   constexpr llint doWarming=100000;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   Input example1={
      "R 6 (#70c710)",
      "D 5 (#0dc571)",
      "L 2 (#5713f0)",
      "D 2 (#d2c081)",
      "R 2 (#59c680)",
      "D 2 (#411b91)",
      "L 5 (#8ceee2)",
      "U 2 (#caa173)",
      "L 1 (#1b58a2)",
      "U 2 (#caa171)",
      "R 2 (#7807d2)",
      "U 3 (#a77fa3)",
      "L 2 (#015232)",
      "U 2 (#7a21e3)"
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
