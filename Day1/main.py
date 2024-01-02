def getDigits(line):
   digits=''.join(filter(str.isdigit,line))
   return int(digits[0]+digits[-1])

def getReplaced(line):
   for digit,text in enumerate(['zero','one','two','three','four','five','six','seven','eight','nine']):
      while(True):
         newline=line.replace(text,text[0]+str(digit)+text[-1])
         if(line==newline):
            break
         line=newline
   return line

with open('input','r') as file:
   input=file.readlines()

print(sum([getDigits(line) for line in input]))
print(sum([getDigits(getReplaced(line)) for line in input]))


print(
      sum(
          map(
              lambda digits:int(digits[0]+digits[-1]),
              map(
                  lambda line:list(
                                   filter(
                                          str.isdigit,
                                          line
                                         )
                                  ),
                  map(
                      lambda line:line.rstrip('\n'),
                      open('input')
                     )
                 )
             )
         )
     )

print(sum(int(d[0]+d[-1])for d in(list(filter(str.isdigit,l))for l in open('input'))))

import re
n=[r'^1',r'^one',r'^2',r'^two',r'^3',r'^three',r'^4',r'^four',r'^5',r'^five',r'^6',r'^six',r'^7',r'^seven',r'^8',r'^eight',r'^9',r'^nine']
print(sum(d[0]*10+d[-1]for d in(list(filter(lambda i:i>0,(next((j//2+1 for j,r in enumerate(n)if re.match(r,l[i:])),0)for i in range(len(l)))))for l in open('input'))))
