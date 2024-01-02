import re

def getRegex(input,regex):
   found=[]
   for y,line in enumerate(input):
      found.extend([[match.group(0),y,match.start(),match.start()+len(match.group(0))-1] for match in re.finditer(regex,line)])
   return found

def areAdjacent(number,symbol):
   return abs(number[1]-symbol[1])<=1 and number[2]-1<=symbol[2] and symbol[3]<=number[3]+1

with open('input','r') as file:
   input=[line.rstrip('\n') for line in file.readlines()]

p1=0
for number in getRegex(input,r'\d+'):
   symbols=list(filter(lambda symbol:areAdjacent(number,symbol),getRegex(input,r'[^\d\.]')))
   if len(symbols)>=1:
      p1+=int(number[0])
print(p1)

p2=0
for star in getRegex(input,r'\*'):
   numbers=list(filter(lambda number:areAdjacent(number,star),getRegex(input,r'\d+')))
   if(len(numbers)==2):
      p2+=int(numbers[0][0])*int(numbers[1][0])
print(p2)
