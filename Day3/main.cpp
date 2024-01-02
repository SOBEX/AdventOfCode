#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<vector>
enum class EnginePartType{
   None,Number,Symbol
};
struct EnginePart{
   char value;
   EnginePartType type()const{
      using enum EnginePartType;
      return value=='.'?None:'0'<=value&&value<='9'?Number:Symbol;
   }
};
struct Engine{
   using Row=std::vector<EnginePart>;
   std::vector<Row>board;
   std::vector<std::vector<bool>>done;
   Engine(const std::vector<std::string> &input){
      for(const std::string &line:input){
         Row row;
         for(char c:line){
            row.emplace_back(c);
         }
         board.push_back(row);
         done.emplace_back(row.size(),false);
      }
   }
   EnginePart get(int x,int y){
      if(!(0<=y&&y<board.size())){
         return {'.'};
      } else if(!(0<=x&&x<board[y].size())){
         return {'.'};
      } else if(done.size()>0&&done[y][x]){
         return {'.'};
      } else{
         return board[y][x];
      }
   }
   void resetDone(){
      for(std::vector<bool> &row:done){
         row.assign(row.size(),false);
      }
   }
   int getNumber(int x,int y){
      using enum EnginePartType;
      while(get(x,y).type()==Number)x--;
      std::stringstream number;
      for(x++;true;x++){
         const EnginePart &part=get(x,y);
         if(part.type()!=Number){
            break;
         }
         number<<part.value;
         done[y][x]=true;
      }
      int n;
      number>>n;
      return n;
   }
};
int solve1(const std::vector<std::string> &input){
   int sum=0;
   Engine engine(input);
   int y=0;
   for(const Engine::Row &row:engine.board){
      int x=0;
      for(const EnginePart &part:row){
         if(part.type()==EnginePartType::Symbol){
            for(int yy=y-1;yy<=y+1;yy++){
               for(int xx=x-1;xx<=x+1;xx++){
                  if(engine.get(xx,yy).type()==EnginePartType::Number){
                     sum+=engine.getNumber(xx,yy);
                  }
               }
            }
         }
         x++;
      }
      y++;
   }
   return sum;
}
int solve2(const std::vector<std::string> &input){
   int sum=0;
   Engine engine(input);
   int y=0;
   for(const Engine::Row &row:engine.board){
      int x=0;
      for(const EnginePart &part:row){
         if(part.value=='*'){
            std::vector<int>numbers;
            for(int yy=y-1;yy<=y+1;yy++){
               for(int xx=x-1;xx<=x+1;xx++){
                  if(engine.get(xx,yy).type()==EnginePartType::Number){
                     numbers.push_back(engine.getNumber(xx,yy));
                  }
               }
            }
            engine.resetDone();
            if(numbers.size()==2){
               sum+=numbers[0]*numbers[1];
            }
         }
         x++;
      }
      y++;
   }
   return sum;
}
int main(){
   std::vector<std::string>example1={
      "467..114..",
      "...*......",
      "..35..633.",
      "......#...",
      "617*......",
      ".....+.58.",
      "..592.....",
      "......755.",
      "...$.*....",
      ".664.598.."
   };

   std::vector<std::string>example2={
      "467..114..",
      "...*......",
      "..35..633.",
      "......#...",
      "617*......",
      ".....+.58.",
      "..592.....",
      "......755.",
      "...$.*....",
      ".664.598.."
   };

   std::ifstream inputFile("input");
   std::vector<std::string>input;
   std::string line;
   while(std::getline(inputFile,line)){
      input.push_back(line);
   }

   std::cout<<solve1(example1)<<'\n';
   std::cout<<solve1(input)<<'\n';

   std::cout<<solve2(example2)<<'\n';
   std::cout<<solve2(input)<<'\n';
}
