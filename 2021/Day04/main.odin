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

solve_1::proc(input:[]string)->(result:=0){
   N:=len(input)/6
   boards:=make([][5][5]int,N)
   for i in 0..<N{
      for y in 0..<5{
         for x in 0..<5{
            first:=input[2+6*i+y][3*x]
            second:=input[2+6*i+y][3*x+1]
            boards[i][y][x]=int((first==' '?0:first-'0')*10+second-'0')
         }
      }
   }
   length:=len(input[0])
   exit: for i:=0;i<length;{
      value:=int(input[0][i]-'0')
      if i+1==length do i+=1
      else if second:=input[0][i+1];second!=','{
         value=10*value+int(second-'0')
         i+=3
      }else do i+=2
      next: for i in 0..<N{
         for y in 0..<5{
            for x in 0..<5{
               if boards[i][y][x]==value{
                  boards[i][y][x]=-1
                  ysum:=boards[i][y][0]+boards[i][y][1]+boards[i][y][2]+boards[i][y][3]+boards[i][y][4]
                  xsum:=boards[i][0][x]+boards[i][1][x]+boards[i][2][x]+boards[i][3][x]+boards[i][4][x]
                  if ysum==-5||xsum==-5{
                     for y in 0..<5{
                        for x in 0..<5{
                           if boards[i][y][x]>0{
                              result+=boards[i][y][x]
                           }
                        }
                     }
                     result*=value
                     break exit
                  }
                  continue next
               }
            }
         }
      }
   }
   delete(boards)
   return result
}

solve_2::proc(input:[]string)->(result:=0){
   N:=len(input)/6
   boards:=make([][5][5]int,N)
   for i in 0..<N{
      for y in 0..<5{
         for x in 0..<5{
            first:=input[2+6*i+y][3*x]
            second:=input[2+6*i+y][3*x+1]
            boards[i][y][x]=int((first==' '?0:first-'0')*10+second-'0')
         }
      }
   }
   length:=len(input[0])
   exit: for i:=0;i<length;{
      value:=int(input[0][i]-'0')
      if i+1==length do i+=1
      else if second:=input[0][i+1];second!=','{
         value=10*value+int(second-'0')
         i+=3
      }else do i+=2
      next: for i:=0;i<N;i+=1{
         for y in 0..<5{
            for x in 0..<5{
               if boards[i][y][x]==value{
                  boards[i][y][x]=-1
                  ysum:=boards[i][y][0]+boards[i][y][1]+boards[i][y][2]+boards[i][y][3]+boards[i][y][4]
                  xsum:=boards[i][0][x]+boards[i][1][x]+boards[i][2][x]+boards[i][3][x]+boards[i][4][x]
                  if ysum==-5||xsum==-5{
                     if N==1{
                        for y in 0..<5{
                           for x in 0..<5{
                              if boards[i][y][x]>0{
                                 result+=boards[i][y][x]
                              }
                           }
                        }
                        result*=value
                        break exit
                     }
                     N-=1
                     boards[i]=boards[N]
                     i-=1
                  }
                  continue next
               }
            }
         }
      }
   }
   delete(boards)
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
      "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1",
      "",
      "22 13 17 11  0",
      " 8  2 23  4 24",
      "21  9 14 16  7",
      " 6 10  3 18  5",
      " 1 12 20 15 19",
      "",
      " 3 15  0  2 22",
      " 9 18 13 17  5",
      "19  8  7 25 23",
      "20 11 10 24  4",
      "14 21 16 12  6",
      "",
      "14 21 17 24  4",
      "10 16 15  9 19",
      "18  8 23 26 20",
      "22 11 13  6  5",
      " 2  0 12  3  7"
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
