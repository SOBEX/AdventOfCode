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

#define MYCHOICE 3
#if MYCHOICE==0
#include<algorithm>
#include<numeric>
std::vector<llint>parseLine(const std::string &_line){
   std::istringstream line{_line};
   std::vector<llint>numbers;
   llint number;
   while(line>>number){
      numbers.push_back(number);
   }
   return numbers;
}
llint getNext(const std::vector<llint>positions){
   std::vector<llint>velocities(positions.size());
   std::adjacent_difference(positions.cbegin(),positions.cend(),velocities.begin());
   velocities.erase(velocities.cbegin());
   if(std::all_of(velocities.cbegin(),velocities.cend(),[](llint i){return i==0;})){
      return 0;
   } else{
      return velocities.back()+getNext(velocities);
   }
}
llint getPrevious(const std::vector<llint>positions){
   if(positions.size()==1)return 0;
   std::vector<llint>velocities(positions.size());
   std::adjacent_difference(positions.cbegin(),positions.cend(),velocities.begin());
   velocities.erase(velocities.cbegin());
   if(std::all_of(velocities.cbegin(),velocities.cend(),[](llint i){return i==0;})){
      return 0;
   } else{
      return velocities.front()-getPrevious(velocities);
   }
}
llint solve1(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      std::vector<llint>positions=parseLine(line);
      sum+=positions.back()+getNext(positions);
   }
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   llint sum=0;
   for(const std::string &line:input){
      std::vector<llint>positions=parseLine(line);
      sum+=positions.front()-getPrevious(positions);
   }
   return sum;
}
#elif MYCHOICE==1
#include<algorithm>
#include<charconv>
#include<functional>
#include<iterator>
#include<numeric>
std::vector<llint> parseLine(const std::string &line){
   std::vector<llint>numbers;
   numbers.reserve(std::count(line.cbegin(),line.cend(),' ')+1);
   const char *begin=line.data();
   const char *end=begin+line.size();
   while(begin!=end){
      llint number;
      auto [ptr,ec]=std::from_chars(begin,end,number);
      if(ec==std::errc()){
         numbers.push_back(number);
         begin=ptr;
         if(begin!=end){
            begin++;
         }
      } else{
         break;
      }
   }
   return numbers;
}
llint getNextForward(std::vector<llint>n){
   n.insert(n.begin(),0ll);
   auto begin=std::next(n.begin());
   auto end=n.end();
   while(std::any_of(begin,end,[](llint i){return i!=0;})){
      std::adjacent_difference(begin,end,n.begin());
      end--;
   }
   return std::accumulate(end,n.end(),0ll);
}
llint getPreviousForward(std::vector<llint>n){
   auto begin=n.begin();
   auto end=n.end();
   while(std::any_of(begin,end,[](llint i){return i!=0;})){
      std::adjacent_difference(begin,end,begin);
      begin++;
   }
   return std::transform_reduce(n.begin(),begin,0ll,std::plus(),[i=0](llint x)mutable{return i++%2==0?x:-x;});
}
llint getNextBackward(std::vector<llint>n){
   auto rbegin=n.rbegin();
   auto rend=n.rend();
   while(std::any_of(rbegin,rend,[](llint i){return i!=0;})){
      std::adjacent_difference(rbegin,rend,rbegin);
      rbegin++;
   }
   return std::transform_reduce(n.rbegin(),rbegin,0ll,std::plus(),[i=0](llint x)mutable{return i++%2==0?x:-x;});
}
llint getPreviousBackward(std::vector<llint>n){
   n.insert(n.end(),0ll);
   auto rbegin=std::next(n.rbegin());
   auto rend=n.rend();
   while(std::any_of(rbegin,rend,[](llint i){return i!=0;})){
      std::adjacent_difference(rbegin,rend,n.rbegin());
      rend--;
   }
   return std::accumulate(rend,n.rend(),0ll);
}
llint solve1(const std::vector<std::string> &input){
   return std::transform_reduce(input.cbegin(),input.cend(),0ll,std::plus(),[](const std::string &line){return getNextBackward(parseLine(line));});
}
llint solve2(const std::vector<std::string> &input){
   return std::transform_reduce(input.cbegin(),input.cend(),0ll,std::plus(),[](const std::string &line){return getPreviousForward(parseLine(line));});
}
#elif MYCHOICE==2
#include<charconv>
llint solve1(const std::vector<std::string> &input){
   llint sum=0ll;
   for(const std::string &line:input){
      llint n=std::count(line.cbegin(),line.cend(),' ')+1;
      std::vector<llint>ns;
      ns.reserve(n);
      const char *begin=line.data();
      const char *end=begin+line.size();
      while(begin!=end){
         llint number;
         auto [ptr,ec]=std::from_chars(begin,end,number);
         if(ec==std::errc()){
            ns.push_back(number);
            begin=ptr;
            if(begin!=end){
               begin++;
            }
         } else{
            break;
         }
      }
      llint innerSum=0ll;
      switch(n){
      default:
         std::cerr<<"Encountered polynomial of grade "<<(n-1)<<'\n';
         break;
      case 23:
         innerSum+=ns[n-1]-22*ns[n-2]+231*ns[n-3]-1540*ns[n-4]+7315*ns[n-5]-26334*ns[n-6]+74613*ns[n-7]-170544*ns[n-8]+319770*ns[n-9]-497420*ns[n-10]+646646*ns[n-11]-705432*ns[n-12]+646646*ns[n-13]-497420*ns[n-14]+319770*ns[n-15]-170544*ns[n-16]+74613*ns[n-17]-26334*ns[n-18]+7315*ns[n-19]-1540*ns[n-20]+231*ns[n-21]-22*ns[n-22]+ns[n-23];
      case 22:
         innerSum+=ns[n-1]-21*ns[n-2]+210*ns[n-3]-1330*ns[n-4]+5985*ns[n-5]-20349*ns[n-6]+54264*ns[n-7]-116280*ns[n-8]+203490*ns[n-9]-293930*ns[n-10]+352716*ns[n-11]-352716*ns[n-12]+293930*ns[n-13]-203490*ns[n-14]+116280*ns[n-15]-54264*ns[n-16]+20349*ns[n-17]-5985*ns[n-18]+1330*ns[n-19]-210*ns[n-20]+21*ns[n-21]-ns[n-22];
      case 21:
         innerSum+=ns[n-1]-20*ns[n-2]+190*ns[n-3]-1140*ns[n-4]+4845*ns[n-5]-15504*ns[n-6]+38760*ns[n-7]-77520*ns[n-8]+125970*ns[n-9]-167960*ns[n-10]+184756*ns[n-11]-167960*ns[n-12]+125970*ns[n-13]-77520*ns[n-14]+38760*ns[n-15]-15504*ns[n-16]+4845*ns[n-17]-1140*ns[n-18]+190*ns[n-19]-20*ns[n-20]+ns[n-21];
      case 20:
         innerSum+=ns[n-1]-19*ns[n-2]+171*ns[n-3]-969*ns[n-4]+3876*ns[n-5]-11628*ns[n-6]+27132*ns[n-7]-50388*ns[n-8]+75582*ns[n-9]-92378*ns[n-10]+92378*ns[n-11]-75582*ns[n-12]+50388*ns[n-13]-27132*ns[n-14]+11628*ns[n-15]-3876*ns[n-16]+969*ns[n-17]-171*ns[n-18]+19*ns[n-19]-ns[n-20];
      case 19:
         innerSum+=ns[n-1]-18*ns[n-2]+153*ns[n-3]-816*ns[n-4]+3060*ns[n-5]-8568*ns[n-6]+18564*ns[n-7]-31824*ns[n-8]+43758*ns[n-9]-48620*ns[n-10]+43758*ns[n-11]-31824*ns[n-12]+18564*ns[n-13]-8568*ns[n-14]+3060*ns[n-15]-816*ns[n-16]+153*ns[n-17]-18*ns[n-18]+ns[n-19];
      case 18:
         innerSum+=ns[n-1]-17*ns[n-2]+136*ns[n-3]-680*ns[n-4]+2380*ns[n-5]-6188*ns[n-6]+12376*ns[n-7]-19448*ns[n-8]+24310*ns[n-9]-24310*ns[n-10]+19448*ns[n-11]-12376*ns[n-12]+6188*ns[n-13]-2380*ns[n-14]+680*ns[n-15]-136*ns[n-16]+17*ns[n-17]-ns[n-18];
      case 17:
         innerSum+=ns[n-1]-16*ns[n-2]+120*ns[n-3]-560*ns[n-4]+1820*ns[n-5]-4368*ns[n-6]+8008*ns[n-7]-11440*ns[n-8]+12870*ns[n-9]-11440*ns[n-10]+8008*ns[n-11]-4368*ns[n-12]+1820*ns[n-13]-560*ns[n-14]+120*ns[n-15]-16*ns[n-16]+ns[n-17];
      case 16:
         innerSum+=ns[n-1]-15*ns[n-2]+105*ns[n-3]-455*ns[n-4]+1365*ns[n-5]-3003*ns[n-6]+5005*ns[n-7]-6435*ns[n-8]+6435*ns[n-9]-5005*ns[n-10]+3003*ns[n-11]-1365*ns[n-12]+455*ns[n-13]-105*ns[n-14]+15*ns[n-15]-ns[n-16];
      case 15:
         innerSum+=ns[n-1]-14*ns[n-2]+91*ns[n-3]-364*ns[n-4]+1001*ns[n-5]-2002*ns[n-6]+3003*ns[n-7]-3432*ns[n-8]+3003*ns[n-9]-2002*ns[n-10]+1001*ns[n-11]-364*ns[n-12]+91*ns[n-13]-14*ns[n-14]+ns[n-15];
      case 14:
         innerSum+=ns[n-1]-13*ns[n-2]+78*ns[n-3]-286*ns[n-4]+715*ns[n-5]-1287*ns[n-6]+1716*ns[n-7]-1716*ns[n-8]+1287*ns[n-9]-715*ns[n-10]+286*ns[n-11]-78*ns[n-12]+13*ns[n-13]-ns[n-14];
      case 13:
         innerSum+=ns[n-1]-12*ns[n-2]+66*ns[n-3]-220*ns[n-4]+495*ns[n-5]-792*ns[n-6]+924*ns[n-7]-792*ns[n-8]+495*ns[n-9]-220*ns[n-10]+66*ns[n-11]-12*ns[n-12]+ns[n-13];
      case 12:
         innerSum+=ns[n-1]-11*ns[n-2]+55*ns[n-3]-165*ns[n-4]+330*ns[n-5]-462*ns[n-6]+462*ns[n-7]-330*ns[n-8]+165*ns[n-9]-55*ns[n-10]+11*ns[n-11]-ns[n-12];
      case 11:
         innerSum+=ns[n-1]-10*ns[n-2]+45*ns[n-3]-120*ns[n-4]+210*ns[n-5]-252*ns[n-6]+210*ns[n-7]-120*ns[n-8]+45*ns[n-9]-10*ns[n-10]+ns[n-11];
      case 10:
         innerSum+=ns[n-1]-9*ns[n-2]+36*ns[n-3]-84*ns[n-4]+126*ns[n-5]-126*ns[n-6]+84*ns[n-7]-36*ns[n-8]+9*ns[n-9]-ns[n-10];
      case 9:
         innerSum+=ns[n-1]-8*ns[n-2]+28*ns[n-3]-56*ns[n-4]+70*ns[n-5]-56*ns[n-6]+28*ns[n-7]-8*ns[n-8]+ns[n-9];
      case 8:
         innerSum+=ns[n-1]-7*ns[n-2]+21*ns[n-3]-35*ns[n-4]+35*ns[n-5]-21*ns[n-6]+7*ns[n-7]-ns[n-8];
      case 7:
         innerSum+=ns[n-1]-6*ns[n-2]+15*ns[n-3]-20*ns[n-4]+15*ns[n-5]-6*ns[n-6]+ns[n-7];
      case 6:
         innerSum+=ns[n-1]-5*ns[n-2]+10*ns[n-3]-10*ns[n-4]+5*ns[n-5]-ns[n-6];
      case 5:
         innerSum+=ns[n-1]-4*ns[n-2]+6*ns[n-3]-4*ns[n-4]+ns[n-5];
      case 4:
         innerSum+=ns[n-1]-3*ns[n-2]+3*ns[n-3]-ns[n-4];
      case 3:
         innerSum+=ns[n-1]-2*ns[n-2]+ns[n-3];
      case 2:
         innerSum+=ns[n-1]-ns[n-2];
      case 1:
         innerSum+=ns[n-1];
      case 0:
         break;
      }
      sum+=innerSum;
   }
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   llint sum=0ll;
   for(const std::string &line:input){
      llint n=std::count(line.cbegin(),line.cend(),' ')+1;
      std::vector<llint>ns;
      ns.reserve(n);
      const char *begin=line.data();
      const char *end=begin+line.size();
      while(begin!=end){
         llint number;
         auto [ptr,ec]=std::from_chars(begin,end,number);
         if(ec==std::errc()){
            ns.push_back(number);
            begin=ptr;
            if(begin!=end){
               begin++;
            }
         } else{
            break;
         }
      }
      llint innerSum=0ll;
      switch(n){
      default:
         std::cerr<<"Encountered polynomial of grade "<<(n-1)<<'\n';
         break;
      case 23:
         innerSum=ns[22]-22*ns[21]+231*ns[20]-1540*ns[19]+7315*ns[18]-26334*ns[17]+74613*ns[16]-170544*ns[15]+319770*ns[14]-497420*ns[13]+646646*ns[12]-705432*ns[11]+646646*ns[10]-497420*ns[9]+319770*ns[8]-170544*ns[7]+74613*ns[6]-26334*ns[5]+7315*ns[4]-1540*ns[3]+231*ns[2]-22*ns[1]+ns[0]-innerSum;
      case 22:
         innerSum=ns[21]-21*ns[20]+210*ns[19]-1330*ns[18]+5985*ns[17]-20349*ns[16]+54264*ns[15]-116280*ns[14]+203490*ns[13]-293930*ns[12]+352716*ns[11]-352716*ns[10]+293930*ns[9]-203490*ns[8]+116280*ns[7]-54264*ns[6]+20349*ns[5]-5985*ns[4]+1330*ns[3]-210*ns[2]+21*ns[1]-ns[0]-innerSum;
      case 21:
         innerSum=ns[20]-20*ns[19]+190*ns[18]-1140*ns[17]+4845*ns[16]-15504*ns[15]+38760*ns[14]-77520*ns[13]+125970*ns[12]-167960*ns[11]+184756*ns[10]-167960*ns[9]+125970*ns[8]-77520*ns[7]+38760*ns[6]-15504*ns[5]+4845*ns[4]-1140*ns[3]+190*ns[2]-20*ns[1]+ns[0]-innerSum;
      case 20:
         innerSum=ns[19]-19*ns[18]+171*ns[17]-969*ns[16]+3876*ns[15]-11628*ns[14]+27132*ns[13]-50388*ns[12]+75582*ns[11]-92378*ns[10]+92378*ns[9]-75582*ns[8]+50388*ns[7]-27132*ns[6]+11628*ns[5]-3876*ns[4]+969*ns[3]-171*ns[2]+19*ns[1]-ns[0]-innerSum;
      case 19:
         innerSum=ns[18]-18*ns[17]+153*ns[16]-816*ns[15]+3060*ns[14]-8568*ns[13]+18564*ns[12]-31824*ns[11]+43758*ns[10]-48620*ns[9]+43758*ns[8]-31824*ns[7]+18564*ns[6]-8568*ns[5]+3060*ns[4]-816*ns[3]+153*ns[2]-18*ns[1]+ns[0]-innerSum;
      case 18:
         innerSum=ns[17]-17*ns[16]+136*ns[15]-680*ns[14]+2380*ns[13]-6188*ns[12]+12376*ns[11]-19448*ns[10]+24310*ns[9]-24310*ns[8]+19448*ns[7]-12376*ns[6]+6188*ns[5]-2380*ns[4]+680*ns[3]-136*ns[2]+17*ns[1]-ns[0]-innerSum;
      case 17:
         innerSum=ns[16]-16*ns[15]+120*ns[14]-560*ns[13]+1820*ns[12]-4368*ns[11]+8008*ns[10]-11440*ns[9]+12870*ns[8]-11440*ns[7]+8008*ns[6]-4368*ns[5]+1820*ns[4]-560*ns[3]+120*ns[2]-16*ns[1]+ns[0]-innerSum;
      case 16:
         innerSum=ns[15]-15*ns[14]+105*ns[13]-455*ns[12]+1365*ns[11]-3003*ns[10]+5005*ns[9]-6435*ns[8]+6435*ns[7]-5005*ns[6]+3003*ns[5]-1365*ns[4]+455*ns[3]-105*ns[2]+15*ns[1]-ns[0]-innerSum;
      case 15:
         innerSum=ns[14]-14*ns[13]+91*ns[12]-364*ns[11]+1001*ns[10]-2002*ns[9]+3003*ns[8]-3432*ns[7]+3003*ns[6]-2002*ns[5]+1001*ns[4]-364*ns[3]+91*ns[2]-14*ns[1]+ns[0]-innerSum;
      case 14:
         innerSum=ns[13]-13*ns[12]+78*ns[11]-286*ns[10]+715*ns[9]-1287*ns[8]+1716*ns[7]-1716*ns[6]+1287*ns[5]-715*ns[4]+286*ns[3]-78*ns[2]+13*ns[1]-ns[0]-innerSum;
      case 13:
         innerSum=ns[12]-12*ns[11]+66*ns[10]-220*ns[9]+495*ns[8]-792*ns[7]+924*ns[6]-792*ns[5]+495*ns[4]-220*ns[3]+66*ns[2]-12*ns[1]+ns[0]-innerSum;
      case 12:
         innerSum=ns[11]-11*ns[10]+55*ns[9]-165*ns[8]+330*ns[7]-462*ns[6]+462*ns[5]-330*ns[4]+165*ns[3]-55*ns[2]+11*ns[1]-ns[0]-innerSum;
      case 11:
         innerSum=ns[10]-10*ns[9]+45*ns[8]-120*ns[7]+210*ns[6]-252*ns[5]+210*ns[4]-120*ns[3]+45*ns[2]-10*ns[1]+ns[0]-innerSum;
      case 10:
         innerSum=ns[9]-9*ns[8]+36*ns[7]-84*ns[6]+126*ns[5]-126*ns[4]+84*ns[3]-36*ns[2]+9*ns[1]-ns[0]-innerSum;
      case 9:
         innerSum=ns[8]-8*ns[7]+28*ns[6]-56*ns[5]+70*ns[4]-56*ns[3]+28*ns[2]-8*ns[1]+ns[0]-innerSum;
      case 8:
         innerSum=ns[7]-7*ns[6]+21*ns[5]-35*ns[4]+35*ns[3]-21*ns[2]+7*ns[1]-ns[0]-innerSum;
      case 7:
         innerSum=ns[6]-6*ns[5]+15*ns[4]-20*ns[3]+15*ns[2]-6*ns[1]+ns[0]-innerSum;
      case 6:
         innerSum=ns[5]-5*ns[4]+10*ns[3]-10*ns[2]+5*ns[1]-ns[0]-innerSum;
      case 5:
         innerSum=ns[4]-4*ns[3]+6*ns[2]-4*ns[1]+ns[0]-innerSum;
      case 4:
         innerSum=ns[3]-3*ns[2]+3*ns[1]-ns[0]-innerSum;
      case 3:
         innerSum=ns[2]-2*ns[1]+ns[0]-innerSum;
      case 2:
         innerSum=ns[1]-ns[0]-innerSum;
      case 1:
         innerSum=ns[0]-innerSum;
      case 0:
         break;
      }
      sum+=innerSum;
   }
   return sum;
}
#elif MYCHOICE==3
#include<charconv>
llint solve1(const std::vector<std::string> &input){
   llint sum=0ll;
   for(const std::string &line:input){
      llint n=std::count(line.cbegin(),line.cend(),' ')+1;
      const char *begin=line.data();
      const char *end=begin+line.size();
      llint number;
      switch(n){
      default:
         std::cerr<<"Encountered polynomial of grade "<<(n-1)<<'\n';
         break;
      case 21:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=21*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=210*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=1330*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=5985*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=20349*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=54264*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=116280*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=203490*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=293930*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=352716*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=352716*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=293930*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=203490*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=116280*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=54264*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=20349*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=5985*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=1330*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=210*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=21*number;
         break;
      case 6:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=6*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=15*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=20*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=15*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=6*number;
         break;
      case 5:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=5*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=10*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=10*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=5*number;
         break;
      case 4:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=4*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=6*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=4*number;
         break;
      case 3:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=3*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=3*number;
         break;
      case 2:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=2*number;
         break;
      case 1:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=number;
         break;
      case 0:
         break;
      }
   }
   return sum;
}
llint solve2(const std::vector<std::string> &input){
   llint sum=0ll;
   for(const std::string &line:input){
      llint n=std::count(line.cbegin(),line.cend(),' ')+1;
      const char *begin=line.data();
      const char *end=begin+line.size();
      llint number;
      switch(n){
      default:
         std::cerr<<"Encountered polynomial of grade "<<(n-1)<<'\n';
         break;
      case 21:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=21*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=210*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=1330*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=5985*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=20349*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=54264*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=116280*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=203490*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=293930*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=352716*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=352716*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=293930*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=203490*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=116280*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=54264*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=20349*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=5985*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=1330*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=210*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=21*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=number;
         break;
      case 6:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=6*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=15*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=20*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=15*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=6*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=number;
         break;
      case 5:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=5*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=10*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=10*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=5*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=number;
         break;
      case 4:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=4*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=6*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=4*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=number;
         break;
      case 3:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=3*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=3*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=number;
         break;
      case 2:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=2*number;
         begin=std::from_chars(begin,end,number).ptr+1;
         sum-=number;
         break;
      case 1:
         begin=std::from_chars(begin,end,number).ptr+1;
         sum+=number;
         break;
      case 0:
         break;
      }
   }
   return sum;
}
#endif
int main(){
   constexpr bool doExample1=true;
   constexpr bool doInput1=true;
   constexpr bool doExample2=true;
   constexpr bool doInput2=true;

   std::vector<std::string>example1={
      "0 3 6 9 12 15",
      "1 3 6 10 15 21",
      "10 13 16 21 30 45"
   };

   std::vector<std::string>example2=example1;

   std::ifstream inputFile("input");
   std::vector<std::string>input;
   std::string line;
   while(std::getline(inputFile,line)){
      input.push_back(line);
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

   double duration0=getDurationMilliseconds(time0,time1);
   double duration1=getDurationMilliseconds(time1,time2);
   double duration2=getDurationMilliseconds(time2,time3);
   double duration3=getDurationMilliseconds(time3,time4);

   std::cout<<"Example 1 took "<<duration0<<"ms: "<<answer1example<<'\n';
   std::cout<<"Input   1 took "<<duration1<<"ms: "<<(answer1input)<<'\n';
   std::cout<<"Example 2 took "<<duration2<<"ms: "<<answer2example<<'\n';
   std::cout<<"Input   2 took "<<duration3<<"ms: "<<(answer2input)<<'\n';
}
