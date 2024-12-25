import time

def check(update,rules):
   for r in range(1,len(update)):
      for l in range(r):
         if (update[r],update[l]) in rules:
            return False
   return True

def fix(update,rules):
   changed=False
   for r in range(1,len(update)):
      for l in range(r):
         if (update[r],update[l]) in rules:
            update[r],update[l]=update[l],update[r]
            changed=True
   return update[int(len(update)/2)] if changed else 0

def solve1(rules,updates):
   result=0
   for update in updates:
      if check(update,rules):
         result+=update[int(len(update)/2)]
   return result

def solve2(rules,updates):
   result=0
   for update in updates:
      result+=fix(update,rules)
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   rules=[]
   updates=[]
   part=0
   for line in input:
      if line=='':
         part+=1
      elif part==0:
         rule=line.split('|')
         rule=(int(rule[0]),int(rule[1]))
         rules.append(rule)
      elif part==1:
         update=[int(u) for u in line.split(',')]
         updates.append(update)

   time2=time.perf_counter_ns()

   answer1=solve1(rules,updates)

   time3=time.perf_counter_ns()

   answer2=solve2(rules,updates)

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
