import time
from sympy import symbols,diophantine,Eq,solve as syolve

def solve(a,b,p):
   x,y,r,t=symbols('x y r t')
   solution0=diophantine(a[0]*x+b[0]*y-p[0],r)
   solution1=diophantine(a[1]*x+b[1]*y-p[1],t)
   if solution0 and solution1:
      for s0 in solution0:
         for s1 in solution1:
            s=syolve((Eq(s0[0],s1[0]),Eq(s0[1],s1[1])))
            if s:
               return 3*s0[0].subs(s)+s0[1].subs(s)
   return 0

def solve1(inputs):
   result=0
   for input in inputs:
      result+=solve(input[0:2],input[2:4],input[4:6])
   return result

def solve2(inputs):
   result=0
   for input in inputs:
      result+=solve(input[0:2],input[2:4],[input[4]+10000000000000,input[5]+10000000000000])
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   inputs=[]
   for line in input:
      parts=line.split(': ')
      if parts[0]=='Button A':
         inputs.append([int(part.split('+')[1]) for part in parts[1].split(', ')])
      elif parts[0]=='Button B':
         inputs[-1].extend([int(part.split('+')[1]) for part in parts[1].split(', ')])
      elif parts[0]=='Prize':
         inputs[-1].extend([int(part.split('=')[1]) for part in parts[1].split(', ')])

   time2=time.perf_counter_ns()

   answer1=solve1(inputs)

   time3=time.perf_counter_ns()

   answer2=solve2(inputs)

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
