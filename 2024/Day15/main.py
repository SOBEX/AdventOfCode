import time

def move(b,p,d,doMove=False,boxed=False):
   c=b[p[1]][p[0]]
   n=(p[0]+d[0],p[1]+d[1])
   possible=False
   if c=='#':
      return False
   elif c=='.':
      return True
   elif c=='@':
      possible=move(b,n,d,doMove)
   elif c=='O':
      possible=move(b,n,d,doMove)
   elif c=='[':
      if boxed:
         possible=move(b,n,d,doMove)
      elif d==(1,0):
         possible=move(b,(p[0]+1,p[1]),d,doMove,True)
      else:
         possible=move(b,n,d,doMove) and move(b,(p[0]+1,p[1]),d,doMove,True)
   elif c==']':
      if boxed:
         possible=move(b,n,d,doMove)
      elif d==(-1,0):
         possible=move(b,(p[0]-1,p[1]),d,doMove,True)
      else:
         possible=move(b,n,d,doMove) and move(b,(p[0]-1,p[1]),d,doMove,True)
   if doMove:
      b[p[1]][p[0]],b[n[1]][n[0]]=b[n[1]][n[0]],b[p[1]][p[0]]
   return possible

def start(b):
   for y,l in enumerate(b):
      for x,c in enumerate(l):
         if c=='@':
            return (x,y)

def moveAll(b,mss):
   p=start(b)
   for ms in mss:
      for m in ms:
         if m=='^':
            d=(0,-1)
         elif m=='v':
            d=(0,1)
         elif m=='<':
            d=(-1,0)
         elif m=='>':
            d=(1,0)
         if move(b,p,d):
            move(b,p,d,True)
            p=(p[0]+d[0],p[1]+d[1])

def count(b,o='O'):
   result=0
   for y,l in enumerate(b):
      for x,c in enumerate(l):
         if c==o:
            result+=100*y+x
   return result

def solve1(b,mss):
   moveAll(b,mss)
   return count(b)

def solve2(b,mss):
   for l in b:
      for i in range(0,len(l)*2,2):
         if l[i]=='#':
            l.insert(i+1,'#')
         elif l[i]=='O':
            l[i]='['
            l.insert(i+1,']')
         elif l[i]=='.':
            l.insert(i+1,'.')
         elif l[i]=='@':
            l.insert(i+1,'.')
   moveAll(b,mss)
   return count(b,'[')

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   state=0
   board=[]
   moves=[]
   for line in input:
      if line=='':
         state+=1
      elif state==0:
         board.append([c for c in line])
      elif state==1:
         moves.append(line)

   time2=time.perf_counter_ns()

   answer1=solve1([line.copy() for line in board],moves)

   time3=time.perf_counter_ns()

   answer2=solve2(board,moves)

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
