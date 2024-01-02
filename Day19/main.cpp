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
#include<charconv>
#include<unordered_map>
enum class Category:shint{
   X,M,A,S
};
struct ConditionSingle{
   Category category;
   char type;
   llint comparison;
   std::string value;
};
struct Condition{
   std::vector<ConditionSingle>conditions;
   std::string other;
};
Category getCategory(char c){
   using enum Category;
   switch(c){
   case 'x':
      return X;
   case 'm':
      return M;
   case 'a':
      return A;
   case 's':
      return S;
   default:
      UNREACHABLE();
   }
}
llint solve1(const Input &input){
   bool top=true;
   std::unordered_map<std::string,Condition>workflows;
   llint sum=0;
   for(const Line &line:input){
      const char *data=line.data();
      if(line.size()==0){
         top=false;
      } else if(top){
         llint start=0;
         llint end=line.find_first_of('{');
         std::string name=line.substr(start,end-start);
         Condition condition;
         start=end+1;
         while((end=line.find_first_of(':',start))!=std::string::npos){
            ConditionSingle conditionSingle;
            conditionSingle.category=getCategory(line[start]);
            conditionSingle.type=line[start+1];
            std::from_chars(data+start+2,data+end,conditionSingle.comparison);
            start=end+1;
            end=line.find_first_of(',',start);
            conditionSingle.value=line.substr(start,end-start);
            condition.conditions.push_back(conditionSingle);
            start=end+1;
         }
         end=line.find_first_of('}',start);
         condition.other=line.substr(start,end-start);
         workflows.insert({name,condition});
      } else{
         std::array<llint,4>rating;
         llint start=3;
         llint end=line.find_first_of(',',start);
         std::from_chars(data+start,data+end,rating[0]);
         start=end+3;
         end=line.find_first_of(',',start);
         std::from_chars(data+start,data+end,rating[1]);
         start=end+3;
         end=line.find_first_of(',',start);
         std::from_chars(data+start,data+end,rating[2]);
         start=end+3;
         end=line.find_first_of('}',start);
         std::from_chars(data+start,data+end,rating[3]);
         std::string name="in";
         while(workflows.contains(name)){
            const Condition &condition=workflows.find(name)->second;
            bool notConditioned=true;
            for(const ConditionSingle c:condition.conditions){
               if(c.type=='<'?rating[(shint)c.category]<c.comparison:rating[(shint)c.category]>c.comparison){
                  name=c.value;
                  notConditioned=false;
                  break;
               }
            }
            if(notConditioned){
               name=condition.other;
            }
         }
         if(name=="A"){
            sum+=rating[0]+rating[1]+rating[2]+rating[3];
         }
      }
   }
   return sum;
}
llint solve2(const Input &input){
   std::unordered_map<std::string,Condition>workflows;
   for(const Line &line:input){
      const char *data=line.data();
      if(line.size()==0){
         break;
      } else{
         llint start=0;
         llint end=line.find_first_of('{');
         std::string name=line.substr(start,end-start);
         Condition condition;
         start=end+1;
         while((end=line.find_first_of(':',start))!=std::string::npos){
            ConditionSingle conditionSingle;
            conditionSingle.category=getCategory(line[start]);
            conditionSingle.type=line[start+1];
            std::from_chars(data+start+2,data+end,conditionSingle.comparison);
            start=end+1;
            end=line.find_first_of(',',start);
            conditionSingle.value=line.substr(start,end-start);
            condition.conditions.push_back(conditionSingle);
            start=end+1;
         }
         end=line.find_first_of('}',start);
         condition.other=line.substr(start,end-start);
         workflows.insert({name,condition});
      }
   }
   std::vector<std::pair<std::string,std::array<llint,8>>>ratings;
   ratings.push_back({"in",{1,4001,1,4001,1,4001,1,4001}});
   llint sum=0;
   while(!ratings.empty()){
      std::string name=ratings.back().first;
      std::array<llint,8>rating=ratings.back().second;
      ratings.pop_back();
      if(workflows.contains(name)){
         const Condition &condition=workflows.find(name)->second;
         for(const ConditionSingle c:condition.conditions){
            llint category=(llint)c.category*2;
            if(c.type=='<'){
               if(rating[category+1]<=c.comparison){
                  ratings.push_back({c.value,rating});
                  break;
               } else if(rating[category]<c.comparison){
                  std::array<llint,8>newRating=rating;
                  newRating[category+1]=c.comparison;
                  ratings.push_back({c.value,newRating});
                  rating[category]=c.comparison;
               }
            } else{
               if(rating[category]>c.comparison){
                  ratings.push_back({c.value,rating});
                  break;
               } else if(rating[category+1]>=c.comparison){
                  std::array<llint,8>newRating=rating;
                  newRating[category]=c.comparison+1;
                  ratings.push_back({c.value,newRating});
                  rating[category+1]=c.comparison+1;
               }
            }
         }
         ratings.push_back({condition.other,rating});
      } else if(name=="A"){
         sum+=(rating[1]-rating[0])*(rating[3]-rating[2])*(rating[5]-rating[4])*(rating[7]-rating[6]);
      }
   }
   return sum;
}
int main(){
   constexpr bool logToFile=false;
   constexpr llint doWarming=1000;
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   Input example1={
      "px{a<2006:qkq,m>2090:A,rfg}",
      "pv{a>1716:R,A}",
      "lnx{m>1548:A,A}",
      "rfg{s<537:gd,x>2440:R,A}",
      "qs{s>3448:A,lnx}",
      "qkq{x<1416:A,crn}",
      "crn{x>2662:A,R}",
      "in{s<1351:px,qqz}",
      "qqz{s>2770:qs,m<1801:hdj,R}",
      "gd{a>3333:R,R}",
      "hdj{m>838:A,pv}",
      "",
      "{x=787,m=2655,a=1222,s=2876}",
      "{x=1679,m=44,a=2067,s=496}",
      "{x=2036,m=264,a=79,s=2244}",
      "{x=2461,m=1339,a=466,s=291}",
      "{x=2127,m=1623,a=2188,s=1013}"
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
