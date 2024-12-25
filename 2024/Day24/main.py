import time
from random import randint

def solve(wires,gates):
   done=False
   while not done:
      done=True
      for gate,(l,r,z) in gates:
         if wires[z] is None:
            if wires[l] is not None and wires[r] is not None:
               match gate:
                  case 'AND':
                     wires[z]=wires[l]&wires[r]
                  case 'OR':
                     wires[z]=wires[l]|wires[r]
                  case 'XOR':
                     wires[z]=wires[l]^wires[r]
               done=False
   result=0
   for wire,value in wires.items():
      if wire[0]=='z' and value:
         result+=1<<int(wire[1:3])
   return result

def wireSet(wires,x,y):
   for wire in wires:
      if wire[0]=='x':
         wires[wire]=x&(1<<int(wire[1:3]))
      elif wire[0]=='y':
         wires[wire]=y&(1<<int(wire[1:3]))

def isSwapped(wires,gates,x,y):
   wireSet(wires,x,y)
   return solve(wires,gates)!=x+y

def findInffected(gates,inWire):
   result=set()
   for gate,(in1,in2,out) in gates:
      if in1==inWire or in2==inWire:
         result.add(out)
         result.update(findInffected(gates,out))
   return result

def findOutffected(gates,outWire):
   result=set([outWire])
   for gate,(in1,in2,out) in gates:
      if out==outWire:
         result.update(findOutffected(gates,in1))
         result.update(findOutffected(gates,in2))
   return result

def findGates(gates,_operator,_in1,_in2,_out):
   results=[]
   for gate in gates:
      operator,(in1,in2,out)=gate
      operatorMatch=_operator==None or _operator==operator
      in1Match=_in1==None or _in1==in1 or _in1==in2
      in2Match=_in2==None or _in2==in1 or _in2==in2
      outMatch=_out==None or _out==out
      if operatorMatch and in1Match and in2Match and outMatch:
         results.append(gate)
   return results

def solve1(wires,gates):
   return solve(wires,gates)

