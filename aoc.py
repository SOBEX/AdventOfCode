import re

def readFile(filename):
   with open(filename,'r') as file:
      return file.read().rstrip('\n')

def parseString(string):
   try:
      return int(string)
   except:
      try:
         return float(string)
      except:
         return string

def parse(content,regex):
   matched=[]
   for match in re.finditer(regex,content):
      matched.append(tuple(parseString(group) for group in match.groups()))
   return matched

def parseLines(content,regex=None):
   if regex is None:
      return content.split('\n')
   parsed=[]
   multiple=False
   for line in content.split('\n'):
      matched=[]
      for match in re.finditer(regex,line):
         groups=match.groups()
         if len(groups)==0:
            matched.append(parseString(match.group(0)))
         elif len(groups)==1:
            matched.append(parseString(groups[0]))
         else:
            matched.append(tuple(parseString(group) for group in match.groups()))
      if len(matched)>1 and not multiple:
         parsed=[[parse] for parse in parsed]
         multiple=True
      if multiple:
         parsed.append(matched)
      elif len(matched)==1:
         parsed.append(matched[0])
   return parsed
   return [line for line in content.split('\n')]

def parseSections(content):
   return content.split('\n\n')

def parseGrid(content):
   return [[character for character in line] for line in content.split('\n')]

def parseGrids(content):
   return [[[character for character in line] for line in grid] for grid in content.split('\n\n')]
