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
   cs:[dynamic][2]int
   defer delete(cs)
   for line in input{
      _y:=line
      _x:=strings.split_iterator(&_y,",") or_continue
      x:=strconv.parse_int(_x) or_continue
      y:=strconv.parse_int(_y) or_continue
      for c in cs{
         s:=(abs(x-c.x)+1)*(abs(y-c.y)+1)
         if s>result{
            result=s
         }
      }
      append(&cs,[2]int{x,y})
   }
   return result
}

less2::proc(l,r:[2]int)->bool{
   if l[0]!=r[0] do return l[0]<r[0]
   return l[1]<r[1]
}
order2::proc(l,r:[2]int)->slice.Ordering{
   if l.x<r.x do return .Less
   if l.x>r.x do return .Greater
   if l.y<r.y do return .Less
   if l.y>r.y do return .Greater
   return .Equal
}

compress_indices::proc(is:[][2]int)->[][2]int{
   slice.sort_by(is[:],less2)
   unique_is:=slice.unique(is[:])
   new_is:=make([][2]int,2*len(unique_is)+1)
   new_length:=0
   next:=min(int)
   for i in unique_is{
      i:=i[0]
      if next<i{
         new_is[new_length]={next,i-1}
         new_length+=1
      }
      new_is[new_length]={i,i}
      new_length+=1
      next=i+1
   }
   new_is[new_length]={next,max(int)}
   new_length+=1
   return new_is[:new_length]
}

solve_2::#force_no_inline proc(input:[]string)->(result:=0){
   l:=len(input)
   cs:=make([][2]int,l)
   defer delete(cs)
   _xs:=make([][2]int,l)
   defer delete(_xs)
   _ys:=make([][2]int,l)
   defer delete(_ys)
   for line,i in input{
      _y:=line
      _x:=strings.split_iterator(&_y,",") or_continue
      x:=strconv.parse_int(_x) or_continue
      y:=strconv.parse_int(_y) or_continue
      cs[i]={x,y}
      _xs[i]={x,x}
      _ys[i]={y,y}
   }
   xs:=compress_indices(_xs)
   defer delete(xs)
   ys:=compress_indices(_ys)
   defer delete(ys)
   is:=make([][2]int,l)
   defer delete(is)
   for c,i in cs{
      is[i].x=slice.binary_search_by(xs,[2]int{c.x,c.x},order2) or_else panic("x not found")
      is[i].y=slice.binary_search_by(ys,[2]int{c.y,c.y},order2) or_else panic("y not found")
   }
   width:=len(xs)
   height:=len(ys)
   board:=make([]bool,width*height)
   defer delete(board)
   prev:=is[len(is)-1]
   for i in is{
      if prev.x==i.x{
         for dir:=prev.y<i.y?1:-1;prev.y!=i.y;prev.y+=dir{
            board[prev.y*width+prev.x]=true
         }
      }else{
         for dir:=prev.x<i.x?1:-1;prev.x!=i.x;prev.x+=dir{
            board[prev.y*width+prev.x]=true
         }
      }
   }
   queue:[dynamic][2]int
   defer delete(queue)
   append(&queue,[2]int{0,0})
   for len(queue)>0{
      i:=pop(&queue)
      board[i.y*width+i.x]=true
      if 0<=i.x-1&&!board[i.y*width+(i.x-1)] do append(&queue,[2]int{i.x-1,i.y})
      if i.x+1<width&&!board[i.y*width+(i.x+1)] do append(&queue,[2]int{i.x+1,i.y})
      if 0<=i.y-1&&!board[(i.y-1)*width+i.x] do append(&queue,[2]int{i.x,i.y-1})
      if i.y+1<height&&!board[(i.y+1)*width+i.x] do append(&queue,[2]int{i.x,i.y+1})
   }
   prev=is[len(is)-1]
   for i in is{
      if prev.x==i.x{
         for dir:=prev.y<i.y?1:-1;prev.y!=i.y;prev.y+=dir{
            board[prev.y*width+prev.x]=false
         }
      }else{
         for dir:=prev.x<i.x?1:-1;prev.x!=i.x;prev.x+=dir{
            board[prev.y*width+prev.x]=false
         }
      }
   }
   for r,ri in is{
      skip: for l,li in is[:ri]{
         mins:=[2]int{min(l.x,r.x),min(l.y,r.y)}
         maxs:=[2]int{max(l.x,r.x),max(l.y,r.y)}
         top:=board[mins.y*width+mins.x:mins.y*width+maxs.x+1]
         if slice.all_of(top,false){
            if mins.y+1<=maxs.y{
               for y in mins.y+1..=maxs.y{
                  if !slice.equal(top,board[y*width+mins.x:y*width+maxs.x+1]){
                     continue skip
                  }
               }
            }
            l:=cs[li]
            r:=cs[ri]
            mins:=[2]int{min(l.x,r.x),min(l.y,r.y)}
            maxs:=[2]int{max(l.x,r.x),max(l.y,r.y)}
            score:=(maxs.x-mins.x+1)*(maxs.y-mins.y+1)
            if score>result{
               result=score
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
      "7,1",
      "11,1",
      "11,7",
      "9,7",
      "9,5",
      "2,5",
      "2,3",
      "7,3"
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