def solve2(wires,gates,wrong):
   wrongs,operation=wrong
   if wrongs==0:
      return ''
   for i in range(len(gates)):
      if gates[i][1][0]>gates[i][1][1]:
         gates[i]=(gates[i][0],(gates[i][1][1],gates[i][1][0],gates[i][1][2]))
   zs=0
   for wire in wires:
      if wire[0]=='z':
         zs+=1
   zwiress=[findOutffected(gates,f'z00')]
   zerrors=[False]
   for e in range(1,zs):
      zwiress.append(findOutffected(gates,f'z{e:02}'))
      zerrors.append(isSwapped(wires.copy(),gates,1<<(e-1),1<<(e-1)))
   for zi,(zerror,zwires) in enumerate(zip(zerrors,zwiress)):
      print(zi,zerror)
      gated=[]
      for zwire in zwires:
         for gate,(in1,in2,out) in gates:
            if out==zwire:
               gated.append(f'{in1} {gate} {in2} -> {out}')
               break
      gated.sort(reverse=True)
      for gate in gated:
         print(gate)
      print()
   results=[]
   # x00 XOR y00 -> z00
   if len(findGates(gates,'XOR','x00','y00','z00'))!=1:
      results.append('z00')
      results.append(findGates(gates,'XOR','x00','y00',None)[0][1][2])
   # x00 AND y00 -> aaa
   # x01 XOR y01 -> bbb
   # aaa XOR bbb -> z01
   prevAnd=findGates(gates,'AND','x00','y00',None)[0][1][2]
   curXor=findGates(gates,'XOR','x01','y01',None)[0][1][2]
   if len(findGates(gates,'XOR',prevAnd,curXor,'z01'))!=1:
      #TODO results.append
      print(prevAnd,curXor,'z01')
   # aaa AND bbb -> ccc
   # x01 AND y01 -> ddd
   # ccc OR ddd -> eee
   # x02 XOR y02 -> fff
   # eee XOR fff -> z02
   print('AND',prevAnd,curXor,findGates(gates,'AND',prevAnd,curXor,None))
   prevCarry=findGates(gates,'AND',prevAnd,curXor,None)[0][1][2]
   print('AND','x01','y01',findGates(gates,'AND','x01','y01',None))
   prevAnd=findGates(gates,'AND','x01','y01',None)[0][1][2]
   print('OR',prevCarry,prevAnd,findGates(gates,'OR',prevCarry,prevAnd,None))
   prevOr=findGates(gates,'OR',prevCarry,prevAnd,None)[0][1][2]
   print('XOR','x02','y02',findGates(gates,'XOR','x02','y02',None))
   curXor=findGates(gates,'XOR','x02','y02',None)[0][1][2]
   print('XOR',prevOr,curXor,'z02',findGates(gates,'XOR',prevOr,curXor,'z02'))
   if len(findGates(gates,'XOR',prevOr,curXor,'z02'))!=1:
      #TODO results.append
      print(prevCarry,prevAnd,prevOr,curXor,f'z02')
   print()
   # eee AND fff -> ggg
   # x02 AND y02 -> hhh
   # ggg OR hhh -> iii
   # x03 XOR y03 -> jjj
   # iii XOR jjj -> z03
   for zi in range(3,zs-1):
      try:
         print('AND',prevOr,curXor,findGates(gates,'AND',prevOr,curXor,None))
         prevCarry=findGates(gates,'AND',prevOr,curXor,None)[0][1][2]
         print('AND',f'x{zi-1:02}',f'y{zi-1:02}',findGates(gates,'AND',f'x{zi-1:02}',f'y{zi-1:02}',None))
         prevAnd=findGates(gates,'AND',f'x{zi-1:02}',f'y{zi-1:02}',None)[0][1][2]
         print('OR',prevCarry,prevAnd,findGates(gates,'OR',prevCarry,prevAnd,None))
         prevOr=findGates(gates,'OR',prevCarry,prevAnd,None)[0][1][2]
         print('XOR',f'x{zi:02}',f'y{zi:02}',findGates(gates,'XOR',f'x{zi:02}',f'y{zi:02}',None))
         curXor=findGates(gates,'XOR',f'x{zi:02}',f'y{zi:02}',None)[0][1][2]
         print('XOR',prevOr,curXor,f'z{zi:02}',findGates(gates,'XOR',prevOr,curXor,f'z{zi:02}'))
         if len(findGates(gates,'XOR',prevOr,curXor,f'z{zi:02}'))!=1:
            #TODO results.append
            print(prevCarry,prevAnd,prevOr,curXor,f'z{zi:02}')
      except Exception as e:
         print(f'ERROR at {zi=}:',e)
         break
      print()
   return ','.join(sorted(results))

def readsplit(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n').split('\n')

def main(filename='input'):
   time0=time.perf_counter_ns()

   input=readsplit(filename)

   time1=time.perf_counter_ns()

   state=0
   wires={}
   gates=[]
   for line in input:
      if line=='':
         state+=1
      elif state==0:
         wires[line[0:3]]=bool(int(line[5]))
      elif state==1:
         if line[3:7]==' OR ':
            gates.append((line[4:6],(line[0:3],line[7:10],line[14:17])))
         else:
            gates.append((line[4:7],(line[0:3],line[8:11],line[15:18])))
         for wire in gates[-1][1]:
            if wire not in wires:
               wires[wire]=None
   wrong=(4,'+')
   if filename.startswith('example'):
      wrong=(0,' ')
      if int(filename[7:])>=3:
         wrong=(2,'^')

   time2=time.perf_counter_ns()

   answer1=solve1(wires.copy(),gates)

   time3=time.perf_counter_ns()

   answer2=solve2(wires,gates,wrong)

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
   #main('example3')
   main()
