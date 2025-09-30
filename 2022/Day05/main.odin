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

import "core:text/regex"
import "core:strconv"

solve_1::proc(input:Input)->string{
   part_one:=true
   cratess:[10][dynamic]u8
   rex,_:=regex.create("^move (\\d+) from (\\d+) to (\\d+)$")
   capture:=regex.preallocate_capture()
   for line,index in input{
      if part_one{
         if len(line)==0{
            #reverse for line in input[:index-1]{
               for i:=0;i*4+1<len(line);i+=1{
                  if line[i*4+1]!=' '{
                     append(&cratess[i],line[i*4+1])
                  }
               }
            }
            part_one=false
         }
      }else{
         _,ok:=regex.match(rex,line,&capture)
         if ok{
            n,_:=strconv.parse_int(capture.groups[1])
            from,_:=strconv.parse_int(capture.groups[2])
            to,_:=strconv.parse_int(capture.groups[3])
            for i in 1..=n{
               append(&cratess[to-1],cratess[from-1][len(cratess[from-1])-i])
            }
            resize(&cratess[from-1],len(cratess[from-1])-n)
         }
      }
   }
   regex.destroy(capture)
   regex.destroy(rex)
   result_builder:=strings.builder_make(0,10)
   for crates in cratess{
      if len(crates)>0{
         strings.write_rune(&result_builder,rune(crates[len(crates)-1]))
      }
      delete(crates)
   }
   result:=strings.clone(strings.to_string(result_builder))
   strings.builder_destroy(&result_builder)
   return result
}

solve_2::proc(input:Input)->string{
   part_one:=true
   cratess:[10][dynamic]u8
   rex,_:=regex.create("^move (\\d+) from (\\d+) to (\\d+)$")
   capture:=regex.preallocate_capture()
   for line,index in input{
      if part_one{
         if len(line)==0{
            #reverse for line in input[:index-1]{
               for i:=0;i*4+1<len(line);i+=1{
                  if line[i*4+1]!=' '{
                     append(&cratess[i],line[i*4+1])
                  }
               }
            }
            part_one=false
         }
      }else{
         _,ok:=regex.match(rex,line,&capture)
         if ok{
            n,_:=strconv.parse_int(capture.groups[1])
            from,_:=strconv.parse_int(capture.groups[2])
            to,_:=strconv.parse_int(capture.groups[3])
            append(&cratess[to-1],..cratess[from-1][len(cratess[from-1])-n:])
            resize(&cratess[from-1],len(cratess[from-1])-n)
         }
      }
   }
   regex.destroy(capture)
   regex.destroy(rex)
   result_builder:=strings.builder_make(0,10)
   for crates in cratess{
      if len(crates)>0{
         strings.write_rune(&result_builder,rune(crates[len(crates)-1]))
      }
      delete(crates)
   }
   result:=strings.clone(strings.to_string(result_builder))
   strings.builder_destroy(&result_builder)
   return result
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
      "    [D]    ",
      "[N] [C]    ",
      "[Z] [M] [P]",
      " 1   2   3 ",
      "",
      "move 1 from 2 to 1",
      "move 3 from 1 to 3",
      "move 2 from 2 to 1",
      "move 1 from 1 to 2"
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

   result:string
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
   result=""

   answer_1_example:string
   answer_1_input:string
   answer_2_example:string
   answer_2_input:string

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
