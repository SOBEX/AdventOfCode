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
   boxes:[6][dynamic][3][3]bool
   defer for box in boxes do delete(box)
   for i in 0..<6{
      box:[3][3]bool
      for y in 0..<3{
         for x in 0..<3{
            box[y][x]=input[i*5+1+y][x]=='#'
         }
      }
      append(&boxes[i],box)
      flippedx:[3][3]bool
      flippedy:[3][3]bool
      flippedz:[3][3]bool
      for y in 0..<3{
         for x in 0..<3{
            flippedx[y][x]=box[y][2-x]
            flippedy[y][x]=box[2-y][x]
            flippedz[y][x]=box[2-y][2-x]
         }
      }
      if slice.count(boxes[i][:],flippedx)==0{
         append(&boxes[i],flippedx)
      }
      if slice.count(boxes[i][:],flippedy)==0{
         append(&boxes[i],flippedx)
      }
      if slice.count(boxes[i][:],flippedz)==0{
         append(&boxes[i],flippedx)
      }
      rotated:[3][3]bool
      rotatedx:[3][3]bool
      rotatedy:[3][3]bool
      rotatedz:[3][3]bool
      for j in 0..<3{
         for y in 0..<3{
            for x in 0..<3{
               rotated[y][x]=box[x][2-y]
               rotatedx[y][x]=flippedx[x][2-y]
               rotatedy[y][x]=flippedy[x][2-y]
               rotatedz[y][x]=flippedz[x][2-y]
            }
         }
         if slice.count(boxes[i][:],rotated)==0{
            append(&boxes[i],rotated)
         }
         if slice.count(boxes[i][:],rotatedx)==0{
            append(&boxes[i],rotatedx)
         }
         if slice.count(boxes[i][:],rotatedy)==0{
            append(&boxes[i],rotatedy)
         }
         if slice.count(boxes[i][:],rotatedz)==0{
            append(&boxes[i],rotatedz)
         }
         box=rotated
         flippedx=rotatedx
         flippedy=rotatedy
         flippedz=rotatedz
      }
   }
   fmt.println(boxes)
   for line,l in input[30:]{
      _quantities:=line
      _height:=strings.split_iterator(&_quantities,": ") or_continue
      _width:=strings.split_iterator(&_height,"x") or_continue
      width:=strconv.parse_int(_width) or_continue
      height:=strconv.parse_int(_height) or_continue
      quantities:[6]int
      i:=0
      for s in strings.split_iterator(&_quantities," "){
         quantities[i]=strconv.parse_int(s) or_continue
         i+=1
      }
      fmt.println(l,width,height,quantities)
      board:=make([]bool,width*height)
      defer delete(board)
      attempts:=100_000
      solve::proc(board:[]bool,width,height:int,boxes:^[6][dynamic][3][3]bool,quantities:^[6]int,attempts:^int)->bool{
         if attempts^<=0{
            return false
         }
         if attempts^%%10_000==0 do fmt.println(attempts^)
         attempts^-=1
         bi:=-1
         for &q,i in quantities{
            if q>0{
               q-=1
               bi=i
               break
            }
         }
         if bi==-1{
            for y in 0..<height{
               for x in 0..<width{
                  fmt.print(board[y*width+x]?'#':'.')
               }
               fmt.println()
            }
            return true
         }
         for y in 0..<height-2{
            next: for x in 0..<width-2{
               for box in boxes[bi]{
                  for by in 0..<3{
                     for bx in 0..<3{
                        if box[by][bx]{
                           if board[(y+by)*width+x+bx]{
                              continue next
                           }
                        }
                     }
                  }
                  for by in 0..<3{
                     for bx in 0..<3{
                        if box[by][bx]{
                           board[(y+by)*width+x+bx]=true
                        }
                     }
                  }
                  if solve(board,width,height,boxes,quantities,attempts){
                     return true
                  }
                  for by in 0..<3{
                     for bx in 0..<3{
                        if box[by][bx]{
                           board[(y+by)*width+x+bx]=false
                        }
                     }
                  }
               }
            }
         }
         quantities[bi]+=1
         return false
      }
      if solve(board,width,height,&boxes,&quantities,&attempts){
         result+=1
      }
   }
   return result
}

solve_2::#force_no_inline proc(input:[]string)->(result:=0){
   for line in input{
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
      "0:",
      "###",
      "##.",
      "##.",
      "",
      "1:",
      "###",
      "##.",
      ".##",
      "",
      "2:",
      ".##",
      "###",
      "##.",
      "",
      "3:",
      "##.",
      "###",
      "##.",
      "",
      "4:",
      "###",
      "#..",
      "###",
      "",
      "5:",
      "###",
      ".#.",
      "###",
      "",
      "4x4: 0 0 0 0 2 0",
      "12x5: 1 0 1 0 2 2",
      "12x5: 1 0 1 0 3 2"
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
