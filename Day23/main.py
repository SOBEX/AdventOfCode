import time

def solve1(computers):
   results=[]
   for c1,connections in computers.items():
      n=len(connections)
      for i2 in range(n):
         c2=connections[i2]
         for i3 in range(i2+1,n):
            c3=connections[i3]
            if c3 in computers[c2]:
               if c1[0]=='t' or c2[0]=='t' or c3[0]=='t':
                  result=list(sorted([c1,c2,c3]))
                  if result not in results:
                     results.append(result)
   return len(results)

def solve2(computers):
   computers=list(computers.items())
   done=set()
   results=set()
   pending=[(i+1,[name]) for i,(name,connections) in enumerate(computers)]
   while pending:
      i,group=pending.pop()
      result=tuple(sorted(group))
      if result in done:
         continue
      finished=True
      for i in range(i,len(computers)):
         name,connections=computers[i]
         valid=True
         for member in group:
            if member not in connections:
               valid=False
               break
         if valid:
            pending.append((i+1,group+[name]))
            finished=False
      if finished:
         results.add(result)
      done.add(result)
   return ','.join(max(results,key=len))

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   computers={}
   for line in input:
      c1=line[0:2]
      c2=line[3:5]
      if c1 not in computers:
         computers[c1]=[c2]
      elif c2 not in computers[c1]:
         computers[c1].append(c2)
      if c2 not in computers:
         computers[c2]=[c1]
      elif c1 not in computers[c2]:
         computers[c2].append(c1)

   time2=time.perf_counter_ns()

   answer1=solve1(computers)

   time3=time.perf_counter_ns()

   answer2=solve2(computers)

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
