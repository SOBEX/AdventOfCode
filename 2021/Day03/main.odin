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
   N:=len(input[0])
   counts:=make([]int,N)
   for line in input{
      for i in 0..<N{
         if line[i]=='1'{
            counts[i]+=1
         }
      }
   }
   gamma:=0
   epsilon:=0
   limit:=len(input)/2
   for i in 0..<N{
      value:=1<<uint(N-i-1)
      if counts[i]>limit{
         gamma+=value
      }else{
         epsilon+=value
      }
   }
   delete(counts)
   return gamma*epsilon
}

import "core:strconv"

solve_2::proc(input:[]string)->(result:=0){
   N:=len(input[0])
   numbers:=make([]int,len(input))
   for line,index in input{
      numbers[index]=strconv.parse_int(line,2) or_continue
   }
   length:=len(numbers)
   for i in 0..<N{
      mask:=1<<uint(N-i-1)
      count:=0
      for j in 0..<length{
         if (numbers[j]&mask)!=0{
            count+=1
         }
      }
      keep_1:=count>(length-1)/2
      for j:=0;j<length;{
         if ((numbers[j]&mask)!=0)==keep_1 do j+=1
         else{
            length-=1
            numbers[j]=numbers[length]
         }
      }
      if length<=1 do break
   }
   oxygen:=numbers[0]
   for line,index in input{
      numbers[index]=strconv.parse_int(line,2) or_continue
   }
   length=len(numbers)
   for i in 0..<N{
      mask:=1<<uint(N-i-1)
      count:=0
      for j in 0..<length{
         if (numbers[j]&mask)!=0{
            count+=1
         }
      }
      keep_1:=count<=(length-1)/2
      for j:=0;j<length;{
         if ((numbers[j]&mask)!=0)==keep_1 do j+=1
         else{
            length-=1
            numbers[j]=numbers[length]
         }
      }
      if length<=1 do break
   }
   co2:=numbers[0]
   delete(numbers)
   return oxygen*co2
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
      "00100",
      "11110",
      "10110",
      "10111",
      "10101",
      "01111",
      "00111",
      "11100",
      "10000",
      "11001",
      "00010",
      "01010"
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
