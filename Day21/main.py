import time
from itertools import permutations
from collections import defaultdict

numeric={
   '7':(0,0),
   '8':(1,0),
   '9':(2,0),
   '4':(0,1),
   '5':(1,1),
   '6':(2,1),
   '1':(0,2),
   '2':(1,2),
   '3':(2,2),
   '0':(1,3),
   'A':(2,3),
}
directional={
   '^':(1,0),
   'A':(2,0),
   '<':(0,1),
   'v':(1,1),
   '>':(2,1)
}
directionals={
   '^^':'A',
   '^A':'>A',
   '^<':'v<A',
   '^v':'vA',
   '^>':'v>A',#'>vA'
   'A^':'<A',
   'AA':'A',
   'A<':'v<<A',#'<v<A'
   'Av':'<vA',#'v<A'
   'A>':'vA',
   '<^':'>^A',
   '<A':'>>^A',#'>^>A'
   '<<':'A',
   '<v':'>A',
   '<>':'>>A',
   'v^':'^A',
   'vA':'^>A',#'>^A'
   'v<':'<A',
   'vv':'A',
   'v>':'>A',
   '>^':'<^A',#'^<A'
   '>A':'^A',
   '><':'<<A',
   '>v':'<A',
   '>>':'A'
}

def num2dir(code):
   path=[numeric['A']]+[numeric[c] for c in code]
   results=['']
   for i in range(len(path)-1):
      left=path[i]
      right=path[i+1]
      lefts=[('',left)]
      if right==numeric['0'] or right==numeric['A']:
         if left==numeric['7']:
            lefts=[('>',numeric['8']),('v>',numeric['5']),('vv>',numeric['2'])]
         elif left==numeric['4']:
            lefts=[('>',numeric['5']),('v>',numeric['2'])]
         elif left==numeric['1']:
            lefts=[('>',numeric['2'])]
      if right==numeric['7'] or right==numeric['4'] or right==numeric['1']:
         if left==numeric['0']:
            lefts=[('^',numeric['2'])]
         elif left==numeric['A']:
            lefts=[('<^',numeric['2']),('^',numeric['3'])]
      newResults=[]
      for prefix,left in lefts:
         addition=''
         if left[1]<right[1]:
            addition+='v'*(right[1]-left[1])
         else:
            addition+='^'*(left[1]-right[1])
         if left[0]<right[0]:
            addition+='>'*(right[0]-left[0])
         else:
            addition+='<'*(left[0]-right[0])
         additions=list(set([''.join(permutation) for permutation in permutations(addition)]))
         for result in results:
            for addition in additions:
               newResults.append(result+prefix+addition+'A')
      results=newResults
   return results

def dir2dir(code):
   result=''
   prev='A'
   for c in code:
      result+=directionals[prev+c]
      prev=c
   return result

def dir2len(code):
   result=0
   prev='A'
   for c in code:
      result+=len(directionals[prev+c])
      prev=c
   return result

def dir2dirMap(code):
   result=defaultdict(int)
   for c in code.split('A')[:-1]:
      result[c+'A']+=1
   return result

def dirMap2dirMap(code):
   result=defaultdict(int)
   for k,v in code.items():
      if False:
         prev='A'
         for c in k:
            result[directionals[prev+c]]+=v
      else:
         for c in dir2dir(k).split('A')[:-1]:
            result[c+'A']+=v
   return result

def dirMap2len(code):
   result=0
   for k,v in code.items():
      result+=len(dir2dir(k))*v
   return result

def solve1(numCodes):
   result=0
   for numCode in numCodes:
      dirCodes1=num2dir(numCode)
      dirCodes2=[dir2dir(c) for c in dirCodes1]
      lengths3=[dir2len(c) for c in dirCodes2]
      result+=min(lengths3)*int(numCode[:-1])
   return result

def solve2(numCodes):
   result=0
   for numCode in numCodes:
      dirCodes=num2dir(numCode)
      dirMaps=[dir2dirMap(c) for c in dirCodes]
      for i in range(24):
         dirMaps=[dirMap2dirMap(m) for m in dirMaps]
      lengths=[dirMap2len(m) for m in dirMaps]
      result+=min(lengths)*int(numCode[:-1])
   return result

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   codes=[]
   for line in input:
      codes.append(line)

   time2=time.perf_counter_ns()

   answer1=solve1(codes)

   time3=time.perf_counter_ns()

   answer2=solve2(codes)

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
