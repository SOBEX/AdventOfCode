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

import "core:strconv"
import "core:slice"

solve_1::proc(input:[]string)->(result:=0){
   N:=len(input)
   array:=make([dynamic]int,N)
   parallel:=make([dynamic]bool,N)
   for line,index in input{
      array[index]=strconv.parse_int(line) or_continue
   }
   for from:=0;from<N;{
      if parallel[from]{
         from+=1
         continue
      }
      value:=array[from]
      to:=((from+value-1)%%(N-1))+1
      ordered_remove(&array,from)
      inject_at(&array,to,value)
      ordered_remove(&parallel,from)
      inject_at(&parallel,to,true)
   }
   delete(parallel)
   zero,_:=slice.linear_search(array[:],0)
   one:=array[(zero+1000)%%N]
   two:=array[(zero+2000)%%N]
   three:=array[(zero+3000)%%N]
   delete(array)
   return one+two+three
}

solve_2::proc(input:[]string)->(result:=0){
   N:=len(input)
   array:=make([dynamic]int,N)
   indexes:=make([dynamic]int,N)
   for line,index in input{
      value:=strconv.parse_int(line) or_continue
      array[index]=value*811589153
      indexes[index]=index
   }
   for i in 0..<10{
      for index in 0..<N{
         from,_:=slice.linear_search(indexes[:],index)
         value:=array[from]
         if value!=0{
            to:=((from+value-1)%%(N-1))+1
            ordered_remove(&array,from)
            inject_at(&array,to,value)
            ordered_remove(&indexes,from)
            inject_at(&indexes,to,index)
         }
      }
   }
   delete(indexes)
   zero,_:=slice.linear_search(array[:],0)
   one:=array[(zero+1000)%%N]
   two:=array[(zero+2000)%%N]
   three:=array[(zero+3000)%%N]
   delete(array)
   return one+two+three
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
      "1",
      "2",
      "-3",
      "3",
      "-2",
      "0",
      "4"
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
