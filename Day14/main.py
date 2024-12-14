import time
import sys
import os
from PIL import Image

def solve1(robots,X,Y):
   for it in range(1,101):
      for r in robots:
         r[0]=((r[0][0]+r[1][0])%X,(r[0][1]+r[1][1])%Y)
   results=[0,0,0,0]
   for robot in robots:
      if robot[0][1]==(Y-1)/2:
         pass
      elif robot[0][1]<Y/2:
         if robot[0][0]==(X-1)/2:
            pass
         elif robot[0][0]<X/2:
            results[0]+=1
         else:
            results[1]+=1
      else:
         if robot[0][0]==(X-1)/2:
            pass
         elif robot[0][0]<X/2:
            results[2]+=1
         else:
            results[3]+=1
   return results[0]*results[1]*results[2]*results[3]

def solve2(robots,X,Y):
   isFileRedirected=not sys.stdout.isatty()
   if not os.path.exists('images'):
      os.mkdir('images')
   for it in range(1,X*Y+1):
      image=Image.new('1',(X,Y))
      for r in robots:
         r[0]=((r[0][0]+r[1][0])%X,(r[0][1]+r[1][1])%Y)
         image.putpixel(r[0],1)
      image.save(os.path.join('images',f'{it:05}.png'))
      #board=[[0]*X for _ in range(Y)]
      #for robot in robots:
      #   board[robot[0][1]][robot[0][0]]+=1
      #string='\n\n'+str(it)
      #for y in range(Y):
      #   string+='\n'
      #   for x in range(X):
      #      string+=str(board[y][x])
      #print(string,end='')
      #if not isFileRedirected:
      #   time.sleep(1)

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   robots=[[tuple([int(i) for i in var.split('=')[1].split(',')]) for var in line.split(' ')] for line in input]
   Y=103
   X=101
   if filename=='example':
      Y=7
      X=11

   time2=time.perf_counter_ns()

   answer1=solve1([robot.copy() for robot in robots],X,Y)

   time3=time.perf_counter_ns()

   answer2=solve2(robots,X,Y)

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
   #main('example')
   main()
