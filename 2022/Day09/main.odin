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
   tail:=Position{0,0}
   head:=Position{0,0}
   seen:map[Position]struct{}
   seen[tail]={}
   for line in input{
      length:=strconv.parse_int(line[2:]) or_else 0
      direction:=Position{
         line[0]=='L'?-1:line[0]=='R'?1:0,
         line[0]=='U'?-1:line[0]=='D'?1:0
      }
      for i in 0..<length{
         head+=direction
         dx:=head[0]-tail[0]
         dy:=head[1]-tail[1]
         if dx*dx+dy*dy>=4{
            if dx>0 do tail[0]+=1
            else if dx<0 do tail[0]-=1
            if dy>0 do tail[1]+=1
            else if dy<0 do tail[1]-=1
            seen[tail]={}
         }
      }
   }
   count:=len(seen)
   delete(seen)
   return count
}

solve_2::proc(input:Input)->int{
   rope:=[10]Position{0..<10={0,0}}
   seen:map[Position]struct{}
   seen[rope[9]]={}
   for line in input{
      length:=strconv.parse_int(line[2:]) or_else 0
      direction:=Position{
         line[0]=='L'?-1:line[0]=='R'?1:0,
         line[0]=='U'?-1:line[0]=='D'?1:0
      }
      for i in 0..<length{
         rope[0]+=direction
         j:=0
         for ;j<9;j+=1{
            dx:=rope[j][0]-rope[j+1][0]
            dy:=rope[j][1]-rope[j+1][1]
            if dx*dx+dy*dy>=4{
               if dx>0 do rope[j+1][0]+=1
               else if dx<0 do rope[j+1][0]-=1
               if dy>0 do rope[j+1][1]+=1
               else if dy<0 do rope[j+1][1]-=1
            }
         }
         seen[rope[9]]={}
      }
   }
   count:=len(seen)
   delete(seen)
   return count
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
      "R 4",
      "U 4",
      "L 3",
      "D 1",
      "R 4",
      "D 1",
      "L 5",
      "R 2"
   }

   example_2:=Input{
      "R 5",
      "U 8",
      "L 8",
      "D 3",
      "R 17",
      "D 10",
      "L 25",
      "U 20"
   }

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

   fmt.printfln("Example 1 took % 6.1fms: %v",get_duration_ms(time_0,time_1),answer_1_example)
   fmt.printfln("Input   1 took % 6.1fms: %v",get_duration_ms(time_1,time_2),answer_1_input)
   fmt.printfln("Example 2 took % 6.1fms: %v",get_duration_ms(time_2,time_3),answer_2_example)
   fmt.printfln("Input   2 took % 6.1fms: %v",get_duration_ms(time_3,time_4),answer_2_input)
}
