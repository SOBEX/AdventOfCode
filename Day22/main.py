import time

def mix(secret,value):
   return secret^value

def prune(secret):
   return secret%16777216

def step1(secret):
   return prune(mix(secret,secret*64))

def step2(secret):
   return prune(mix(secret,secret//32))

def step3(secret):
   return prune(mix(secret,secret*2048))

def step(secret):
   return step3(step2(step1(secret)))

def solve1(secrets):
   result=0
   for secret in secrets:
      for i in range(2000):
         secret=step(secret)
      result+=secret
   return result

def solve2(secrets):
   results={}
   for s,secret in enumerate(secrets):
      prev=secret%10
      history=()
      result={}
      for i in range(2000):
         secret=step(secret)
         price=secret%10
         history=(*history[-3:],price-prev)
         if len(history)==4 and history not in result:
            result[history]=price
         prev=price
      for k,v in result.items():
         if k in results:
            results[k]+=v
         else:
            results[k]=v
   return max(results.values())

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   secrets=[int(line) for line in input]

   time2=time.perf_counter_ns()

   answer1=solve1(secrets)

   time3=time.perf_counter_ns()

   answer2=solve2(secrets)

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
   main('example1')
   main('example2')
   main()
