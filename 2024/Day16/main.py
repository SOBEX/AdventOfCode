import time
from heapq import heappush,heappop

def solve1(array):
   start=(-1,-1)
   for y,line in enumerate(array):
      for x,c in enumerate(line):
         if c=='S':
            start=(x,y)
   ds=[[1,1001,2001,1001],[1001,1,1001,2001],[2001,1001,1,1001],[1001,2001,1001,1]]
   heap=[(0,1,start)]
   done=set()
   found=2147000000
   while heap:
      s,d,p=heappop(heap)
      x,y=p
      if array[y][x]=='E':
         found=s
         break
      elif array[y][x]!='#' and p not in done:
         done.add(p)
         heappush(heap,(s+ds[d][0],0,(x,y-1)))
         heappush(heap,(s+ds[d][1],1,(x+1,y)))
         heappush(heap,(s+ds[d][2],2,(x,y+1)))
         heappush(heap,(s+ds[d][3],3,(x-1,y)))
   return found

def solve2(array):
   start=(-1,-1)
   end=(-1,-1)
   for y,line in enumerate(array):
      for x,c in enumerate(line):
         if c=='S':
            start=(x,y)
         elif c=='E':
            end=(x,y)
   ds=[[1,1001,2001,1001],[1001,1,1001,2001],[2001,1001,1,1001],[1001,2001,1001,1]]
   heap=[(0,1,start,[])]
   done={}
   ends=[]
   found=2147000000
   while heap:
      s,d,p,h=heappop(heap)
      x,y=p
      if s>found:
         break
      elif array[y][x]=='E':
         ends.append(h)
         found=s
      elif array[y][x]!='#':
         if p not in done:
            done[p]=s+1001
         if s<=done[p]:
            h=h+[p]
            heappush(heap,(s+ds[d][0],0,(x,y-1),h))
            heappush(heap,(s+ds[d][1],1,(x+1,y),h))
            heappush(heap,(s+ds[d][2],2,(x,y+1),h))
            heappush(heap,(s+ds[d][3],3,(x-1,y),h))
   best=set([end])
   for e in ends:
      best.update(e)
   return len(best)

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   array=[]
   for line in input:
      array.append([c for c in line])

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
   main('example1')
   main('example2')
   main()
