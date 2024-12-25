import time
from heapq import heappush,heappop

def solve(array,start,end):
   Y=len(array)
   X=len(array[0])
   heap=[(0,1,start,[])]
   done=set()
   while heap:
      s,d,p,h=heappop(heap)
      x,y=p
      if not(0<=x and x<X and 0<=y and y<Y):
         pass
      elif p==end:
         h=h+[p]
         return h
      elif array[y][x] and p not in done:
         done.add(p)
         h=h+[p]
         heappush(heap,(s+1,0,(x,y-1),h))
         heappush(heap,(s+1,1,(x+1,y),h))
         heappush(heap,(s+1,2,(x,y+1),h))
         heappush(heap,(s+1,3,(x-1,y),h))
   return []

def solve1(cs,X,Y,n):
   a=[[True for x in range(X)] for y in range(Y)]
   for i in range(n):
      c=cs[i]
      a[c[1]][c[0]]=False
   return len(solve(a,(0,0),(X-1,Y-1)))-1

def solve2(cs,X,Y,n):
   a=[[True for x in range(X)] for y in range(Y)]
   for i in range(n):
      c=cs[i]
      a[c[1]][c[0]]=False
   start=(0,0)
   end=(X-1,Y-1)
   prev=[]
   for i in range(n,len(cs)):
      c=cs[i]
      a[c[1]][c[0]]=False
      if not prev or c in prev:
         cur=solve(a,start,end)
         if not cur:
            return f'{c[0]},{c[1]}'
         prev=cur
   return '-1,-1'

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   coordinates=[]
   for line in input:
      coordinates.append(tuple(int(i) for i in line.split(',')))
   Y=71
   X=71
   n=1024
   if filename=='example':
      Y=7
      X=7
      n=12

   time2=time.perf_counter_ns()

   answer1=solve1(coordinates,X,Y,n)

   time3=time.perf_counter_ns()

   answer2=solve2(coordinates,X,Y,n)

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
