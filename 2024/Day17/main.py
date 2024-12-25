import time

def run(a,b,c,program):
   i=0
   result=[]
   while True:
      if i+1>=len(program):
         break
      opcode=program[i]
      literal=program[i+1]
      combo=a if literal==4 else b if literal==5 else c if literal==6 else literal
      i+=2
      match opcode:
         case 0:
            a=int(a//2**combo)
         case 1:
            b=int(b^literal)
         case 2:
            b=int(combo%8)
         case 3:
            if a!=0:
               i=int(literal)
         case 4:
            b=int(b^c)
         case 5:
            result.append(str(combo%8))
         case 6:
            b=int(a//2**combo)
         case 7:
            c=int(a//2**combo)
   return result

def recurse(amin,amax,b,c,program,need,i):
   if i<=1:
      for a in range(amin,amax):
         r=run(a,b,c,program)
         if r==need:
            return a
      return 0
   jump=8**(i-1)
   for a in range(amin,amax,jump):
      r=run(a,b,c,program)
      if r[i]==need[i]:
         s=recurse(a,a+jump,b,c,program,need,i-1)
         if s:
            return s
   return 0

def solve1(registers,program):
   a,b,c=registers
   return ','.join(run(a,b,c,program))

def solve2(registers,program):
   a,b,c=registers
   need=[str(p) for p in program]
   l=len(need)
   return recurse(8**(l-1),8**l,b,c,program,need,l-1)

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   state=0
   registers=[]
   program=[]
   for line in input:
      if line=='':
         state+=1
      elif state==0:
         registers.append(int(line.split(': ')[1]))
      elif state==1:
         program=[int(i) for i in line.split(': ')[1].split(',')]

   time2=time.perf_counter_ns()

   answer1=solve1(registers,program)

   time3=time.perf_counter_ns()

   answer2=solve2(registers,program)

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
   main('example1')
   main('example2')
   main()
