import time

def count(array,x,y,target=0):
   if not(0<=x and x<len(array[0]) and 0<=y and y<len(array)) or array[y][x]!=target:
      return []
   if target==9:
      return [(x,y)]
   return count(array,x,y+1,target+1)+count(array,x+1,y,target+1)+count(array,x,y-1,target+1)+count(array,x-1,y,target+1)

def solve1(array):
   result=0
   for y in range(len(array[0])):
      for x in range(len(array)):
         result+=len(set(count(array,x,y)))
   return result

def solve2(array):
   result=0
   for y in range(len(array[0])):
      for x in range(len(array)):
         result+=len(count(array,x,y))
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   array=[[int(c) for c in line] for line in input]

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
