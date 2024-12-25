import time

def isIn(x,y,array):
   return 0<=x and x<len(array[0]) and 0<=y and y<len(array)

def fill(array,x,y,target,region):
   if not isIn(x,y,array) or region[y][x] or array[y][x]!=target:
      return
   region[y][x]=True
   fill(array,x,y+1,target,region)
   fill(array,x+1,y,target,region)
   fill(array,x,y-1,target,region)
   fill(array,x-1,y,target,region)

def area(region):
   Y=len(region)
   X=len(region[0])
   result=0
   for y in range(Y):
      for x in range(X):
         if region[y][x]:
            result+=1
   return result

def perimeter(region):
   Y=len(region)
   X=len(region[0])
   result=0
   for y in range(Y+1):
      for x in range(X+1):
         tl=region[y-1][x-1] if isIn(x-1,y-1,region) else False
         tr=region[y-1][x] if isIn(x,y-1,region) else False
         bl=region[y][x-1] if isIn(x-1,y,region) else False
         br=region[y][x] if isIn(x,y,region) else False
         around=tl+tr+bl+br
         if around==0 or around==4:
            result+=0
         elif around==1 or around==3:
            result+=1
         elif (tl and br) or (tr and bl):
            result+=2
         else:
            result+=1
   return result

def sides(region):
   Y=len(region)
   X=len(region[0])
   result=0
   for y in range(Y+1):
      side=(False,False)
      for x in range(X):
         t=region[y-1][x] if isIn(x,y-1,region) else False
         b=region[y][x] if isIn(x,y,region) else False
         newSide=(t,b)
         if side!=newSide:
            if side[0]!=side[1]:
               result+=1
            side=newSide
      if side[0]!=side[1]:
         result+=1
   for x in range(X+1):
      side=(False,False)
      for y in range(Y):
         l=region[y][x-1] if isIn(x-1,y,region) else False
         r=region[y][x] if isIn(x,y,region) else False
         newSide=(l,r)
         if side!=newSide:
            if side[0]!=side[1]:
               result+=1
            side=newSide
      if side[0]!=side[1]:
         result+=1
   return result

def solve1(array):
   Y=len(array)
   X=len(array[0])
   visited=[[False]*X for _ in range(Y)]
   result=0
   for y in range(Y):
      for x in range(X):
         if not visited[y][x]:
            region=[[False]*X for _ in range(Y)]
            fill(array,x,y,array[y][x],region)
            result+=area(region)*perimeter(region)
            fill(array,x,y,array[y][x],visited)
   return result

def solve2(array):
   Y=len(array)
   X=len(array[0])
   visited=[[False]*X for _ in range(Y)]
   result=0
   for y in range(Y):
      for x in range(X):
         if not visited[y][x]:
            region=[[False]*X for _ in range(Y)]
            fill(array,x,y,array[y][x],region)
            result+=area(region)*sides(region)
            fill(array,x,y,array[y][x],visited)
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   array=[[c for c in line] for line in input]

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
   main('example')
   main()
