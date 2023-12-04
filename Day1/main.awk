BEGIN{sum=0;digits["one"]=1;digits["two"]=2;digits["three"]=3;digits["four"]=4;digits["five"]=5;digits["six"]=6;digits["seven"]=7;digits["eight"]=8;digits["nine"]=9}{
   match($0,/[0-9]|one|two|three|four|five|six|seven|eight|nine/,arr)
   first=(arr[0] in digits)?digits[arr[0]]:arr[0]
   match($0,/.*([0-9]|one|two|three|four|five|six|seven|eight|nine)/,arr)
   last=(arr[1] in digits)?digits[arr[1]]:arr[1]
   sum+=first*10+last
}END{print sum}
