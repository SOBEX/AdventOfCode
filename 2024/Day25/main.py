import time

def solve1(tops,bottoms):
   result=0
   for top in tops:
      for bottom in bottoms:
         for t,b in zip(top,bottom):
            if t+b>=6:
               break
         else:
            result+=1
   return result

def solve2(tops,bottoms):
   return True

def readsplit(filename):
   with open(filename,'r') as file:
      return [block.split('\n') for block in file.read().rstrip('\n').split('\n\n')]

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   tops=[]
   bottoms=[]
   key=[]
   for key in input:
      pins=[]
      if key[0][0]=='#':
         for x in range(5):
            pins.append(0)
            for y in range(1,7):
               if key[y][x]=='.':
                  break
               pins[-1]+=1
         tops.append(pins)
      else:
         for x in range(5):
            pins.append(0)
            for y in reversed(range(6)):
               if key[y][x]=='.':
                  break
               pins[-1]+=1
         bottoms.append(pins)

   time2=time.perf_counter_ns()

   answer1=solve1(tops,bottoms)

   time3=time.perf_counter_ns()

   answer2=solve2(tops,bottoms)

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
