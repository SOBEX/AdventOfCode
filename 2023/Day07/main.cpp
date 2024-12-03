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
double getDurationNanoseconds(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1.0;
}
double getDurationMicroseconds(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1'000.0;
}
double getDurationMilliseconds(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1'000'000.0;
}
double getDurationSeconds(t_t start,t_t end){
   return std::chrono::duration_cast<d_t>(end-start).count()/1'000'000'000.0;
}
using llint=long long int;

#include<algorithm>
#include<array>
#include<charconv>
#include<functional>
#include<iterator>
#include<numeric>
#include<string_view>
using Cards=std::array<char,5>;
std::array<char,14>labels{'A','K','Q','J','T','9','8','7','6','5','4','3','2','*'};
llint getLabelIndex(char card){
   return std::distance(labels.cbegin(),std::find(labels.cbegin(),labels.cend(),card));
}
enum class Hand{
   Five,Four,FullHouse,Three,Pairs,Two,One
};
Hand getHand(const Cards &cards){
   using enum Hand;
   std::array<llint,labels.size()>counts{};
   std::for_each(cards.cbegin(),cards.cend(),[&counts](char card){counts[getLabelIndex(card)]++;});
   llint jokers=counts[counts.size()-1];
   auto it=std::max_element(counts.begin(),counts.end());
   llint max1=*it+jokers;
   if(max1==5){
      return Five;
   } else if(max1==4){
      return Four;
   } else{
      *it=0;
      llint max2=*std::max_element(counts.cbegin(),counts.cend());
      if(max1==3&&max2==2){
         return FullHouse;
      } else if(max1==3){
         return Three;
      } else if(max1==2&&max2==2){
         return Pairs;
      } else if(max1==2){
         return Two;
      } else{
         return One;
      }
   }
}
struct Line{
   Hand hand;
   Cards cards;
   llint bid;
};
template<bool joker>Line parseLine(std::string_view line){
   Line lines;
   std::copy_n(line.cbegin(),5,lines.cards.begin());
   if constexpr(joker){
      std::replace(lines.cards.begin(),lines.cards.end(),'J','*');
   }
   lines.hand=getHand(lines.cards);
   std::from_chars(line.data()+6,line.data()+line.size(),lines.bid);
   return lines;
}
enum class Winner{
   First,Second,Neither
};
Winner getWinner(const Line &line0,const Line &line1){
   using enum Winner;
   if(line0.hand!=line1.hand){
      return (int)line0.hand<(int)line1.hand?First:Second;
   } else{
      auto its=std::mismatch(line0.cards.cbegin(),line0.cards.cend(),line1.cards.cbegin());
      if(its.first!=line0.cards.cend()){
         return getLabelIndex(*its.first)<getLabelIndex(*its.second)?First:Second;
      }
      return Neither;
   }
}
template<bool joker>llint parseInput(const std::vector<std::string> &input){
   std::vector<Line>line(input.size());
   std::transform(input.cbegin(),input.cend(),line.begin(),[](std::string_view line){return parseLine<joker>(line);});
   std::sort(line.begin(),line.end(),[](const auto &l,const auto &r){return getWinner(l,r)==Winner::Second;});
   return std::transform_reduce(line.cbegin(),line.cend(),0ll,std::plus(),[i=0ll](const Line &line)mutable{return (++i)*line.bid;});
}
llint solve1(const std::vector<std::string> &input){
   return parseInput<false>(input);
}
llint solve2(const std::vector<std::string> &input){
   return parseInput<true>(input);
}
int main(){
   std::vector<std::string>example1={
      "32T3K 765",
      "T55J5 684",
      "KK677 28",
      "KTJJT 220",
      "QQQJA 483"
   };

   std::vector<std::string>example2=example1;

   std::ifstream inputFile("input");
   std::vector<std::string>input;
   std::string line;
   while(std::getline(inputFile,line)){
      input.push_back(line);
   }

   t_t time0=getTime();
   auto answer1example=solve1(example1);
   t_t time1=getTime();
   auto answer1input=solve1(input);
   t_t time2=getTime();
   auto answer2example=solve2(example2);
   t_t time3=getTime();
   auto answer2input=solve2(input);
   t_t time4=getTime();

   double duration0=getDurationMilliseconds(time0,time1);
   double duration1=getDurationMilliseconds(time1,time2);
   double duration2=getDurationMilliseconds(time2,time3);
   double duration3=getDurationMilliseconds(time3,time4);

   std::cout<<"Example 1 took "<<duration0<<"ms: "<<answer1example<<'\n';
   std::cout<<"Input   1 took "<<duration1<<"ms: "<<(answer1input)<<'\n';
   std::cout<<"Example 2 took "<<duration2<<"ms: "<<answer2example<<'\n';
   std::cout<<"Input   2 took "<<duration3<<"ms: "<<(answer2input)<<'\n';
}
