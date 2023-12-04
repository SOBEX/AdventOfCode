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
