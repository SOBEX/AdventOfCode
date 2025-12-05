package main

import "base:intrinsics"
import "core:fmt"
import "core:math"
import "core:mem"
import os "core:os/os2"
import "core:sort"
import "core:strings"
import "core:time"

import "core:strconv"

solve_1::#force_no_inline proc(input:[]string)->(result:=0){
   ranges:[dynamic][2]int
   defer delete(ranges)
   in_ranges:=true
   for line in input{
      if len(line)==0{
         in_ranges=false
         continue
      }
      if in_ranges{
         _right:=line
         _left:=strings.split_iterator(&_right,"-") or_continue
         left:=strconv.parse_int(_left) or_continue
         right:=strconv.parse_int(_right) or_continue
         append(&ranges,[2]int{left,right})
      }else{
         id:=strconv.parse_int(line) or_continue
         for range in ranges{
            if range[0]<=id&&id<=range[1]{
               result+=1
               break
            }
         }
      }
   }
   return result
}

import "core:slice/heap"

solve_2::#force_no_inline proc(input:[]string)->(result:=0){
   ranges:=make([][2]int,len(input))
   defer delete(ranges)
   ranges_length:=0
   ranges_less::proc(l,r:[2]int)->bool{
      return l[0]>r[0]
   }
   for line in input{
      if len(line)==0{
         break
      }
      _right:=line
      _left:=strings.split_iterator(&_right,"-") or_continue
      left:=strconv.parse_int(_left) or_continue
      right:=strconv.parse_int(_right) or_continue
      ranges[ranges_length]={left,right}
      ranges_length+=1
      heap.push(ranges[:ranges_length],ranges_less)
   }
   cur:=0
   for ranges_length>0{
      range:=ranges[0]
      if cur<range[0]{
         result+=range[1]-range[0]+1
         cur=range[1]+1
      }else if cur<=range[1]{
         result+=range[1]-cur+1
         cur=range[1]+1
      }
      heap.pop(ranges[:ranges_length],ranges_less)
      ranges_length-=1
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
   DO_WARMING  ::100
   DO_TIMING   ::1000

   example_1:=[]string{
      "3-5",
      "10-14",
      "16-20",
      "12-18",
      "",
      "1",
      "5",
      "8",
      "11",
      "17",
      "32"
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
         when DO_EXAMPLE_2 do answer_example_2=solve_2(example_2)
         when DO_INPUT_2   do answer_input_2  =solve_2(input)
      }
   }

   when DO_EXAMPLE_1 do durations_example_1:[DO_TIMING]time.Duration
   when DO_INPUT_1   do durations_input_1  :[DO_TIMING]time.Duration
   when DO_EXAMPLE_2 do durations_example_2:[DO_TIMING]time.Duration
   when DO_INPUT_2   do durations_input_2  :[DO_TIMING]time.Duration

   for i in 0..<DO_TIMING{
      when DO_EXAMPLE_1{
         start_example_1       :=time.tick_now()
         answer_example_1       =solve_1(example_1)
         durations_example_1[i] =time.tick_since(start_example_1)
      }
      when DO_INPUT_1{
         start_input_1         :=time.tick_now()
         answer_input_1         =solve_1(input)
         durations_input_1[i]   =time.tick_since(start_input_1)
      }
      when DO_EXAMPLE_2{
         start_example_2       :=time.tick_now()
         answer_example_2       =solve_2(example_2)
         durations_example_2[i] =time.tick_since(start_example_2)
      }
      when DO_INPUT_2{
         start_input_2         :=time.tick_now()
         answer_input_2         =solve_2(input)
         durations_input_2[i]   =time.tick_since(start_input_2)
      }
   }

   when DO_EXAMPLE_1 do sort.quick_sort(durations_example_1[:])
   when DO_INPUT_1   do sort.quick_sort(durations_input_1  [:])
   when DO_EXAMPLE_2 do sort.quick_sort(durations_example_2[:])
   when DO_INPUT_2   do sort.quick_sort(durations_input_2  [:])

   CUTOFF_START::DO_TIMING  /10
   CUTOFF_END  ::DO_TIMING*9/10
   CUTOFF_COUNT::CUTOFF_END-CUTOFF_START

   when DO_EXAMPLE_1 do duration_example_1:=durations_example_1[0] when DO_TIMING==1 else math.sum(durations_example_1[CUTOFF_START:CUTOFF_END])/CUTOFF_COUNT
   when DO_INPUT_1   do duration_input_1  :=durations_input_1  [0] when DO_TIMING==1 else math.sum(durations_input_1  [CUTOFF_START:CUTOFF_END])/CUTOFF_COUNT
   when DO_EXAMPLE_2 do duration_example_2:=durations_example_2[0] when DO_TIMING==1 else math.sum(durations_example_2[CUTOFF_START:CUTOFF_END])/CUTOFF_COUNT
   when DO_INPUT_2   do duration_input_2  :=durations_input_2  [0] when DO_TIMING==1 else math.sum(durations_input_2  [CUTOFF_START:CUTOFF_END])/CUTOFF_COUNT

   when DO_EXAMPLE_1 do fmt.printfln("Example 1 took % 11.3fµs: %v",time.duration_microseconds(duration_example_1),answer_example_1)
   when DO_INPUT_1   do fmt.printfln("Input   1 took % 11.3fµs: %v",time.duration_microseconds(duration_input_1  ),answer_input_1  )
   when DO_EXAMPLE_2 do fmt.printfln("Example 2 took % 11.3fµs: %v",time.duration_microseconds(duration_example_2),answer_example_2)
   when DO_INPUT_2   do fmt.printfln("Input   2 took % 11.3fµs: %v",time.duration_microseconds(duration_input_2  ),answer_input_2  )
}
