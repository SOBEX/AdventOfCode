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

MAX_HEIGHT::13*(2030/5)
stones:=[?][][2]int{
   {
      {0,0},{1,0},{2,0},{3,0}
   },{
      {1,0},{0,1},{1,1},{2,1},{1,2}
   },{
      {0,0},{1,0},{2,0},{2,1},{2,2}
   },{
      {0,0},{0,1},{0,2},{0,3}
   },{
      {0,0},{1,0},{0,1},{1,1}
   }
}
stone_is_valid::proc(stack:[MAX_HEIGHT][7]bool,stone_index:int,new_position:[2]int)->bool{
   stone:=stones[stone_index%%5]
   for stone_position in stone{
      new_stone_position:=new_position+stone_position
      if !(0<=new_stone_position.y&&new_stone_position.y<MAX_HEIGHT&&0<=new_stone_position.x&&new_stone_position.x<7&&!stack[new_stone_position.y][new_stone_position.x]){
         return false
      }
   }
   return true
}
stone_solidify::proc(stack:^[MAX_HEIGHT][7]bool,stone_index:int,position:[2]int)->(new_bottom:int){
   stone:=stones[stone_index%%5]
   for stone_position in stone{
      stone_position:=position+stone_position
      stack[stone_position.y][stone_position.x]=true
      new_bottom=stone_position.y
   }
   return new_bottom
}

solve_1::proc(input:[]string)->(result:=0){
   LEFT::[2]int{-1,0}
   RIGHT::[2]int{1,0}
   DOWN::[2]int{0,-1}
   for line in input{
      line_index:=0
      stack:[MAX_HEIGHT][7]bool
      bottom:=-1
      for stone_index in 0..<2022{
         position:=[2]int{2,bottom+4}
         for{
            lr:=line[line_index]
            line_index+=1
            if line_index==len(line) do line_index=0
            new_position:=position+(lr=='<'?LEFT:RIGHT)
            if stone_is_valid(stack,stone_index,new_position){
               position=new_position
            }
            new_position=position+DOWN
            if !stone_is_valid(stack,stone_index,new_position){
               bottom=max(bottom,stone_solidify(&stack,stone_index,position))
               break
            }
            position=new_position
         }
      }
      result+=bottom+1
   }
   return result
}

solve_2::proc(input:[]string)->(result:=0){
   LEFT::[2]int{-1,0}
   RIGHT::[2]int{1,0}
   DOWN::[2]int{0,-1}
   for line in input{
      line_index:=0
      stack:[MAX_HEIGHT][7]bool
      cache:map[[2]int][2]int
      bottom:=-1
      for stone_index:=0;true;stone_index+=1{
         position:=[2]int{2,bottom+4}
         key:=[2]int{stone_index%%5,line_index}
         if key in cache{
            value:=cache[key]
            if (1000000000000-stone_index)%%(stone_index-value[0])==0{
               bottom+=(1000000000000-stone_index)/(stone_index-value[0])*(bottom-value[1])
               break
            }
         }
         cache[key]=[2]int{stone_index,bottom}
         for{
            lr:=line[line_index]
            line_index+=1
            if line_index==len(line) do line_index=0
            new_position:=position+(lr=='<'?LEFT:RIGHT)
            if stone_is_valid(stack,stone_index,new_position){
               position=new_position
            }
            new_position=position+DOWN
            if !stone_is_valid(stack,stone_index,new_position){
               bottom=max(bottom,stone_solidify(&stack,stone_index,position))
               break
            }
            position=new_position
         }
      }
      result+=bottom+1
      delete(cache)
   }
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
      ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
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
