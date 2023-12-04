#define MYCHOICE 1
#if MYCHOICE==0
#include<iostream>
#include<fstream>
#include<string>
#include<string_view>
#include<vector>
bool isDigit(char c){
   return '0'<=c&&c<='9';
}
int digitToInt(char c){
   return c-'0';
}
int solve1(const std::vector<std::string> &input){
   int sum=0;
   for(const std::string &line:input){
      int first=digitToInt(*std::find_if(line.begin(),line.end(),isDigit));
      int last=digitToInt(*std::find_if(line.rbegin(),line.rend(),isDigit));
      sum+=first*10+last;
   }
   return sum;
}
std::vector<std::string>digits{
   "zero",
   "one",
   "two",
   "three",
   "four",
   "five",
   "six",
   "seven",
   "eight",
   "nine"
};
int solve2(const std::vector<std::string> &input){
   int sum=0;
   for(const std::string &line:input){
      int first=0;
      int last=0;
      bool hasFirst=false;
      for(std::string_view sv=line;!sv.empty();sv.remove_prefix(1)){
         int digit=-1;
         if(isDigit(sv[0])){
            digit=digitToInt(sv[0]);
         } else{
            for(int i=0;i<digits.size();i++){
               if(sv.starts_with(digits[i])){
                  digit=i;
                  break;
               }
            }
         }
         if(digit!=-1){
            if(!hasFirst){
               first=digit;
               hasFirst=true;
            }
            last=digit;
         }
      }
      sum+=first*10+last;
   }
   return sum;
}
int main(){
   std::vector<std::string>example1={
      "1abc2",
      "pqr3stu8vwx",
      "a1b2c3d4e5f",
      "treb7uchet"
   };

   std::vector<std::string>example2={
      "two1nine",
      "eightwothree",
      "abcone2threexyz",
      "xtwone3four",
      "4nineeightseven2",
      "zoneight234",
      "7pqrstsixteen"
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
#elif MYCHOICE==1
#include<fstream>
#include<iostream>
#include<string>
#include<vector>
int main(){
   std::vector<std::string>digits{"0","zero","1","one","2","two","3","three","4","four","5","five","6","six","7","seven","8","eight","9","nine"};
   std::ifstream input("input");
   int sum{0},first{-1},last{-1};
   for(std::string line;std::getline(input,line);first=last=(sum+=first*10+last)*0-1)
      for(std::string_view sv=line;!sv.empty();sv.remove_prefix(1))
         for(int i=0;i<digits.size();i++)
            if(sv.starts_with(digits[i]))
               first+=((last=i/2)+1)*(first==-1);
   std::cout<<sum<<'\n';
}
#endif
