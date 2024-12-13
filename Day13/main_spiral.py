import time

def solve(a,b,prize):
   for ai in range(2):
      bi=1-ai
      pos=(0,0)
      tokens=0
      for it in range(50):
         if pos[ai]<prize[ai]:
            move=(prize[ai]-pos[ai]+a[ai]-1)//a[ai]
            pos=(pos[0]+a[0]*move,pos[1]+a[1]*move)
            tokens+=3*move
         elif pos[ai]>prize[ai]:
            move=(pos[ai]-prize[ai]+a[ai]-1)//a[ai]
            pos=(pos[0]-a[0]*move,pos[1]-a[1]*move)
            tokens-=3*move
         if pos[bi]<prize[bi]:
            move=(prize[bi]-pos[bi]+b[bi]-1)//b[bi]
            pos=(pos[0]+b[0]*move,pos[1]+b[1]*move)
            tokens+=move
         elif pos[bi]>prize[bi]:
            move=(pos[bi]-prize[bi]+b[bi]-1)//b[bi]
            pos=(pos[0]-b[0]*move,pos[1]-b[1]*move)
            tokens-=move
      if pos[0]==prize[0] and pos[1]==prize[1]:
         return tokens
   return 0

def solve1(inputs):
   result=0
   for input in inputs:
      result+=solve(input[0:2],input[2:4],input[4:6])
   return result

def solve2(inputs):
   result=0
   for input in inputs:
      result+=solve(input[0:2],input[2:4],[input[4]+10000000000000,input[5]+10000000000000])
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   inputs=[]
   for line in input:
      parts=line.split(': ')
      if parts[0]=='Button A':
         inputs.append([int(part.split('+')[1]) for part in parts[1].split(', ')])
      elif parts[0]=='Button B':
         inputs[-1].extend([int(part.split('+')[1]) for part in parts[1].split(', ')])
      elif parts[0]=='Prize':
         inputs[-1].extend([int(part.split('=')[1]) for part in parts[1].split(', ')])

   time2=time.perf_counter_ns()

   answer1=solve1(inputs)

   time3=time.perf_counter_ns()

   answer2=solve2(inputs)

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
