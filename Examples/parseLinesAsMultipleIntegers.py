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
from libaoc import *

import time

def main(filename='input'):
   time0=time.perf_counter_ns()

   #reading
   content=read.file(filename)

   time1=time.perf_counter_ns()

   #parsing
   lines=parse.lines(content,r'\d+')

   time2=time.perf_counter_ns()

   #part 1
   answer1=sum(sum(line) for line in lines)

   time3=time.perf_counter_ns()

   #part 2
   answer2=0
   for l,r in lines:
      answer2+=l*r

   time4=time.perf_counter_ns()

   timeRead=(time1-time0)/1000000.0
   timeParse=(time2-time1)/1000000.0
   timePart1=(time3-time2)/1000000.0
   timePart2=(time4-time3)/1000000.0
   print(f'Read     input  in {timeRead}ms')
   print(f'Parsed   input  in {timeParse}ms')
   print(f'Answered part 1 in {timePart1}ms: {answer1}')
   print(f'Answered part 2 in {timePart2}ms: {answer2}')

   return ((answer1,answer2),(timeRead,timeParse,timePart1,timePart2))

if __name__=='__main__':
   main(os.path.splitext(os.path.basename(__file__))[0])
