import time

def isPossible(haves,knows,need):
   if need in knows:
      return knows[need]
   for have in haves:
      if need.startswith(have):
         if isPossible(haves,knows,need[len(have):]):
            knows[need]=True
            return True
   knows[need]=False
   return False

def countPossible(haves,knows,need):
   if need in knows:
      return knows[need]
   result=0
   for have in haves:
      if need.startswith(have):
         result+=countPossible(haves,knows,need[len(have):])
   knows[need]=result
   return result

def solve1(haves,needs):
   result=0
   knows={'':True}
   for need in needs:
      if isPossible(haves,knows,need):
         result+=1
   return result

def solve2(haves,needs):
   result=0
   knows={'':1}
   for need in needs:
      result+=countPossible(haves,knows,need)
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   state=0
   haves=[]
   needs=[]
   for line in input:
      if line=='':
         state+=1
      elif state==0:
         haves.extend(line.split(', '))
      elif state==1:
         needs.append(line)
   haves.sort(key=len,reverse=True)

   time2=time.perf_counter_ns()

   answer1=solve1(haves,needs)

   time3=time.perf_counter_ns()

   answer2=solve2(haves,needs)

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
