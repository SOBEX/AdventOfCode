import time

def solve1(left,right):
   result=0
   for l,r in zip(left,right):
      result+=abs(l-r)
   return result

def solve2(left,right):
   result=0
   for l in left:
      result+=l*right.count(l)
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   left=[];
   right=[];
   for line in input:
      vars=line.split()
      left.append(int(vars[0]))
      right.append(int(vars[1]))
   left.sort()
   right.sort()

   time2=time.perf_counter_ns()

   answer1=solve1(left,right)

   time3=time.perf_counter_ns()

   answer2=solve2(left,right)

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