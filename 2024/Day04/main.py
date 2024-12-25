import time

def solve1(array):
   directions=[(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]
   string='XMAS'
   result=0
   Y=len(array)
   X=len(array[0])
   for y in range(Y):
      for x in range(X):
         if array[y][x]==string[0]:
            for direction in directions:
               yy=y
               xx=x
               for i in range(1,len(string)):
                  yy+=direction[0]
                  xx+=direction[1]
                  if yy<0 or Y<=yy or xx<0 or X<=xx or array[yy][xx]!=string[i]:
                     break
               else:
                  result+=1
   return result

def solve2(array):
   middle='A'
   strings=['MMSS','MSMS','SSMM','SMSM']
   result=0
   Y=len(array)
   X=len(array[0])
   for y in range(1,Y-1):
      for x in range(1,X-1):
         if array[y][x]==middle:
            string=array[y-1][x-1]+array[y-1][x+1]+array[y+1][x-1]+array[y+1][x+1]
            if string in strings:
               result+=1
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   array=[[character for character in line] for line in input]

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
