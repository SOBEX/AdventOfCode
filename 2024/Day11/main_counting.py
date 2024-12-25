import time
from collections import defaultdict

def blink(mapper,its):
   for it in range(its):
      newMapper=defaultdict(int)
      for i,v in mapper.items():
         if i=='0':
            newMapper['1']+=v
         elif len(i)%2==0:
            l=len(i)//2
            newMapper[i[:l]]+=v
            newMapper[i[l:].lstrip('0') or '0']+=v
         else:
            newMapper[str(int(i)*2024)]+=v
      mapper=newMapper
   return sum(mapper.values())

def solve1(array):
   mapper=defaultdict(int)
   for i in array:
      mapper[i]+=1
   return blink(mapper,25)

def solve2(array):
   mapper=defaultdict(int)
   for i in array:
      mapper[i]+=1
   return blink(mapper,75)

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   array=input[0].split()

   time2=time.perf_counter_ns()

   answer1=solve1(array)

   time3=time.perf_counter_ns()

   answer2=solve2(array)

   time4=time.perf_counter_ns()

   read=(time1-time0)/1000000.0
   parse=(time2-time1)/1000000.0
   part1=(time3-time2)/1000000.0
   part2=(time4-time3)/1000000.0
   print(f'Read     input  in {read}ms')
   print(f'Parsed   input  in {parse}ms')
   print(f'Answered part 1 in {part1}ms: {answer1}')
   print(f'Answered part 2 in {part2}ms: {answer2}')

   return ((answer1,answer2),(read,parse,part1,part2))

if __name__=='__main__':
   main('example')
   main()
