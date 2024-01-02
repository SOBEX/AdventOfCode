import time

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

time0=time.perf_counter()

with open('input','r') as file:
   input=file.read().rstrip('\n')

time1=time.perf_counter()

seeds,*mappings=input.split('\n\n')
seeds=[int(n) for n in seeds.split(':')[1].split()]
mappings=[[[int(n) for n in row.split()] for row in mapping.split('\n')[1:]] for mapping in mappings]
seeds1=sorted(seeds)
seeds2=sorted([(seed[0],seed[0]+seed[1]) for seed in zip(seeds[::2],seeds[1::2])],key=lambda seed:seed[0])
mappings=[sorted(mapping,key=lambda row:row[0]) for mapping in mappings]

time2=time.perf_counter()

answer1=solve1(seeds1,mappings)

time3=time.perf_counter()

answer2=solve2(seeds2,mappings)

time4=time.perf_counter()

read=(time1-time0)*1000
parsed=(time2-time1)*1000
part1=(time3-time2)*1000
part2=(time4-time3)*1000
print(f'Read input in {read}ms')
print(f'Parsed input in {parsed}ms')
print(f'Answer to part 1 is {answer1}, computed in {part1}ms')
print(f'Answer to part 2 is {answer2}, computed in {part2}ms')
