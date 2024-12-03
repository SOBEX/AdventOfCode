import time
import re

def solve1(input):
   result=0
   for line in input:
      for match in re.finditer(r'mul\((\d{1,3}),(\d{1,3})\)',line):
         result+=int(match.group(1))*int(match.group(2))
   return result

def solve2(input):
   result=0
   doCount=True
   for line in input:
      for match in re.finditer(r'(?:do\(\)|don\'t\(\)|mul\((\d{1,3}),(\d{1,3})\))',line):
         if match.group(0)=='do()':
            doCount=True
         elif match.group(0)=='don\'t()':
            doCount=False
         elif doCount:
            result+=int(match.group(1))*int(match.group(2))
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   #

   time2=time.perf_counter_ns()

   answer1=solve1(input)

   time3=time.perf_counter_ns()

   answer2=solve2(input)

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
