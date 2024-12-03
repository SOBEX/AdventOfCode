#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<vector>
int countWins(const std::string &_line){
   std::istringstream line{_line};
   int id;
   line.ignore(5)>>id;
   line.ignore(2);
   std::vector<int>winners;
   int number;
   while(line>>number){
      winners.push_back(number);
      line.ignore(1);
   }
   line.clear();
   line.ignore(2);
   int score=0;
   while(line>>number){
      bool hasWon=false;
      for(int win:winners){
         if(number==win){
            hasWon=true;
            break;
         }
      }
      if(hasWon){
         score++;
      }
   }
   return score;
}
int solve1(const std::vector<std::string> &input){
   int sum=0;
   for(const std::string &line:input){
      int wins=countWins(line);
      sum+=wins?1<<(wins-1):0;
   }
   return sum;
}
int solve2(const std::vector<std::string> &input){
   int sum=0;
   std::vector<int>copies;
   for(const std::string &line:input){
      int wins=countWins(line);
      int mult;
      if(copies.empty()){
         mult=1;
      } else{
         mult=copies[0];
         copies.erase(copies.begin());
      }
      for(int i=0;i<wins;i++){
         if(i<copies.size()){
            copies[i]+=mult;
         } else{
            copies.push_back(1+mult);
         }
      }
      sum+=mult;
   }
   return sum;
}
int main(){
   std::vector<std::string>example1={
      "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
      "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
      "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
      "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
      "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
      "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
   };

   std::vector<std::string>example2={
      "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
      "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
      "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
      "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
      "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
      "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
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
