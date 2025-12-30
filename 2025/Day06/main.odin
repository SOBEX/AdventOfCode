package main

import "base:intrinsics"
import "core:fmt"
import "core:math"
import "core:mem"
import os "core:os/os2"
import "core:slice"
import "core:strings"
import "core:time"

import "core:strconv"

solve_1::#force_no_inline proc(input:[]string)->(result:=0){
   input:=slice.clone(input)
   defer delete(input)
   l:=len(input)-1
   for op in strings.fields_iterator(&input[l]){
      acc:=strconv.parse_int(strings.fields_iterator(&input[0]) or_continue) or_continue
      for &line in input[1:l]{
         val:=strconv.parse_int(strings.fields_iterator(&line) or_continue) or_continue
         switch op[0]{
         case '+':
            acc+=val
         case '*':
            acc*=val
         }
      }
      result+=acc
   }
   return result
}

solve_2::#force_no_inline proc(input:[]string)->(result:=0){
   l:=len(input)-1
   op:u8
   acc:int
   for i in 0..<len(input[l]){
      cur_op:=input[l][i]
      if cur_op!=' '{
         op=cur_op
      }
      cur_acc:=0
      mult:=1
      for j:=l-1;j>=0;j-=1{
         digit:=input[j][i]
         if digit!=' '{
            cur_acc+=mult*int(digit-'0')
            mult*=10
         }
      }
      if cur_acc==0{
         result+=acc
         acc=0
      }else if acc==0{
         acc=cur_acc
      }else{
         switch op{
         case '+':
            acc+=cur_acc
         case '*':
            acc*=cur_acc
         }
      }
   }
   result+=acc
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
      "123 328  51 64 ",
      " 45 64  387 23 ",
      "  6 98  215 314",
      "*   +   *   +  "
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
   input:=input_split[:len(input_split)-1] if len(slice.last(input_split))==0 else input_split

   when DO_EXAMPLE_1{
      answer_example_1:intrinsics.type_proc_return_type(type_of(solve_1),0)
      durations_example_1:[DO_TIMING]time.Duration
      when DO_WARMING>0{
         for _ in 0..<DO_WARMING{
            answer_example_1=solve_1(example_1)
         }
      }
      for i in 0..<DO_TIMING{
         start_example_1:=time.tick_now()
         answer_example_1=solve_1(example_1)
         durations_example_1[i]=time.tick_since(start_example_1)
      }
   }

   when DO_INPUT_1{
      answer_input_1:intrinsics.type_proc_return_type(type_of(solve_1),0)
      durations_input_1:[DO_TIMING]time.Duration
      when DO_WARMING>0{
         for _ in 0..<DO_WARMING{
            answer_input_1=solve_1(input)
         }
      }
      for i in 0..<DO_TIMING{
         start_input_1:=time.tick_now()
         answer_input_1=solve_1(input)
         durations_input_1[i]=time.tick_since(start_input_1)
      }
   }

   when DO_EXAMPLE_2{
      answer_example_2:intrinsics.type_proc_return_type(type_of(solve_2),0)
      durations_example_2:[DO_TIMING]time.Duration
      when DO_WARMING>0{
         for _ in 0..<DO_WARMING{
            answer_example_2=solve_2(example_2)
         }
      }
      for i in 0..<DO_TIMING{
         start_example_2:=time.tick_now()
         answer_example_2=solve_2(example_2)
         durations_example_2[i]=time.tick_since(start_example_2)
      }
   }

   when DO_INPUT_2{
      answer_input_2:intrinsics.type_proc_return_type(type_of(solve_2),0)
      durations_input_2:[DO_TIMING]time.Duration
      when DO_WARMING>0{
         for _ in 0..<DO_WARMING{
            answer_input_2=solve_2(input)
         }
      }
      for i in 0..<DO_TIMING{
         start_input_2:=time.tick_now()
         answer_input_2=solve_2(input)
         durations_input_2[i]=time.tick_since(start_input_2)
      }
   }

   when DO_EXAMPLE_1 do slice.sort(durations_example_1[:])
   when DO_INPUT_1   do slice.sort(durations_input_1  [:])
   when DO_EXAMPLE_2 do slice.sort(durations_example_2[:])
   when DO_INPUT_2   do slice.sort(durations_input_2  [:])

   when DO_TIMING==1{
      when DO_EXAMPLE_1 do fmt.printfln("Example 1 took % 11.3fµs: %v",time.duration_microseconds(durations_example_1[0]),answer_example_1)
      when DO_INPUT_1   do fmt.printfln("Input   1 took % 11.3fµs: %v",time.duration_microseconds(durations_input_1  [0]),answer_input_1  )
      when DO_EXAMPLE_2 do fmt.printfln("Example 2 took % 11.3fµs: %v",time.duration_microseconds(durations_example_2[0]),answer_example_2)
      when DO_INPUT_2   do fmt.printfln("Input   2 took % 11.3fµs: %v",time.duration_microseconds(durations_input_2  [0]),answer_input_2  )
   }else{
      CUTOFF_START::DO_TIMING/10
      CUTOFF_END  ::DO_TIMING*9/10+1
      CUTOFF_COUNT::CUTOFF_END-CUTOFF_START

      when DO_EXAMPLE_1 do average_example_1:=time.duration_microseconds(math.sum(durations_example_1[CUTOFF_START:CUTOFF_END])/CUTOFF_COUNT)
      when DO_INPUT_1   do average_input_1  :=time.duration_microseconds(math.sum(durations_input_1  [CUTOFF_START:CUTOFF_END])/CUTOFF_COUNT)
      when DO_EXAMPLE_2 do average_example_2:=time.duration_microseconds(math.sum(durations_example_2[CUTOFF_START:CUTOFF_END])/CUTOFF_COUNT)
      when DO_INPUT_2   do average_input_2  :=time.duration_microseconds(math.sum(durations_input_2  [CUTOFF_START:CUTOFF_END])/CUTOFF_COUNT)

      when DO_EXAMPLE_1 do min_example_1:=time.duration_microseconds(durations_example_1[CUTOFF_START])
      when DO_INPUT_1   do min_input_1  :=time.duration_microseconds(durations_input_1  [CUTOFF_START])
      when DO_EXAMPLE_2 do min_example_2:=time.duration_microseconds(durations_example_2[CUTOFF_START])
      when DO_INPUT_2   do min_input_2  :=time.duration_microseconds(durations_input_2  [CUTOFF_START])

      when DO_EXAMPLE_1 do max_example_1:=time.duration_microseconds(durations_example_1[CUTOFF_END-1])
      when DO_INPUT_1   do max_input_1  :=time.duration_microseconds(durations_input_1  [CUTOFF_END-1])
      when DO_EXAMPLE_2 do max_example_2:=time.duration_microseconds(durations_example_2[CUTOFF_END-1])
      when DO_INPUT_2   do max_input_2  :=time.duration_microseconds(durations_input_2  [CUTOFF_END-1])

      when DO_EXAMPLE_1 do fmt.printfln("Example 1 took % 11.3fµs - % 11.3fµs - % 11.3fµs: %v",min_example_1,average_example_1,max_example_1,answer_example_1)
      when DO_INPUT_1   do fmt.printfln("Input   1 took % 11.3fµs - % 11.3fµs - % 11.3fµs: %v",min_input_1  ,average_input_1  ,max_input_1  ,answer_input_1  )
      when DO_EXAMPLE_2 do fmt.printfln("Example 2 took % 11.3fµs - % 11.3fµs - % 11.3fµs: %v",min_example_2,average_example_2,max_example_2,answer_example_2)
      when DO_INPUT_2   do fmt.printfln("Input   2 took % 11.3fµs - % 11.3fµs - % 11.3fµs: %v",min_input_2  ,average_input_2  ,max_input_2  ,answer_input_2  )
   }
}
