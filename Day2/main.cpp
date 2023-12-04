#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<vector>
struct Game{
   int id=0;
   int red=0;
   int green=0;
   int blue=0;
};
Game parseGame(const std::string &_line){
   std::istringstream line{_line};
   Game game;
   line.ignore(5)>>game.id;
   line.ignore(2);
   int red=0;
   int blue=0;
   int green=0;
   while(!line.eof()){
      int count;
      line>>count;
      char colour;
      line.ignore(1)>>colour;
      switch(colour){
      case 'r':
         line.ignore(2);
         red+=count;
         break;
      case 'g':
         line.ignore(4);
         green+=count;
         break;
      case 'b':
         line.ignore(3);
         blue+=count;
         break;
      }
      char separator='|';
      line>>separator;
      switch(separator){
      case ',':
         line.ignore(1);
         break;
      case ';':
         line.ignore(1);
      case '|':
         game.red=red>game.red?red:game.red;
         game.green=green>game.green?green:game.green;
         game.blue=blue>game.blue?blue:game.blue;
         red=0;
         green=0;
         blue=0;
         break;
      }
   }
   return game;
}
int solve1(const std::vector<std::string> &input){
   int sum=0;
   for(const std::string &line:input){
      Game game=parseGame(line);
      if(game.red<=12&&game.green<=13&&game.blue<=14){
         sum+=game.id;
      }
   }
   return sum;
}
int solve2(const std::vector<std::string> &input){
   int sum=0;
   for(const std::string &line:input){
      Game game=parseGame(line);
      sum+=game.red*game.green*game.blue;
   }
   return sum;
}
int main(){
   std::vector<std::string>example1={
      "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
      "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
      "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
      "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
      "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
   };

   std::vector<std::string>example2={
      "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
      "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
      "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
      "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
      "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
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
