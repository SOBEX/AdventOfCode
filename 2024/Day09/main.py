import time

def count(disk):
   result=0
   count=0
   for file in disk:
      if file[0]!=-1:
         for i in range(count,count+file[1]):
            result+=i*file[0]
      count+=file[1]
   return result

def move(disk,l,r):
   if disk[l][1]==disk[r][1]:
      disk[l]=disk[r]
      disk[r]=(-1,disk[l][1])
      l+=1
   elif disk[l][1]>disk[r][1]:
      disk[l]=(-1,disk[l][1]-disk[r][1])
      disk.insert(l,disk[r])
      disk[r+1]=(-1,disk[r+1][1])
      r+=1
   else:
      disk[l]=(disk[r][0],disk[l][1])
      disk[r]=(disk[r][0],disk[r][1]-disk[l][1])
      l+=1
      r+=1
   return (l,r)

def solve1(disk):
   l=0
   r=len(disk)-1
   while l<r:
      if disk[l][0]==-1:
         while l<r:
            if disk[r][0]!=-1:
               l,r=move(disk,l,r)
               r-=1
               break
            r-=1
      l+=1
   return count(disk)

def solve2(disk):
   r=len(disk)-1
   while r>=0:
      if disk[r][0]!=-1:
         for l in range(r):
            if disk[l][0]==-1 and disk[l][1]>=disk[r][1]:
               l,r=move(disk,l,r)
               break
      r-=1
   return count(disk)

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   disk=[]
   id=0
   filled=True
   for i in input[0]:
      if filled:
         if i!='0':
            disk.append((id,int(i)))
         id+=1
      else:
         if i!='0':
            disk.append((-1,int(i)))
      filled=not filled

   time2=time.perf_counter_ns()

   answer1=solve1(disk.copy())

   time3=time.perf_counter_ns()

   answer2=solve2(disk)

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
