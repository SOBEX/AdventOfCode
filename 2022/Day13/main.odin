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

import "core:encoding/json"

compare::proc(l,r:json.Value)->int{
   #partial switch _ll in l{
      case i64,f64:
         ll:=_ll.(i64) or_else i64(_ll.(f64))
         #partial switch _rr in r{
            case i64,f64:
               rr:=_rr.(i64) or_else i64(_rr.(f64))
               if ll<rr do return -1
               if ll==rr do return 0
               if ll>rr do return 1
            case json.Array:
               rr:=_rr
               if len(rr)==0 do return 1
               if c:=compare(l,rr[0]);c!=0 do return c
               if len(rr)==1 do return 0
               if len(rr)>1 do return -1
         }
      case json.Array:
         ll:=_ll
         #partial switch _rr in r{
            case i64,f64:
               rr:=_rr.(i64) or_else i64(_rr.(f64))
               if len(ll)==0 do return -1
               if c:=compare(ll[0],r);c!=0 do return c
               if len(ll)==1 do return 0
               if len(ll)>1 do return 1
            case json.Array:
               rr:=_rr
               for i in 0..<min(len(ll),len(rr)){
                  if c:=compare(ll[i],rr[i]);c!=0 do return c
               }
               if len(ll)<len(rr) do return -1
               if len(ll)==len(rr) do return 0
               if len(ll)>len(rr) do return 1
         }
   }
   return 0
}

solve_1::proc(input:[]string)->(result:=0){
   for i:=0;i+1<len(input);i+=3{
      l:=json.parse_string(input[i]) or_continue
      r:=json.parse_string(input[i+1]) or_continue
      if compare(l,r)!=1{
         result+=i/3+1
      }
      json.destroy_value(l)
      json.destroy_value(r)
   }
   return result
}

solve_2::proc(input:[]string)->(result:=0){
   lt2:=1
   lt6:=2
   v2,_:=json.parse_string("[[2]]")
   v6,_:=json.parse_string("[[6]]")
   for i:=0;i+1<len(input);i+=3{
      l:=json.parse_string(input[i]) or_continue
      if compare(l,v2)!=1 do lt2+=1
      if compare(l,v6)!=1 do lt6+=1
      json.destroy_value(l)
      r:=json.parse_string(input[i+1]) or_continue
      if compare(r,v2)!=1 do lt2+=1
      if compare(r,v6)!=1 do lt6+=1
      json.destroy_value(r)
   }
   json.destroy_value(v6)
   json.destroy_value(v2)
   return lt2*lt6
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

   do_warming  ::0
   do_example_1::true
   do_input_1  ::true
   do_example_2::true
   do_input_2  ::true

   example_1:=[]string{
      "[1,1,3,1,1]",
      "[1,1,5,1,1]",
      "",
      "[[1],[2,3,4]]",
      "[[1],4]",
      "",
      "[9]",
      "[[8,7,6]]",
      "",
      "[[4,4],4,4]",
      "[[4,4],4,4,4]",
      "",
      "[7,7,7,7]",
      "[7,7,7]",
      "",
      "[]",
      "[3]",
      "",
      "[[[]]]",
      "[[]]",
      "",
      "[1,[2,[3,[4,[5,6,7]]]],8,9]",
      "[1,[2,[3,[4,[5,6,0]]]],8,9]"
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
