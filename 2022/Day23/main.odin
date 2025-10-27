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

Direction::enum{NW,N,NE,W,E,SW,S,SE}
directions:=[Direction][2]int{
   .NW={-1,-1},
   .N={0,-1},
   .NE={1,-1},
   .W={-1,0},
   .E={1,0},
   .SW={-1,1},
   .S={0,1},
   .SE={1,1}
}
tries:=[4][3]Direction{
   {.NW,.N,.NE},
   {.SW,.S,.SE},
   {.NW,.W,.SW},
   {.NE,.E,.SE},
}

solve_1::proc(input:[]string)->(result:=0){
   elves:=make(map[[2]int]struct{})
   for y in 0..<len(input){
      for x in 0..<len(input[y]){
         if input[y][x]=='#'{
            elves[[2]int{x,y}]={}
         }
      }
   }
   for turn in 0..<10{
      moves:map[[2]int]bool
      for elf in elves{
         is_alone:=true
         for direction in directions{
            if elf+direction in elves{
               is_alone=false
               break
            }
         }
         if is_alone{
            continue
         }
         for _try in 0..<4{
            try:=tries[(_try+turn)%%4]
            left:=elf+directions[try[0]]
            middle:=elf+directions[try[1]]
            right:=elf+directions[try[2]]
            if left not_in elves&&middle not_in elves&&right not_in elves{
               moves[middle]=middle not_in moves
               break
            }
         }
      }
      new_elves:=make(map[[2]int]struct{},len(elves))
      for elf in elves{
         move:=elf
         is_alone:=true
         for direction in directions{
            if elf+direction in elves{
               is_alone=false
               break
            }
         }
         if !is_alone{
            for _try in 0..<4{
               try:=tries[(_try+turn)%%4]
               left:=elf+directions[try[0]]
               middle:=elf+directions[try[1]]
               right:=elf+directions[try[2]]
               if left not_in elves&&middle not_in elves&&right not_in elves{
                  move=middle
                  break
               }
            }
         }
         new_elves[moves[move]?move:elf]={}
      }
      delete(moves)
      old_elves:=elves
      elves=new_elves
      delete(old_elves)
   }
   min:=[2]int{max(int),max(int)}
   max:=[2]int{-max(int),-max(int)}
   for elf in elves{
      if elf.x<min.x do min.x=elf.x
      if elf.x>max.x do max.x=elf.x
      if elf.y<min.y do min.y=elf.y
      if elf.y>max.y do max.y=elf.y
   }
   result=(max.y-min.y+1)*(max.x-min.x+1)-len(elves)
   delete(elves)
   return result
}

solve_2::proc(input:[]string)->(result:=0){
   elves:=make(map[[2]int]struct{})
   for y in 0..<len(input){
      for x in 0..<len(input[y]){
         if input[y][x]=='#'{
            elves[[2]int{x,y}]={}
         }
      }
   }
   for turn:=0;true;turn+=1{
      moves:map[[2]int]bool
      for elf in elves{
         is_alone:=true
         for direction in directions{
            if elf+direction in elves{
               is_alone=false
               break
            }
         }
         if is_alone{
            continue
         }
         for _try in 0..<4{
            try:=tries[(_try+turn)%%4]
            left:=elf+directions[try[0]]
            middle:=elf+directions[try[1]]
            right:=elf+directions[try[2]]
            if left not_in elves&&middle not_in elves&&right not_in elves{
               moves[middle]=middle not_in moves
               break
            }
         }
      }
      if len(moves)==0{
         result=turn+1
         break
      }
      new_elves:=make(map[[2]int]struct{},len(elves))
      for elf in elves{
         move:=elf
         is_alone:=true
         for direction in directions{
            if elf+direction in elves{
               is_alone=false
               break
            }
         }
         if !is_alone{
            for _try in 0..<4{
               try:=tries[(_try+turn)%%4]
               left:=elf+directions[try[0]]
               middle:=elf+directions[try[1]]
               right:=elf+directions[try[2]]
               if left not_in elves&&middle not_in elves&&right not_in elves{
                  move=middle
                  break
               }
            }
         }
         new_elves[moves[move]?move:elf]={}
      }
      delete(moves)
      old_elves:=elves
      elves=new_elves
      delete(old_elves)
   }
   delete(elves)
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
      "....#..",
      "..###.#",
      "#...#.#",
      ".#...##",
      "#.###..",
      "##.#.##",
      ".#..#.."
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
