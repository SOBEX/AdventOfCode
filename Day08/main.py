import time

def find(nodes,X,Y,multiple=False):
   limit=max(X,Y)
   results=set()
   for nodetype in nodes:
      node=nodes[nodetype]
      for left in node:
         for right in node:
            if left!=right:
               distance=(left[0]-right[0],left[1]-right[1])
               ii=range(0,limit) if multiple else [1]
               for i in ii:
                  antinode=(left[0]+distance[0]*i,left[1]+distance[1]*i)
                  if 0<=antinode[0] and antinode[0]<X and 0<=antinode[1] and antinode[1]<Y:
                     results.add(antinode)
                  else:
                     break
   return results

def solve1(array,nodes):
   return len(find(nodes,len(array[0]),len(array)))

def solve2(array,nodes):
   return len(find(nodes,len(array[0]),len(array),True))

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   array=[[char for char in line] for line in input]
   nodes={}
   for y in range(len(array)):
      for x in range(len(array[y])):
         node=array[y][x]
         if node!='.':
            if node in nodes:
               nodes[node].append((x,y))
            else:
               nodes[node]=[(x,y)]


   time2=time.perf_counter_ns()

   answer1=solve1(array,nodes)

   time3=time.perf_counter_ns()

   answer2=solve2(array,nodes)

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
