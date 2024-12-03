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

#include<sstream>
#include<utility>
llint solve1(const std::vector<std::string> &input){
   llint sum=0;
   llint number=0;
   for(char c:input[0]){
      if(c==','){
         sum+=number;
         number=0;
      } else{
         number+=c;
         number*=17;
         number%=256;
      }
   }
   sum+=number;
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   llint sum=0;
   std::stringstream label;
   llint number=0;
   std::array<std::vector<std::pair<std::string,llint>>,256>numbers;
   for(char c:input[0]){
      if(c==','){
         label.str("");
         number=0;
      } else if('a'<=c&&c<='z'){
         label<<c;
         number+=c;
         number*=17;
         number%=256;
      } else if(c=='='){
      } else if(c=='-'){
         for(auto it=numbers[number].cbegin();it!=numbers[number].cend();it++){
            if(it->first==label.str()){
               numbers[number].erase(it);
               break;
            }
         }
      } else if('1'<=c&&c<='9'){
         bool didReplace=false;
         for(auto it=numbers[number].begin();it!=numbers[number].end();it++){
            if(it->first==label.str()){
               it->second=c-'0';
               didReplace=true;
               break;
            }
         }
         if(!didReplace){
            numbers[number].push_back({label.str(),c-'0'});
         }
      }
   }
   for(llint i=0;i<numbers.size();i++){
      for(llint j=0;j<numbers[i].size();j++){
         sum+=(i+1)*(j+1)*numbers[i][j].second;
      }
   }
   return sum;
}
int main(){
   constexpr llint doWarming=1000;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   std::vector<std::string>example1={
      "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7",
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
