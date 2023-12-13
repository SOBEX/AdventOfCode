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

#include<span>
enum class Spring: char{
   Operational='.',Damaged='#',Unknown='?'
};
using Springs=std::vector<Spring>;
using Numbers=std::vector<llint>;
using StringSpan=std::span<const Spring>;
using NumberSpan=std::span<const llint>;
struct Row{
   Springs springs;
   Numbers numbers;
};
Row parseLine(const std::string &line){
   Row row;
   llint number=0;
   for(char c:line){
      switch(c){
      case '.':
      case '#':
      case '?':
         row.springs.push_back(Spring(c));
         break;
      case ' ':
         break;
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
         number*=10;
         number+=c-'0';
         break;
      case ',':
         row.numbers.push_back(number);
         number=0;
         break;
      }
   }
   if(number!=0){
      row.numbers.push_back(number);
   }
   return row;
}
Row complicateRow(const Row &original){
   Row row;
   for(llint i=0;i<4;i++){
      row.springs.insert(row.springs.end(),original.springs.begin(),original.springs.end());
      row.numbers.insert(row.numbers.end(),original.numbers.begin(),original.numbers.end());
      row.springs.push_back(Spring::Unknown);
   }
   row.springs.insert(row.springs.end(),original.springs.begin(),original.springs.end());
   row.numbers.insert(row.numbers.end(),original.numbers.begin(),original.numbers.end());
   return row;
}
llint countRowLin(StringSpan springs,NumberSpan numbers,llint iSpring=0,llint iNumber=0,bool overrideDamaged=false){
   if(iSpring==springs.size()){
      return iNumber==numbers.size()?1:0;
   }
   llint number=numbers[iNumber];
   if(overrideDamaged){
      iSpring++;
      number--;
      goto damaged;
   }
   switch(springs[iSpring]){
   case Spring::Operational:
      return countRowLin(springs,numbers,iSpring+1,iNumber);
      break;
   case Spring::Damaged:
damaged:
      if(iSpring+number>springs.size()){
         return 0;
      }
      for(llint j=iSpring;j<iSpring+number;j++){
         if(springs[j]==Spring::Operational){
            return 0;
         }
      }
      if(iSpring+number==springs.size()){
         return countRowLin(springs,numbers,iSpring+number,iNumber+1);
      }
      if(springs[iSpring+number]==Spring::Damaged){
         return 0;
      }
      return countRowLin(springs,numbers,iSpring+number+1,iNumber+1);
   case Spring::Unknown:
      return countRowLin(springs,numbers,iSpring+1,iNumber)+countRowLin(springs,numbers,iSpring,iNumber,true);
   }
}
llint countRowLog(StringSpan springs,NumberSpan numbers){
   if(numbers.size()<=2){
      return countRowLin(springs,numbers);
   }
   llint mid=numbers.size()/2;
   std::span<const llint>lefts=numbers.first(mid);
   std::span<const llint>rights=numbers.last(numbers.size()-mid-1);
   llint rangeLeft=0;
   for(llint number:lefts){
      for(llint j=rangeLeft;j<rangeLeft+number;j++){
         if(springs[j]==Spring::Operational){
            rangeLeft=j+1;
         }
      }
      rangeLeft+=number+1;
   }
   llint rangeRight=springs.size()-1;
   for(auto it=rights.rbegin();it!=rights.rend();it++){
      llint number=*it;
      for(llint j=rangeRight;j>rangeRight-number;j--){
         if(springs[j]==Spring::Operational){
            rangeRight=j-1;
         }
      }
      rangeRight-=number+1;
   }
   llint sum=0;
   for(llint i=rangeLeft;i+numbers[mid]<=rangeRight+1;i++){
      bool possible=true;
      for(llint j=i;j<i+numbers[mid];j++){
         if(springs[j]==Spring::Operational){
            possible=false;
            i=j;
            break;
         }
      }
      if(possible&&i-1!=-1&&springs[i-1]==Spring::Damaged){
         possible=false;
      }
      if(possible&&i+numbers[mid]!=springs.size()&&springs[i+numbers[mid]]==Spring::Damaged){
         possible=false;
      }
      if(possible){
         sum+=countRowLog(springs.first(i-1),lefts)*countRowLog(springs.last(springs.size()-i-numbers[mid]-1),rights);
      }
   }
   return sum;
}
llint countRow(const Row &row){
   if(row.numbers.size()<=2){
      return countRowLin(row.springs,row.numbers);
   }
   return countRowLog(row.springs,row.numbers);
}
llint solve1(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      Row row=parseLine(line);
      sum+=countRow(row);
   }
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      Row row=parseLine(line);
      row=complicateRow(row);
      sum+=countRow(row);
   }
   return sum;
}
int main(){
   constexpr llint doWarming=0;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   std::vector<std::string>example1={
      "???.### 1,1,3",
      ".??..??...?##. 1,1,3",
      "?#?#?#?#?#?#?#? 1,3,1,6",
      "????.#...#... 4,1,1",
      "????.######..#####. 1,6,5",
      "?###???????? 3,2,1"
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
