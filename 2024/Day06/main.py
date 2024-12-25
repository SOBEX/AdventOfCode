import time

def solve1(grid,start):
   directions=[(0,-1),(1,0),(0,1),(-1,0)]
   Y=len(grid)
   X=len(grid[0])
   visited=[[False for _ in line] for line in grid]
   direction=0
   while True:
      visited[start[1]][start[0]]=True
      move=(start[0]+directions[direction][0],start[1]+directions[direction][1])
      if not(0<=move[0] and move[0]<X and 0<=move[1] and move[1]<Y):
         break
      if grid[move[1]][move[0]]=='#':
         direction=(direction+1)%len(directions)
      else:
         start=move
   return sum(b for line in visited for b in line)

def solve2(grid,start):
   directions=[(0,-1),(1,0),(0,1),(-1,0)]
   Y=len(grid)
   X=len(grid[0])
   result=0
   bad=[[None for _ in line] for line in grid]
   direction=0
   count=0
   while True:
      move=(start[0]+directions[direction][0],start[1]+directions[direction][1])
      if not(0<=move[0] and move[0]<X and 0<=move[1] and move[1]<Y):
         break
      if grid[move[1]][move[0]]=='#':
         direction=(direction+1)%len(directions)
      else:
         if bad[move[1]][move[0]] is None:
            grid[move[1]][move[0]]='#'
            _visited=set()
            _start=(start[0],start[1])
            _direction=direction
            while True:
               _state=(_start,_direction)
               if _state in _visited:
                  bad[move[1]][move[0]]=True
                  break
               _visited.add(_state)
               _move=(_start[0]+directions[_direction][0],_start[1]+directions[_direction][1])
               if not(0<=_move[0] and _move[0]<X and 0<=_move[1] and _move[1]<Y):
                  bad[move[1]][move[0]]=False
                  break
               if grid[_move[1]][_move[0]]=='#':
                  _direction=(_direction+1)%len(directions)
               else:
                  _start=_move
            grid[move[1]][move[0]]='.'
         start=move
   return sum(1 for line in bad for b in line if b)

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   grid=[[c for c in line] for line in input]
   for y in range(len(grid)):
      for x in range(len(grid[y])):
         if grid[y][x]=='^':
            start=(x,y)

   time2=time.perf_counter_ns()

   answer1=solve1(grid,start)

   time3=time.perf_counter_ns()

   answer2=solve2(grid,start)

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
