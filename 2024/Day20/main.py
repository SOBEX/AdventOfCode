import time
from heapq import heappush,heappop

def solve(array,start,end):
   Y=len(array)
   X=len(array[0])
   heap=[(0,start,[])]
   done=set()
   while heap:
      score,position,history=heappop(heap)
      x,y=position
      unique=(x,y)
      if not(0<=x and x<X and 0<=y and y<Y) or not array[y][x] or unique in done:
         continue
      done.add(unique)
      newHistory=history+[position]
      if position==end:
         return newHistory
      heappush(heap,(score+1,(x,y-1),newHistory))
      heappush(heap,(score+1,(x+1,y),newHistory))
      heappush(heap,(score+1,(x,y+1),newHistory))
      heappush(heap,(score+1,(x-1,y),newHistory))
   return []

def solve1(array,limit):
   boolmap=[[c!='#' for c in line] for line in array]
   start=(-1,-1)
   end=(-1,-1)
   for y,line in enumerate(array):
      for x,c in enumerate(line):
         if c=='S':
            start=(x,y)
         elif c=='E':
            end=(x,y)
   path=solve(boolmap,start,end)
   pathMap={}
   results=set()
   for l,left in reversed(list(enumerate(path))):
      for adjacent in [(left[0],left[1]-1),(left[0]+1,left[1]),(left[0],left[1]+1),(left[0]-1,left[1])]:
         if adjacent not in results and array[adjacent[1]][adjacent[0]]=='#':
            for right in [(adjacent[0],adjacent[1]-1),(adjacent[0]+1,adjacent[1]),(adjacent[0],adjacent[1]+1),(adjacent[0]-1,adjacent[1])]:
               if right!=left and right in pathMap and pathMap[right]-l-2>=limit:
                  results.add(adjacent)
                  break
      pathMap[left]=l
   return len(results)

def solve2(array,limit):
   boolmap=[[c!='#' for c in line] for line in array]
   start=(-1,-1)
   end=(-1,-1)
   for y,line in enumerate(array):
      for x,c in enumerate(line):
         if c=='S':
            start=(x,y)
         elif c=='E':
            end=(x,y)
   path=solve(boolmap,start,end)
   gridY=(len(array)+19)//20
   gridX=(len(array[0])+19)//20
   grid=[[[] for _ in range(gridX)] for _ in range(gridY)]
   for i,p in enumerate(path):
      grid[p[1]//20][p[0]//20].append((i,p))
   result=0
   for l,left in enumerate(path):
      for gridy in range(max(0,(left[1]//20)-1),min(gridY,(left[1]//20)+2)):
         for gridx in range(max(0,(left[0]//20)-1),min(gridX,(left[0]//20)+2)):
            for r,right in grid[gridy][gridx]:
               distance=abs(right[0]-left[0])+abs(right[1]-left[1])
               if distance<=20 and r-l-distance>=limit:
                  result+=1
   return result

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
   limit1=100
   limit2=100
   if filename.startswith('example'):
      limit1=0
      limit2=50

   time2=time.perf_counter_ns()

   answer1=solve1(array,limit1)

   time3=time.perf_counter_ns()

   answer2=solve2(array,limit2)

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
