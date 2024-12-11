import time
from functools import lru_cache

@lru_cache(maxsize=None)
def blink(i,its):
   if its==0:
      return 1
   elif i=='0':
      return blink('1',its-1)
   elif len(i)%2==0:
      l=len(i)//2
      return blink(i[:l],its-1)+blink(i[l:].lstrip('0') or '0',its-1)
   else:
      return blink(str(int(i)*2024),its-1)

def solve1(array):
   result=0
   for i in array:
      result+=blink(i,25)
   return result

def solve2(array):
   result=0
   for i in array:
      result+=blink(i,75)
   return result

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
