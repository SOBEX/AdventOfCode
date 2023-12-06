import time

#

def solve1():
   return -1

def solve2():
   return -1

time0=time.perf_counter_ns()

with open('input','r') as file:
   input=file.read().rstrip('\n').split('\n')

time1=time.perf_counter_ns()

#

time2=time.perf_counter_ns()

answer1=solve1()

time3=time.perf_counter_ns()

answer2=solve2()

time4=time.perf_counter_ns()

read=(time1-time0)/1000000.0
parse=(time2-time1)/1000000.0
part1=(time3-time2)/1000000.0
part2=(time4-time3)/1000000.0
print(f'Read     input  in {read}ms')
print(f'Parsed   input  in {parse}ms')
print(f'Answered part 1 in {part1}ms: {answer1}')
print(f'Answered part 2 in {part2}ms: {answer2}')
