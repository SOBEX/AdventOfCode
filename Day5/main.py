def doMapping(seed,mapping):
   for row in mapping:
      if row[1]<=seed and seed<row[1]+row[2]:
         return seed-row[1]+row[0]
   return seed

def doMappings(seeds,mappings):
   for mapping in mappings:
      seeds=[doMapping(seed,mapping) for seed in seeds]
   return seeds

def solve1(seeds,mappings):
   return min(doMappings(seeds,mappings))

def doRangeMapping(seedRange,mapping):
   for row in mapping:
      begin=seedRange[0]
      mid1=min(max(row[1],seedRange[0]),seedRange[1])
      mid2=min(max(row[1]+row[2],seedRange[0]),seedRange[1])
      end=seedRange[1]
      if mid1<mid2:
         result=[(mid1-row[1]+row[0],mid2-row[1]+row[0])]
         if begin!=mid1:
            result.extend(doRangeMapping((begin,mid1),mapping))
         if mid2!=end:
            result.extend(doRangeMapping((mid2,end),mapping))
         return result
   return [seedRange]

def doRangeMappings(seedRanges,mappings):
   for mapping in mappings:
      seedRangesSquared=[doRangeMapping(seedRange,mapping) for seedRange in seedRanges]
      seedRanges=[seedRange for seedRanges in seedRangesSquared for seedRange in seedRanges]
   return seedRanges

def solve2(seeds,mappings):
   return min(doRangeMappings(seeds,mappings),key=lambda seedRange:seedRange[0])[0]

with open('input','r') as file:
   input=file.read().rstrip('\n')

seeds,*mappings=input.split('\n\n')
seeds=[int(n) for n in seeds.split(':')[1].split()]
mappings=[[[int(n) for n in row.split()] for row in mapping.split('\n')[1:]] for mapping in mappings]
seeds1=sorted(seeds)
seeds2=sorted([(seed[0],seed[0]+seed[1]) for seed in zip(seeds[::2],seeds[1::2])],key=lambda seed:seed[0])
mappings=[sorted(mapping,key=lambda row:row[0]) for mapping in mappings]

print(solve1(seeds1,mappings))
print(solve2(seeds2,mappings))
