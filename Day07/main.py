import time

def calc(nums,doConcat=False):
   combs=[nums[0]]
   for i in range(1,len(nums)):
      newCombs=[]
      for comb in combs:
         newCombs.append(comb+nums[i])
         newCombs.append(comb*nums[i])
         if doConcat:
            newCombs.append(int(str(comb)+str(nums[i])))
      combs=newCombs
   return combs

def solve1(lines):
   result=0
   for line in lines:
      if line[0] in calc(line[1]):
         result+=line[0]
   return result

def solve2(lines):
   result=0
   for line in lines:
      if line[0] in calc(line[1],True):
         result+=line[0]
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   lines=[]
   for line in input:
      line=line.split(': ')
      lines.append((int(line[0]),[int(i) for i in line[1].split(' ')]))

   time2=time.perf_counter_ns()

   answer1=solve1(lines)

   time3=time.perf_counter_ns()

   answer2=solve2(lines)

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
