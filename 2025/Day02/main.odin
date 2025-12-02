package main

import "base:intrinsics"
import "core:fmt"
import "core:mem"
import os "core:os/os2"
import "core:strings"
import "core:time"

import "core:strconv"

solve_1::#force_no_inline proc(input:[]string)->(result:=0){
   for line in input{
      full:=line
      for part in strings.split_iterator(&full,","){
         _right:=part
         _left:=strings.split_iterator(&_right,"-") or_continue
         left:=strconv.parse_int(_left) or_continue
         right:=strconv.parse_int(_right) or_continue
         for n in left..=right{
            s:=fmt.tprint(n)
            defer delete(s,context.temp_allocator)
            h:=len(s)/2
            if len(s)%%2==0&&s[:h]==s[h:]{
               result+=n
            }
         }
      }
   }
   return result
}

solve_2::#force_no_inline proc(input:[]string)->(result:=0){
   for line in input{
      full:=line
      for part in strings.split_iterator(&full,","){
         _right:=part
         _left:=strings.split_iterator(&_right,"-") or_continue
         left:=strconv.parse_int(_left) or_continue
         right:=strconv.parse_int(_right) or_continue
         next: for n in left..=right{
            s:=fmt.tprint(n)
            defer delete(s,context.temp_allocator)
            for l in 1..=len(s)/2{
               if len(s)%%l==0{
                  valid:=true
                  for i in 1..<len(s)/l{
                     if s[:l]!=s[i*l:(i+1)*l]{
                        valid=false
                        break
                     }
                  }
                  if valid{
                     result+=n
                     continue next
                  }
               }
            }
         }
      }
   }
   return result
}

main::proc(){
   when ODIN_DEBUG{
      original_allocator:=context.allocator
      tracking_allocator:mem.Tracking_Allocator
      mem.tracking_allocator_init(&tracking_allocator,original_allocator)
      tracking_allocator.bad_free_callback=mem.tracking_allocator_bad_free_callback_add_to_array
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

   DO_EXAMPLE_1::true
   DO_INPUT_1  ::true
   DO_EXAMPLE_2::true
   DO_INPUT_2  ::true
   DO_WARMING  ::0
   DO_TIMING   ::1

   example_1:=[]string{
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124",
   }

   example_2:=example_1

   input_raw,err:=os.read_entire_file("input",context.allocator)
   if err!=nil{
      fmt.println("ERROR: failed opening file 'input':",os.error_string(err))
      os.exit(1)
   }
   defer delete(input_raw,context.allocator)
   input_split:=strings.split_lines(string(input_raw),context.allocator)
   defer delete(input_split,context.allocator)
   input:=input_split[:len(input_split)-1]

   when DO_EXAMPLE_1 do answer_example_1:intrinsics.type_proc_return_type(type_of(solve_1),0)
   when DO_INPUT_1   do answer_input_1  :intrinsics.type_proc_return_type(type_of(solve_1),0)
   when DO_EXAMPLE_2 do answer_example_2:intrinsics.type_proc_return_type(type_of(solve_2),0)
   when DO_INPUT_2   do answer_input_2  :intrinsics.type_proc_return_type(type_of(solve_2),0)

   when DO_WARMING>0{
      for _ in 0..<DO_WARMING{
         when DO_EXAMPLE_1 do answer_example_1=solve_1(example_1)
         when DO_INPUT_1   do answer_input_1  =solve_1(input)
         when DO_EXAMPLE_2 do answer_example_1=solve_2(example_2)
         when DO_INPUT_2   do answer_input_1  =solve_2(input)
      }
   }

   when DO_EXAMPLE_1 do duration_example_1:time.Duration
   when DO_INPUT_1   do duration_input_1  :time.Duration
   when DO_EXAMPLE_2 do duration_example_2:time.Duration
   when DO_INPUT_2   do duration_input_2  :time.Duration

   DO_TIMING_REAL::max(1,DO_TIMING)
   for _ in 0..<DO_TIMING_REAL{
      when DO_EXAMPLE_1{
         start_example_1   :=time.tick_now()
         answer_example_1   =solve_1(example_1)
         duration_example_1+=time.tick_since(start_example_1)
      }
      when DO_INPUT_1{
         start_input_1     :=time.tick_now()
         answer_input_1     =solve_1(input)
         duration_input_1  +=time.tick_since(start_input_1)
      }
      when DO_EXAMPLE_2{
         start_example_2   :=time.tick_now()
         answer_example_2   =solve_2(example_2)
         duration_example_2+=time.tick_since(start_example_2)
      }
      when DO_INPUT_2{
         start_input_2     :=time.tick_now()
         answer_input_2     =solve_2(input)
         duration_input_2  +=time.tick_since(start_input_2)
      }
   }

   when DO_EXAMPLE_1 do fmt.printfln("Example 1 took % 9.4fms: %v",time.duration_milliseconds(duration_example_1)/DO_TIMING_REAL,answer_example_1)
   when DO_INPUT_1   do fmt.printfln("Input   1 took % 9.4fms: %v",time.duration_milliseconds(duration_input_1  )/DO_TIMING_REAL,answer_input_1  )
   when DO_EXAMPLE_2 do fmt.printfln("Example 2 took % 9.4fms: %v",time.duration_milliseconds(duration_example_2)/DO_TIMING_REAL,answer_example_2)
   when DO_INPUT_2   do fmt.printfln("Input   2 took % 9.4fms: %v",time.duration_milliseconds(duration_input_2  )/DO_TIMING_REAL,answer_input_2  )
}
