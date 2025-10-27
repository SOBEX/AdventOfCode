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

directions:=[4][2]int{{+1,0},{0,+1},{-1,0},{0,-1}}

solve_1::proc(input:[]string)->(result:=0){
   height:=len(input)-2
   width:=0
   position:=[2]int{strings.index_byte(input[0],'.'),0}
   direction:=0
   steps:=0
   for c in input[len(input)-1]{
      if '0'<=c&&c<='9'{
         steps=steps*10+int(c-'0')
      }else{
         d:=directions[direction]
         for step in 0..<steps{
            next:=position+d
            if !(0<=next.y&&next.y<height&&0<=next.x&&next.x<len(input[next.y])&&input[next.y][next.x]!=' '){
               next=position-d
               for 0<=next.y&&next.y<height&&0<=next.x&&next.x<len(input[next.y])&&input[next.y][next.x]!=' '{
                  next-=d
               }
               next+=d
            }
            if input[next.y][next.x]=='.'{
               position=next
            }else{
               break
            }
         }
         steps=0
         if c=='R'{
            if direction==3{
               direction=0
            }else{
               direction+=1
            }
         }else{
            if direction==0{
               direction=3
            }else{
               direction-=1
            }
         }
      }
   }
   d:=directions[direction]
   for step in 0..<steps{
      next:=position+d
      if !(0<=next.y&&next.y<height&&0<=next.x&&next.x<len(input[next.y])&&input[next.y][next.x]!=' '){
         next=position-d
         for 0<=next.y&&next.y<height&&0<=next.x&&next.x<len(input[next.y])&&input[next.y][next.x]!=' '{
            next-=d
         }
         next+=d
      }
      if input[next.y][next.x]=='.'{
         position=next
      }else{
         break
      }
   }
   return 1000*(position.y+1)+4*(position.x+1)+direction
}

solve_2::proc(input:[]string)->(result:=0){
   height:=len(input)-2
   SIZE:=height<=16?4:50
   position:=[2]int{strings.index_byte(input[0],'.'),0}
   direction:=0
   steps:=0
   for c in input[len(input)-1]{
      if '0'<=c&&c<='9'{
         steps=steps*10+int(c-'0')
      }else{
         for step in 0..<steps{
            next:=position+directions[direction]
            next_direction:=direction
            if !(0<=next.y&&next.y<height&&0<=next.x&&next.x<len(input[next.y])&&input[next.y][next.x]!=' '){
               /*>v<^
                     6<66^6
                    41112225
                    v1^12^2v
                    41112225
                    4333\<3
                    >3^3>
                  3<\3332
                 14445552
                 v4^45^5v
                 14445552
                 1666\<6
                 >6^6>
                 16665
                  2^2
               */
               wrapped:=position%%SIZE
               switch position/SIZE{
               case [2]int{1,0}:
                  switch direction{
                  case 2:
                     next=[2]int{0,2*SIZE+SIZE-wrapped.y-1}
                     next_direction=0
                  case 3:
                     next=[2]int{0,3*SIZE+wrapped.x}
                     next_direction=0
                  }
               case [2]int{2,0}:
                  switch direction{
                  case 0:
                     next=[2]int{2*SIZE-1,2*SIZE+SIZE-wrapped.y-1}
                     next_direction=2
                  case 1:
                     next=[2]int{2*SIZE-1,SIZE+wrapped.x}
                     next_direction=2
                  case 3:
                     next=[2]int{wrapped.x,4*SIZE-1}
                     next_direction=3
                  }
               case [2]int{1,1}:
                  switch direction{
                  case 0:
                     next=[2]int{2*SIZE+wrapped.y,SIZE-1}
                     next_direction=3
                  case 2:
                     next=[2]int{wrapped.y,2*SIZE}
                     next_direction=1
                  }
               case [2]int{0,2}:
                  switch direction{
                  case 2:
                     next=[2]int{SIZE,SIZE-wrapped.y-1}
                     next_direction=0
                  case 3:
                     next=[2]int{SIZE,SIZE+wrapped.x}
                     next_direction=0
                  }
               case [2]int{1,2}:
                  switch direction{
                  case 0:
                     next=[2]int{3*SIZE-1,SIZE-wrapped.y-1}
                     next_direction=2
                  case 1:
                     next=[2]int{SIZE-1,3*SIZE+wrapped.x}
                     next_direction=2
                  }
               case [2]int{0,3}:
                  switch direction{
                  case 0:
                     next=[2]int{SIZE+wrapped.y,3*SIZE-1}
                     next_direction=3
                  case 1:
                     next=[2]int{2*SIZE+wrapped.x,0}
                     next_direction=1
                  case 2:
                     next=[2]int{SIZE+wrapped.y,0}
                     next_direction=1
                  }
               }
            }
            if input[next.y][next.x]=='.'{
               position=next
               direction=next_direction
            }else{
               break
            }
         }
         steps=0
         if c=='R'{
            if direction==3{
               direction=0
            }else{
               direction+=1
            }
         }else{
            if direction==0{
               direction=3
            }else{
               direction-=1
            }
         }
      }
   }
   d:=directions[direction]
   for step in 0..<steps{
      next:=position+d
      if !(0<=next.y&&next.y<height&&0<=next.x&&next.x<len(input[next.y])&&input[next.y][next.x]!=' '){
         fmt.println("wrong move")
      }
      if input[next.y][next.x]=='.'{
         position=next
      }else{
         break
      }
   }
   return 1000*(position.y+1)+4*(position.x+1)+direction
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
   do_example_2::false
   do_input_2  ::true

   example_1:=[]string{
      "        ...#",
      "        .#..",
      "        #...",
      "        ....",
      "...#.......#",
      "........#...",
      "..#....#....",
      "..........#.",
      "        ...#....",
      "        .....#..",
      "        .#......",
      "        ......#.",
      "",
      "10R5L5R10L4R5L5"
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
