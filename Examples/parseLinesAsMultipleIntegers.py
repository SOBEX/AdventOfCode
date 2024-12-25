import sys
import os
AOC_DIRECTORY=sys.path[0] or os.getcwd()
while AOC_DIRECTORY:
   if os.path.basename(AOC_DIRECTORY)=='AdventOfCode':
      sys.path.insert(1,AOC_DIRECTORY)
      break
   AOC_DIRECTORY=os.path.dirname(AOC_DIRECTORY)
else:
   raise ImportError
from aoc import *

import time

def main(filename='input'):
   time0=time.perf_counter_ns()

   #reading
   content=readFile(filename)

   time1=time.perf_counter_ns()

   #parsing
   lines=parseLines(content,r'\d+')

   time2=time.perf_counter_ns()

   #part 1
   answer1=sum(sum(line) for line in lines)

   time3=time.perf_counter_ns()

   #part 2
   answer2=0
   for l,r in lines:
      answer2+=l*r

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
   main(os.path.splitext(os.path.basename(__file__))[0])
