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
   return time.duration_milliseconds(time.diff(start,end))
}
get_duration_ms::proc(start,end:Time)->f64{
   return time.duration_microseconds(time.diff(start,end))
}
get_duration_s::proc(start,end:Time)->f64{
   return time.duration_seconds(time.diff(start,end))
}

Line::string
Input::[]Line
Position::[2]int
Cell::int
Row::[]Cell
Board::[]Row

solve_1::proc(input:Input)->int{
   height:=len(input)
   width:=len(input[0])
   sum:=(height+width)*2-4
   for y:=1;y<height-1;y+=1{
      failure: for x:=1;x<width-1;x+=1{
         cur:=input[y][x]
         success: for i:=x-1;i>=0;i-=1{
            if input[y][i]>=cur{
               for i=x+1;i<width;i+=1{
                  if input[y][i]>=cur{
                     for i:=y-1;i>=0;i-=1{
                        if input[i][x]>=cur{
                           for i:=y+1;i<height;i+=1{
                              if input[i][x]>=cur{
                                 continue failure
                              }
                           }
                           break success
                        }
                     }
                     break success
                  }
               }
               break success
            }
         }
         sum+=1
      }
   }
   return sum
}

solve_2::proc(input:Input)->int{
   height:=len(input)
   width:=len(input[0])
   best:=0
   for y:=1;y<height-1;y+=1{
      for x:=1;x<width-1;x+=1{
         cur:=input[y][x]
         left:=1
         for i:=x-1;i>=1;i-=1{
            if input[y][i]>=cur do break
            left+=1
         }
         right:=1
         for i:=x+1;i<width-1;i+=1{
            if input[y][i]>=cur do break
            right+=1
         }
         up:=1
         for i:=y-1;i>=1;i-=1{
            if input[i][x]>=cur do break
            up+=1
         }
         down:=1
         for i:=y+1;i<height-1;i+=1{
            if input[i][x]>=cur do break
            down+=1
         }
         score:=left*right*up*down
         if score>best{
            best=score
         }
      }
   }
   return best
}

main::proc(){
   when ODIN_DEBUG{
      track:mem.Tracking_Allocator
      mem.tracking_allocator_init(&track,context.allocator)
      context.allocator=mem.tracking_allocator(&track)
      defer{
         if len(track.allocation_map)>0{
            fmt.eprintfln("=== %v allocations not freed: ===",len(track.allocation_map))
            for _,entry in track.allocation_map{
               fmt.eprintfln("- %v bytes @ %v",entry.size,entry.location)
            }
         }else{
            fmt.println("=== all allocations freed ===")
         }
         mem.tracking_allocator_destroy(&track)
      }
   }

   do_warming  :=0
   do_example_1:=true
   do_input_1  :=true
   do_example_2:=true
   do_input_2  :=true

   example_1:=Input{
      "30373",
      "25512",
      "65332",
      "33549",
      "35390"
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

   result:int=0
   for warming in 0..<do_warming{
      if do_example_1{
         result=solve_1(example_1)
      }
      if do_input_1{
         result=solve_1(input)
      }
      if do_example_2{
         result=solve_2(example_2)
      }
      if do_input_2{
         result=solve_2(input)
      }
   }
   result=0

   answer_1_example:int=-1
   answer_1_input:int=-1
   answer_2_example:int=-1
   answer_2_input:int=-1

   time_0:=get_time()
   if do_example_1{
      answer_1_example=solve_1(example_1)
   }
   time_1:=get_time()
   if do_input_1{
      answer_1_input=solve_1(input)
   }
   time_2:=get_time()
   if do_example_2{
      answer_2_example=solve_2(example_2)
   }
   time_3:=get_time()
   if do_input_2{
      answer_2_input=solve_2(input)
   }
   time_4:=get_time()

   fmt.printfln("Example 1 took % 6.1fms: %v",get_duration_ms(time_0,time_1),answer_1_example)
   fmt.printfln("Input   1 took % 6.1fms: %v",get_duration_ms(time_1,time_2),answer_1_input)
   fmt.printfln("Example 2 took % 6.1fms: %v",get_duration_ms(time_2,time_3),answer_2_example)
   fmt.printfln("Input   2 took % 6.1fms: %v",get_duration_ms(time_3,time_4),answer_2_input)
}
