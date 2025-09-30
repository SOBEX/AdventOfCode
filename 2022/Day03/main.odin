package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:time"

Time::time.Time
get_time::proc()->Time{
   return time.now()
}
get_duration_ns::proc(start,end:Time)->f64{
   return f64(time.duration_nanoseconds(time.diff(start,end)))
}
get_duration_us::proc(start,end:Time)->f64{
   return time.duration_microseconds(time.diff(start,end))
}
get_duration_ms::proc(start,end:Time)->f64{
   return time.duration_milliseconds(time.diff(start,end))
}
get_duration_s::proc(start,end:Time)->f64{
   return time.duration_seconds(time.diff(start,end))
}

Line::string
Input::[]Line
Position::[2]int
Cell::int
Row::[]Cell
Board::[]Row

solve_1::proc(input:Input)->int{
   sum:int=0
   for line in input{
      n:=len(line)
      l,r:bit_set['A'..='z']
      for i:=0;i<n/2;i+=1{
         l|={rune(line[i])}
      }
      for i:=n/2;i<n;i+=1{
         r|={rune(line[i])}
      }
      intersection:=l&r
      for letter in intersection{
         if 'a'<=letter&&letter<='z'{
            sum+=int(letter-'a')+1
         }else if 'A'<=letter&&letter<='Z'{
            sum+=int(letter-'A')+27
         }
      }
   }
   return sum
}

solve_2::proc(input:Input)->int{
   sum:int=0
   for i:=0;i<len(input);i+=3{
      e,f,g:bit_set['A'..='z']
      for j:=0;j<len(input[i]);j+=1{
         e|={rune(input[i][j])}
      }
      for j:=0;j<len(input[i+1]);j+=1{
         f|={rune(input[i+1][j])}
      }
      for j:=0;j<len(input[i+2]);j+=1{
         g|={rune(input[i+2][j])}
      }
      intersection:=e&f&g
      for letter in intersection{
         if 'a'<=letter&&letter<='z'{
            sum+=int(letter-'a')+1
         }else if 'A'<=letter&&letter<='Z'{
            sum+=int(letter-'A')+27
         }
      }
   }
   return sum
}

main::proc(){
   when ODIN_DEBUG{
      track:mem.Tracking_Allocator
      mem.tracking_allocator_init(&track,context.allocator)
      context.allocator=mem.tracking_allocator(&track)
      defer{
         if len(track.allocation_map)>0{
            fmt.eprintfln("=== %v allocations not freed: ===",len(track.allocation_map))
            for _,entry in track.allocation_map{
               fmt.eprintfln("- %v bytes @ %v",entry.size,entry.location)
            }
         }else{
            fmt.println("=== all allocations freed ===")
         }
         mem.tracking_allocator_destroy(&track)
      }
   }

   do_warming  :=0
   do_example_1:=true
   do_input_1  :=true
   do_example_2:=true
   do_input_2  :=true

   example_1:=Input{
      "vJrwpWtwJgWrhcsFMMfFFhFp",
      "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
      "PmmdzqPrVvPwwTWBwg",
      "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
      "ttgJtRGJQctTZtZT",
      "CrZsJsPPZsGzwwsLwLmpwMDw"
   }

   example_2:=example_1

   input_raw,ok:=os.read_entire_file("input")
   if !ok{
      fmt.println("ERROR: failed opening file 'input'")
      os.exit(1)
   }
   defer delete(input_raw)
   input_split:=strings.split_lines(string(input_raw))
   defer delete(input_split)
   input:=input_split[:len(input_split)-1]

   result:int=0
   for warming in 0..<do_warming{
      if do_example_1{
         result=solve_1(example_1)
      }
      if do_input_1{
         result=solve_1(input)
      }
      if do_example_2{
         result=solve_2(example_2)
      }
      if do_input_2{
         result=solve_2(input)
      }
   }
   result=0

   answer_1_example:int=-1
   answer_1_input:int=-1
   answer_2_example:int=-1
   answer_2_input:int=-1

   time_0:=get_time()
   if do_example_1{
      answer_1_example=solve_1(example_1)
   }
   time_1:=get_time()
   if do_input_1{
      answer_1_input=solve_1(input)
   }
   time_2:=get_time()
   if do_example_2{
      answer_2_example=solve_2(example_2)
   }
   time_3:=get_time()
   if do_input_2{
      answer_2_input=solve_2(input)
   }
   time_4:=get_time()

   fmt.printfln("Example 1 took % 9.4fms: %v",get_duration_ms(time_0,time_1),answer_1_example)
   fmt.printfln("Input   1 took % 9.4fms: %v",get_duration_ms(time_1,time_2),answer_1_input)
   fmt.printfln("Example 2 took % 9.4fms: %v",get_duration_ms(time_2,time_3),answer_2_example)
   fmt.printfln("Input   2 took % 9.4fms: %v",get_duration_ms(time_3,time_4),answer_2_input)
}
