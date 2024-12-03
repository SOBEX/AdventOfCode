import time

def check(report):
   last=report[0]
   inc=report[1]>report[0]
   for i in range(1,len(report)):
      cur=report[i]
      dif=cur-last if inc else last-cur
      if dif<1 or dif>3:
         return False
      last=cur
   return True

def solve1(reports):
   result=0
   for report in reports:
      if check(report):
         result+=1

   return result

def solve2(reports):
   result=0
   for report in reports:
      if check(report):
         result+=1
         continue
      for i in range(len(report)):
         copy=report.copy()
         copy.pop(i)
         if check(copy):
            result+=1
            break
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   reports=[[int(num) for num in line.split()] for line in input]

   time2=time.perf_counter_ns()

   answer1=solve1(reports)

   time3=time.perf_counter_ns()

   answer2=solve2(reports)

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