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
   return time.duration_milliseconds(time.diff(start,end))
}
get_duration_ms::proc(start,end:Time)->f64{
   return time.duration_microseconds(time.diff(start,end))
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

import "core:strconv"

solve_1::proc(input:Input)->int{
   sum:int=0
   for line in input{
      split:=strings.split(line,",")
      defer delete(split)
      l:=strings.split(split[0],"-")
      defer delete(l)
      r:=strings.split(split[1],"-")
      defer delete(r)
      ll,_:=strconv.parse_int(l[0])
      lr,_:=strconv.parse_int(l[1])
      rl,_:=strconv.parse_int(r[0])
      rr,_:=strconv.parse_int(r[1])
      if (ll<=rl&&rr<=lr)||(rl<=ll&&lr<=rr){
         sum+=1
      }
   }
   return sum
}

solve_2::proc(input:Input)->int{
   sum:int=0
   for line in input{
      split:=strings.split(line,",")
      defer delete(split)
      l:=strings.split(split[0],"-")
      defer delete(l)
      r:=strings.split(split[1],"-")
      defer delete(r)
      ll,_:=strconv.parse_int(l[0])
      lr,_:=strconv.parse_int(l[1])
      rl,_:=strconv.parse_int(r[0])
      rr,_:=strconv.parse_int(r[1])
      if (ll<=rl&&rl<=lr)||(ll<=rr&&rr<=lr)||(rl<=ll&&ll<=rr)||(rl<=lr&&lr<=rr){
         sum+=1
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
      "2-4,6-8",
      "2-3,4-5",
      "5-7,7-9",
      "2-8,3-7",
      "6-6,4-6",
      "2-6,4-8"
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

   fmt.printfln("Example 1 took % 6.1fms: %v",get_duration_ms(time_0,time_1),answer_1_example)
   fmt.printfln("Input   1 took % 6.1fms: %v",get_duration_ms(time_1,time_2),answer_1_input)
   fmt.printfln("Example 2 took % 6.1fms: %v",get_duration_ms(time_2,time_3),answer_2_example)
   fmt.printfln("Input   2 took % 6.1fms: %v",get_duration_ms(time_3,time_4),answer_2_input)
}
