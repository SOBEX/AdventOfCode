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

import "core:text/regex"
import "core:strconv"

adjacents:=[6][3]int{{-1,0,0},{1,0,0},{0,-1,0},{0,1,0},{0,0,-1},{0,0,1}}

solve_1::proc(input:[]string)->(result:=0){
   positions:map[[3]int]struct{}
   rex,_:=regex.create("^(\\d+),(\\d+),(\\d+)$")
   capture:=regex.preallocate_capture()
   for line in input{
      _,ok:=regex.match(rex,line,&capture)
      if ok{
         x:=strconv.parse_int(capture.groups[1]) or_continue
         y:=strconv.parse_int(capture.groups[2]) or_continue
         z:=strconv.parse_int(capture.groups[3]) or_continue
         position:=[3]int{x,y,z}
         if position not_in positions{
            for adjacent in adjacents{
               if position+adjacent in positions{
                  result-=1
               }else{
                  result+=1
               }
            }
            positions[position]={}
         }
      }
   }
   regex.destroy(capture)
   regex.destroy(rex)
   delete(positions)
   return result
}

solve_2::proc(input:[]string)->(result:=0){
   positions:map[[3]int]bool
   max:=[3]int{0,0,0}
   rex,_:=regex.create("^(\\d+),(\\d+),(\\d+)$")
   capture:=regex.preallocate_capture()
   for line in input{
      _,ok:=regex.match(rex,line,&capture)
      if ok{
         x:=strconv.parse_int(capture.groups[1]) or_continue
         y:=strconv.parse_int(capture.groups[2]) or_continue
         z:=strconv.parse_int(capture.groups[3]) or_continue
         position:=[3]int{x,y,z}
         positions[position]=true
         if x>max.x do max.x=x
         if y>max.y do max.y=y
         if z>max.z do max.z=z
      }
   }
   max_size:=(max.x+3)*(max.y+3)*(max.z+3)
   reserve(&positions,max_size)
   stack:=make([dynamic][3]int,0,max_size)
   append(&stack,[3]int{-1,-1,-1})
   fmt.println(max,result)
   for len(stack)>0{
      position:=pop(&stack)
      if position not_in positions{
         for adjacent in adjacents{
            p:=position+adjacent
            if -1<=p.x&&p.x<=max.x+1&&-1<=p.y&&p.y<=max.y+1&&-1<=p.z&&p.z<=max.z+1{
               if p in positions{
                  if positions[p]{
                     result+=1
                  }
               }else{
                  append(&stack,p)
               }
            }
         }
         positions[position]=false
      }
   }
   delete(stack)
   regex.destroy(capture)
   regex.destroy(rex)
   delete(positions)
   return result
}

main::proc(){
   when ODIN_DEBUG{
      original_allocator:=context.allocator
      tracking_allocator:mem.Tracking_Allocator
      mem.tracking_allocator_init(&tracking_allocator,original_allocator)
      context.allocator=mem.tracking_allocator(&tracking_allocator)
      defer{
         good:=true
         bad_alloc_count:=len(tracking_allocator.allocation_map)
         if bad_alloc_count>0{
            good=false
            fmt.eprintfln("=== %v allocations not freed: ===",bad_alloc_count)
            for _,entry in tracking_allocator.allocation_map{
               fmt.eprintfln("- %v bytes @ %v",entry.size,entry.location)
            }
         }
         bad_free_count:=len(tracking_allocator.bad_free_array)
         if bad_free_count>0{
            good=false
            fmt.eprintfln("=== %v incorrect frees: ===",bad_free_count)
            for entry in tracking_allocator.bad_free_array{
               fmt.eprintfln("- %p @ %v",entry.memory,entry.location)
            }
         }
         if good{
            fmt.println("=== all allocations freed ===")
         }
         context.allocator=original_allocator
         mem.tracking_allocator_destroy(&tracking_allocator)
      }
   }

   do_warming  ::0
   do_example_1::true
   do_input_1  ::true
   do_example_2::true
   do_input_2  ::true

   example_1:=[]string{
      "2,2,2",
      "1,2,2",
      "3,2,2",
      "2,1,2",
      "2,3,2",
      "2,2,1",
      "2,2,3",
      "2,2,4",
      "2,2,6",
      "1,2,5",
      "3,2,5",
      "2,1,5",
      "2,3,5"
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

   when do_warming>0{
      result:=0
      for warming in 0..<do_warming{
         when do_example_1{
            result=solve_1(example_1)
         }
         when do_input_1{
            result=solve_1(input)
         }
         when do_example_2{
            result=solve_2(example_2)
         }
         when do_input_2{
            result=solve_2(input)
         }
      }
   }

   time_0:=get_time()
   when do_example_1 do answer_1_example:=solve_1(example_1)
   time_1:=get_time()
   when do_input_1   do answer_1_input  :=solve_1(input)
   time_2:=get_time()
   when do_example_2 do answer_2_example:=solve_2(example_2)
   time_3:=get_time()
   when do_input_2   do answer_2_input  :=solve_2(input)
   time_4:=get_time()

   when do_example_1 do fmt.printfln("Example 1 took % 9.4fms: %v",get_duration_ms(time_0,time_1),answer_1_example)
   when do_input_1   do fmt.printfln("Input   1 took % 9.4fms: %v",get_duration_ms(time_1,time_2),answer_1_input)
   when do_example_2 do fmt.printfln("Example 2 took % 9.4fms: %v",get_duration_ms(time_2,time_3),answer_2_example)
   when do_input_2   do fmt.printfln("Input   2 took % 9.4fms: %v",get_duration_ms(time_3,time_4),answer_2_input)
}
