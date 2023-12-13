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
using Board=std::vector<std::vector<bool>>;
llint find(const Board &board){
   for(llint i=1;i<board.size();i++){
      llint correct=true;
      for(llint top=i-1,bottom=i;0<=top&&bottom<board.size();top--,bottom++){
         if(board[top]!=board[bottom]){
            correct=false;
            break;
         }
      }
      if(correct){
         return i;
      }
   }
   return -1;
}
llint findAlmost(const Board &board){
   for(llint i=1;i<board.size();i++){
      llint differences=0;
      for(llint top=i-1,bottom=i;0<=top&&bottom<board.size();top--,bottom++){
         auto difference=std::mismatch(board[top].begin(),board[top].end(),board[bottom].begin());
         if(difference.first!=board[top].end()){
            if(differences==1){
               differences=2;
               break;
            } else{
               difference=std::mismatch(++difference.first,board[top].end(),++difference.second);
               if(difference.first!=board[top].end()){
                  differences=2;
                  break;
               } else{
                  differences=1;
               }
            }
         }
      }
      if(differences==1){
         return i;
      }
   }
   return -1;
}
template<auto find>llint findFind(const Board&byRow,const Board&byColumn){
   llint found=find(byRow);
   if(found!=-1){
      return 100*found;
   } else{
      found=find(byColumn);
      if(found!=-1){
         return found;
      } else{
         return 0;
      }
   }
}
llint solve1(const std::vector<std::string> &input){
   llint sum=0;
   std::vector<std::vector<bool>>byRow;
   std::vector<std::vector<bool>>byColumn;
   bool first=true;
   for(const std::string &line:input){
      if(first){
         first=false;
         for(llint i=0;i<line.size();i++){
            byColumn.emplace_back();
         }
      }
      if(line.size()!=0){
         byRow.emplace_back();
         for(llint i=0;i<line.size();i++){
            bool isRock=line[i]=='#';
            byRow.back().push_back(isRock);
            byColumn[i].push_back(isRock);
         }
      } else{
         sum+=findFind<find>(byRow,byColumn);
         byRow.clear();
         byColumn.clear();
         first=true;
      }
   }
   sum+=findFind<find>(byRow,byColumn);
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   llint sum=0;
   std::vector<std::vector<bool>>byRow;
   std::vector<std::vector<bool>>byColumn;
   bool first=true;
   for(const std::string &line:input){
      if(first){
         first=false;
         for(llint i=0;i<line.size();i++){
            byColumn.emplace_back();
         }
      }
      if(line.size()!=0){
         byRow.emplace_back();
         for(llint i=0;i<line.size();i++){
            bool isRock=line[i]=='#';
            byRow.back().push_back(isRock);
            byColumn[i].push_back(isRock);
         }
      } else{
         sum+=findFind<findAlmost>(byRow,byColumn);
         byRow.clear();
         byColumn.clear();
         first=true;
      }
   }
   sum+=findFind<findAlmost>(byRow,byColumn);
   return sum;
}
int main(){
   constexpr llint doWarming=1000;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   std::vector<std::string>example1={
      "#.##..##.",
      "..#.##.#.",
      "##......#",
      "##......#",
      "..#.##.#.",
      "..##..##.",
      "#.#.##.#.",
      "",
      "#...##..#",
      "#....#..#",
      "..##..###",
      "#####.##.",
      "#####.##.",
      "..##..###",
      "#....#..#"
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
