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

import "core:strconv"

solve_1::proc(input:Input)->int{
   signal:=0
   X:=1
   cycle:=1
   for line in input{
      split:=strings.split(line," ")
      switch split[0]{
         case "noop":
            cycle+=1
            if cycle%40==20 do signal+=X*cycle
         case "addx":
            cycle+=1
            if cycle%40==20 do signal+=X*cycle
            X+=strconv.parse_int(split[1]) or_else 0
            cycle+=1
            if cycle%40==20 do signal+=X*cycle
      }
      delete(split)
   }
   return signal
}

solve_2::proc(input:Input)->int{
   screen:[6][40]u8
   X:=1
   cycle:=0
   for line in input{
      split:=strings.split(line," ")
      switch split[0]{
         case "noop":
            screen[(cycle/40)%6][cycle%40]=abs(X-(cycle%40))<=1?'#':'.';
            cycle+=1
         case "addx":
            screen[(cycle/40)%6][cycle%40]=abs(X-(cycle%40))<=1?'#':'.';
            cycle+=1
            screen[(cycle/40)%6][cycle%40]=abs(X-(cycle%40))<=1?'#':'.';
            cycle+=1
            X+=strconv.parse_int(split[1]) or_else 0
      }
      delete(split)
   }
   fmt.println()
   for row in screen{
      fmt.printfln("%s",row)
   }
   fmt.println()
   return 0
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
      "addx 15",
      "addx -11",
      "addx 6",
      "addx -3",
      "addx 5",
      "addx -1",
      "addx -8",
      "addx 13",
      "addx 4",
      "noop",
      "addx -1",
      "addx 5",
      "addx -1",
      "addx 5",
      "addx -1",
      "addx 5",
      "addx -1",
      "addx 5",
      "addx -1",
      "addx -35",
      "addx 1",
      "addx 24",
      "addx -19",
      "addx 1",
      "addx 16",
      "addx -11",
      "noop",
      "noop",
      "addx 21",
      "addx -15",
      "noop",
      "noop",
      "addx -3",
      "addx 9",
      "addx 1",
      "addx -3",
      "addx 8",
      "addx 1",
      "addx 5",
      "noop",
      "noop",
      "noop",
      "noop",
      "noop",
      "addx -36",
      "noop",
      "addx 1",
      "addx 7",
      "noop",
      "noop",
      "noop",
      "addx 2",
      "addx 6",
      "noop",
      "noop",
      "noop",
      "noop",
      "noop",
      "addx 1",
      "noop",
      "noop",
      "addx 7",
      "addx 1",
      "noop",
      "addx -13",
      "addx 13",
      "addx 7",
      "noop",
      "addx 1",
      "addx -33",
      "noop",
      "noop",
      "noop",
      "addx 2",
      "noop",
      "noop",
      "noop",
      "addx 8",
      "noop",
      "addx -1",
      "addx 2",
      "addx 1",
      "noop",
      "addx 17",
      "addx -9",
      "addx 1",
      "addx 1",
      "addx -3",
      "addx 11",
      "noop",
      "noop",
      "addx 1",
      "noop",
      "addx 1",
      "noop",
      "noop",
      "addx -13",
      "addx -19",
      "addx 1",
      "addx 3",
      "addx 26",
      "addx -30",
      "addx 12",
      "addx -1",
      "addx 3",
      "addx 1",
      "noop",
      "noop",
      "noop",
      "addx -9",
      "addx 18",
      "addx 1",
      "addx 2",
      "noop",
      "noop",
      "addx 9",
      "noop",
      "noop",
      "noop",
      "addx -1",
      "addx 2",
      "addx -37",
      "addx 1",
      "addx 3",
      "noop",
      "addx 15",
      "addx -21",
      "addx 22",
      "addx -6",
      "addx 1",
      "noop",
      "addx 2",
      "addx 1",
      "noop",
      "addx -10",
      "noop",
      "noop",
      "addx 20",
      "addx 1",
      "addx 2",
      "addx 2",
      "addx -6",
      "addx -11",
      "noop",
      "noop",
      "noop"
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

   result:=0
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

   answer_1_example:=-1
   answer_1_input:=-1
   answer_2_example:=-1
   answer_2_input:=-1

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
