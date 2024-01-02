import time
import math

def doRace(time,distance):
   mid=time/2
   discriminant=time**2-4*distance
   print(mid,discriminant)
   return math.ceil(mid+discriminant**0.5/2)-math.floor(mid-discriminant**0.5/2)-1 if discriminant>0 else 0

def solve1(times,distance):
   product=1
   for time,distance in zip(times,distances):
      product*=doRace(time,distance)
   return product

def solve2(times,distance):
   time=int(''.join([str(number) for number in times]))
   distance=int(''.join([str(number) for number in distances]))
   return doRace(time,distance)

time0=time.perf_counter_ns()

with open('input','r') as file:
   input=file.read().rstrip('\n').split('\n')

time1=time.perf_counter_ns()

times,distances=[[int(number) for number in line.split()[1:]] for line in input]

time2=time.perf_counter_ns()

answer1=solve1(times,distances)

time3=time.perf_counter_ns()

answer2=solve2(times,distances)

time4=time.perf_counter_ns()

read=(time1-time0)/1000000.0
parse=(time2-time1)/1000000.0
part1=(time3-time2)/1000000.0
part2=(time4-time3)/1000000.0
print(f'Read     input  in {read}ms')
print(f'Parsed   input  in {parse}ms')
print(f'Answered part 1 in {part1}ms: {answer1}')
print(f'Answered part 2 in {part2}ms: {answer2}')
