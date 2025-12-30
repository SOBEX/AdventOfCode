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
   for line in input{
      full:=line
      _lights:=strings.split_iterator(&full," ") or_continue
      _lights=_lights[1:len(_lights)-1]
      lights:=make([]bool,len(_lights))
      defer delete(lights)
      for c,i in _lights{
         lights[i]=c=='#'
      }
      buttons:[dynamic][dynamic]int
      defer delete(buttons)
      defer for button in buttons do delete(button)
      last:=strings.split_iterator(&full," ") or_continue
      for part in strings.split_iterator(&full," "){
         last=last[1:len(last)-1]
         button:[dynamic]int
         for b in strings.split_iterator(&last,","){
            append(&button,strconv.parse_int(b) or_continue)
         }
         append(&buttons,button)
         last=part
      }
      State::struct{
         lights:[]bool,
         presses:int
      }
      states:[dynamic]State
      defer delete(states)
      defer for state in states do delete(state.lights)
      append(&states,State{make([]bool,len(lights)),0})
      for i in 0..<len(buttons){
         l:=len(states)
         for j in 0..<l{
            state:=states[j]
            new_lights:=slice.clone(state.lights)
            for press in buttons[i]{
               new_lights[press]=!new_lights[press]
            }
            new_presses:=state.presses+1
            append(&states,State{new_lights,new_presses})
         }
      }
      best:=max(int)
      for state in states{
         if slice.equal(state.lights,lights)&&state.presses<best{
            best=state.presses
         }
      }
      result+=best
   }
   return result
}

solve_2::#force_no_inline proc(input:[]string)->(result:=0){
   fmt.println("import z3")
   fmt.println()
   fmt.println("result=0")
   for line in input{
      full:=line
      lights:=strings.split_iterator(&full," ") or_continue
      length:=len(lights)-2
      buttons:[dynamic][]int
      defer delete(buttons)
      last:=strings.split_iterator(&full," ") or_continue
      for part in strings.split_iterator(&full," "){
         last=last[1:len(last)-1]
         button:=make([]int,length)
         for b in strings.split_iterator(&last,","){
            button[strconv.parse_int(b) or_continue]=1
         }
         append(&buttons,button)
         last=part
      }
      defer for button in buttons do delete(button)
      last=last[1:len(last)-1]
      values:=make([dynamic]int,0,length)
      defer delete(values)
      for v in strings.split_iterator(&last,","){
         append(&values,strconv.parse_int(v) or_continue)
      }
      for i in 0..<length-1{
         min_value:=max(int)
         min_index:=-1
         for j in i..<length{
            count:=0
            for button in buttons{
               valid:=button[i]!=0
               for k in 0..<i{
                  if button[k]!=0{
                     valid=false
                     break
                  }
               }
               if valid{
                  count+=1
               }
            }
            value:=values[j]+count-1
            score:=1
            if count>=2{
               for i in 0..<count-1{
                  score=score*(value-i)/(i+1)
               }
            }
            if score<min_value{
               min_value=score
               min_index=j
            }
         }
         if min_index!=i{
            values[min_index],values[i]=values[i],values[min_index]
            for button in buttons{
               button[min_index],button[i]=button[i],button[min_index]
            }
         }
      }
      slice.sort_by(buttons[:],proc(l,r:[]int)->bool{
         for i in 0..<len(l){
            if l[i]!=r[i] do return l[i]>r[i]
         }
         return false
      })
      for i in 0..<len(buttons){
         if i!=0 do fmt.print(",")
         fmt.print("b")
         fmt.print(i)
      }
      fmt.print("=z3.Ints('")
      for i in 0..<len(buttons){
         if i!=0 do fmt.print(" ")
         fmt.print("b")
         fmt.print(i)
      }
      fmt.println("')")
      fmt.println("optimizer=z3.Optimize()")
      for i in 0..<length{
         fmt.print("optimizer.add(")
         first:=true
         for button,bi in buttons{
            if button[i]!=0{
               if first{
                  first=false
               }else{
                  fmt.print("+")
               }
               fmt.print("b")
               fmt.print(bi)
            }
         }
         fmt.print("==")
         fmt.print(values[i])
         fmt.println(")")
      }
      fmt.print("optimizer.minimize(")
      for i in 0..<len(buttons){
         if i!=0 do fmt.print("+")
         fmt.print("b")
         fmt.print(i)
      }
      fmt.println(")")
      for i in 0..<len(buttons){
         fmt.print("optimizer.add(b")
         fmt.print(i)
         fmt.println(">=0)")
      }
      fmt.println("optimizer.check()")
      fmt.println("model=optimizer.model()")
      for i in 0..<len(buttons){
         fmt.print("result+=model[b")
         fmt.print(i)
         fmt.println("].as_long()")
      }
      fmt.println()
   }
   fmt.println("print(result)")
   fmt.println()
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
      "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}",
      "[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}",
      "[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"
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
