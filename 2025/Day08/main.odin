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
   boxes:[dynamic][3]int
   defer delete(boxes)
   for line in input{
      _z:=line
      _x:=strings.split_iterator(&_z,",") or_continue
      _y:=strings.split_iterator(&_z,",") or_continue
      x:=strconv.parse_int(_x) or_continue
      y:=strconv.parse_int(_y) or_continue
      z:=strconv.parse_int(_z) or_continue
      append(&boxes,[3]int{x,y,z})
   }
   connections:map[[2]int]int
   defer delete(connections)
   for i in 0..<(10 if len(input)<=20 else 1000){
      best:=max(int)
      besti:=[2]int{-1,-1}
      for l,_li in boxes{
         for r,_ri in boxes{
            li,ri:=_li,_ri
            if li>ri do li,ri=ri,li
            if li!=ri{
               i:=[2]int{li,ri}
               if i not_in connections{
                  d:=(l-r)*(l-r)
                  s:=d.x+d.y+d.z
                  if s<best{
                     best=s
                     besti=i
                  }
               }
            }
         }
      }
      connections[besti]=best
   }
   results:[dynamic]int
   defer delete(results)
   seen:=make([]bool,len(boxes))
   defer delete(seen)
   for i in 0..<len(boxes){
      if !seen[i]{
         circuit:[dynamic]int
         defer delete(circuit)
         append(&circuit,i)
         seen[i]=true
         for j:=0;j<len(circuit);j+=1{
            k:=circuit[j]
            next:for connection in connections{
               if k==connection[0]{
                  for l in circuit{
                     if l==connection[1]{
                        continue next
                     }
                  }
                  append(&circuit,connection[1])
                  seen[connection[1]]=true
               }else if k==connection[1]{
                  for l in circuit{
                     if l==connection[0]{
                        continue next
                     }
                  }
                  append(&circuit,connection[0])
                  seen[connection[0]]=true
               }
            }
         }
         append(&results,len(circuit))
      }
   }
   slice.reverse_sort(results[:])
   return results[0]*results[1]*results[2]
}

solve_2::#force_no_inline proc(input:[]string)->(result:=0){
   boxes:[dynamic][3]int
   defer delete(boxes)
   for line in input{
      _z:=line
      _x:=strings.split_iterator(&_z,",") or_continue
      _y:=strings.split_iterator(&_z,",") or_continue
      x:=strconv.parse_int(_x) or_continue
      y:=strconv.parse_int(_y) or_continue
      z:=strconv.parse_int(_z) or_continue
      append(&boxes,[3]int{x,y,z})
   }
   worst:=min(int)
   worstr:=-1
   for l,li in boxes{
      best:=max(int)
      bestr:=-1
      for r,ri in boxes{
         if li!=ri{
            d:=(l-r)*(l-r)
            s:=d.x+d.y+d.z
            if s<best{
               best=s
               bestr=l.x*r.x
            }
         }
      }
      if best>worst{
         worst=best
         worstr=bestr
      }
   }
   return worstr
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
      "162,817,812",
      "57,618,57",
      "906,360,560",
      "592,479,940",
      "352,342,300",
      "466,668,158",
      "542,29,236",
      "431,825,988",
      "739,650,466",
      "52,470,668",
      "216,146,977",
      "819,987,18",
      "117,168,530",
      "805,96,715",
      "346,949,466",
      "970,615,88",
      "941,993,340",
      "862,61,35",
      "984,92,344",
      "425,690,689"
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
