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

#define MYCHOICE 1
#if MYCHOICE==0
#include<map>
#include<tuple>
enum class Spring: char{
   Operational='.',Damaged='#',Unknown='?'
};
using Springs=std::vector<Spring>;
using Numbers=std::vector<llint>;
using MemoryKey=std::tuple<llint,llint,bool>;
using Memory=std::map<MemoryKey,llint>;
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
llint countRow(Memory &memory,const Row &row,llint iSpring=0,llint iNumber=0,bool overrideDamaged=false){
   MemoryKey key{iSpring,iNumber,overrideDamaged};
   auto result=memory.find(key);
   if(result!=memory.end()){
      return result->second;
   }
   if(iSpring==row.springs.size()){
      return memory.insert({key,iNumber==row.numbers.size()?1:0}).first->second;
   }
   llint number=row.numbers[iNumber];
   if(overrideDamaged){
      iSpring++;
      number--;
      goto damaged;
   }
   switch(row.springs[iSpring]){
   case Spring::Operational:
      return memory.insert({key,countRow(memory,row,iSpring+1,iNumber)}).first->second;
   case Spring::Damaged:
damaged:
      if(iSpring+number>row.springs.size()){
         return memory.insert({key,0}).first->second;
      }
      for(llint j=iSpring;j<iSpring+number;j++){
         if(row.springs[j]==Spring::Operational){
            return memory.insert({key,0}).first->second;
         }
      }
      if(iSpring+number==row.springs.size()){
         return memory.insert({key,countRow(memory,row,iSpring+number,iNumber+1)}).first->second;
      }
      if(row.springs[iSpring+number]==Spring::Damaged){
         return memory.insert({key,0}).first->second;
      }
      return memory.insert({key,countRow(memory,row,iSpring+number+1,iNumber+1)}).first->second;
   case Spring::Unknown:
      return memory.insert({key,countRow(memory,row,iSpring+1,iNumber)+countRow(memory,row,iSpring,iNumber,true)}).first->second;
   }
}
llint solve1(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      Row row=parseLine(line);
      Memory memory;
      sum+=countRow(memory,row);
   }
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      Row row=parseLine(line);
      row=complicateRow(row);
      Memory memory;
      sum+=countRow(memory,row);
   }
   return sum;
}
#elif MYCHOICE==1
#include<span>
enum class Spring: char{
   Operational='.',Damaged='#',Unknown='?'
};
using Springs=std::vector<Spring>;
using Numbers=std::vector<llint>;
using SpringSpan=std::span<const Spring>;
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
   row.springs.reserve(original.springs.size()*5+4);
   row.numbers.reserve(original.numbers.size()*5);
   for(llint i=0;i<4;i++){
      row.springs.insert(row.springs.end(),original.springs.begin(),original.springs.end());
      row.numbers.insert(row.numbers.end(),original.numbers.begin(),original.numbers.end());
      row.springs.push_back(Spring::Unknown);
   }
   row.springs.insert(row.springs.end(),original.springs.begin(),original.springs.end());
   row.numbers.insert(row.numbers.end(),original.numbers.begin(),original.numbers.end());
   return row;
}
llint countRow0(SpringSpan springs){
   for(Spring spring:springs){
      if(spring==Spring::Damaged){
         return false;
      }
   }
   return true;
}
llint countRow1(SpringSpan springs,llint length){
   llint rangeLeft=0;
   while(springs[rangeLeft]==Spring::Operational){
      rangeLeft++;
   }
   llint rangeRight=springs.size()-1;
   while(springs[rangeRight]==Spring::Operational){
      rangeRight--;
   }
   llint count=0;
   for(llint i=rangeLeft;i+length<=rangeRight+1;i++){
      bool possible=true;
      for(llint j=i;j<i+length;j++){
         if(springs[j]==Spring::Operational){
            possible=false;
            i=j;
            break;
         }
      }
      if(possible){
         for(llint j=rangeLeft;j<i;j++){
            if(springs[j]==Spring::Damaged){
               possible=false;
               break;
            }
         }
      }
      if(possible){
         for(llint j=i+length;j<=rangeRight;j++){
            if(springs[j]==Spring::Damaged){
               possible=false;
               break;
            }
         }
      }
      if(possible){
         count++;
      }
   }
   return count;
}
llint countRow(SpringSpan springs,NumberSpan numbers){
   if(numbers.size()==0){
      return countRow0(springs);
   }
   if(numbers.size()==1){
      return countRow1(springs,numbers[0]);
   }
   llint mid=numbers.size()/2;
   NumberSpan leftNumbers=numbers.first(mid);
   llint rangeLeft=0;
   for(llint number:leftNumbers){
      for(llint j=rangeLeft;j<rangeLeft+number;j++){
         if(springs[j]==Spring::Operational){
            rangeLeft=j+1;
         }
      }
      rangeLeft+=number+1;
   }
   NumberSpan rightNumbers=numbers.last(numbers.size()-mid-1);
   llint rangeRight=springs.size()-1;
   for(auto it=rightNumbers.rbegin();it!=rightNumbers.rend();it++){
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
      if(possible&&0<=i-1&&springs[i-1]==Spring::Damaged){
         possible=false;
      }
      if(possible&&i+numbers[mid]<springs.size()&&springs[i+numbers[mid]]==Spring::Damaged){
         possible=false;
      }
      if(possible){
         llint left=countRow(springs.first(i-1),leftNumbers);
         if(i+numbers[mid]==springs.size()){
            sum+=left;
         } else{
            llint right=countRow(springs.last(springs.size()-i-numbers[mid]-1),rightNumbers);
            sum+=left*right;
         }
      }
   }
   return sum;
}
llint solve1(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      Row row=parseLine(line);
      sum+=countRow(row.springs,row.numbers);
   }
   return sum;
}
llint solve2(const std::span<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      Row row=parseLine(line);
      row=complicateRow(row);
      sum+=countRow(row.springs,row.numbers);
   }
   return sum;
}

#endif
int main(){
   constexpr llint doWarming=10;
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
