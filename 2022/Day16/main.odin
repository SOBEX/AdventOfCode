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

import "core:text/regex"
import "core:strconv"

Valve::struct{
   id:uint,
   flow_rate:int,
   tunnels:[]string
}
State_1::struct{
   turns_left:int,
   current:string,
   opened:uint
}
recursive_1::proc(cache:^map[State_1]int,valves:map[string]Valve,state:State_1)->(result:=0){
   using state
   if turns_left==0 do return 0
   if state in cache do return cache[state]
   valve:=valves[current]
   using valve
   if id>0&&(id&opened)==0{
      new_result:=flow_rate*(turns_left-1)+recursive_1(cache,valves,State_1{turns_left-1,current,opened|id})
      if new_result>result do result=new_result
   }
   for tunnel in tunnels{
      new_result:=recursive_1(cache,valves,State_1{turns_left-1,tunnel,opened})
      if new_result>result do result=new_result
   }
   cache[state]=result
   return result
}

solve_1::proc(input:[]string)->(result:=0){
   valves:map[string]Valve
   rex,_:=regex.create("^Valve ([^ ]+) has flow rate=(\\d+); tunnels? leads? to valves? (.*)$")
   capture:=regex.preallocate_capture()
   id:uint=0x1
   for line in input{
      _,ok:=regex.match(rex,line,&capture)
      if ok{
         name:=capture.groups[1]
         flow_rate:=strconv.parse_int(capture.groups[2]) or_continue
         tunnels:=strings.split(capture.groups[3],", ")
         if flow_rate>0{
            valves[name]=Valve{id,flow_rate,tunnels}
            id<<=1
         }else{
            valves[name]=Valve{0,flow_rate,tunnels}
         }
      }
   }
   regex.destroy(capture)
   regex.destroy(rex)
   cache:map[State_1]int
   result=recursive_1(&cache,valves,State_1{30,"AA",0})
   delete(cache)
   for name,valve in valves{
      delete(valve.tunnels)
   }
   delete(valves)
   return result
}

make_distances::proc(valves:[dynamic]Valve,translations:map[string]int)->[dynamic]int{
   N:=len(valves)
   distances:=make([dynamic]int,N*N)
   changed:=true
   for changed{
      changed=false
      for from_valve,from in valves{
         for to_valve,to in valves{
            if from==to do continue
            distance:=0
            for tunnel in from_valve.tunnels{
               if translations[tunnel]==to{
                  distance=1
                  break
               }
            }
            for middle in 0..<N{
               first:=distances[from+middle*N]
               second:=distances[middle+to*N]
               if first!=0&&second!=0&&(distance==0||first+second<distance){
                  distance=first+second
               }
            }
            if distances[from+to*N]==0||distance<distances[from+to*N]{
               distances[from+to*N]=distance
               changed=true
            }
         }
      }
   }
   return distances
}
State_2::struct{
   turns_left_1:int,
   current_1:int,
   turns_left_2:int,
   current_2:int,
   opened:uint,
}
recursive_2::proc(cache:^map[State_2]int,valves:[dynamic]Valve,distances:[dynamic]int,state:State_2)->(result:=0){
   if state in cache do return cache[state]
   using state
   flipped_state:=State_2{turns_left_2,current_2,turns_left_1,current_1,opened}
   if flipped_state in cache do return cache[flipped_state]
   N:=len(valves)
   for valve,to in valves{
      using valve
      if id>0&&(id&opened)==0{
         distance_1:=distances[current_1+to*N]
         if distance_1!=0&&distance_1<turns_left_1{
            new_result:=flow_rate*(turns_left_1-distance_1-1)+recursive_2(cache,valves,distances,State_2{turns_left_1-distance_1-1,to,turns_left_2,current_2,opened|valve.id})
            if new_result>result do result=new_result
         }
         if turns_left_2!=turns_left_1||current_2!=current_1{
            distance_2:=distances[current_2+to*N]
            if distance_2!=0&&distance_2<turns_left_2{
               new_result:=flow_rate*(turns_left_2-distance_2-1)+recursive_2(cache,valves,distances,State_2{turns_left_1,current_1,turns_left_2-distance_2-1,to,opened|valve.id})
               if new_result>result do result=new_result
            }
         }
      }
   }
   cache[state]=result
   return result
}

solve_2::proc(input:[]string)->(result:=0){
   N:=len(input)
   valves:=make([dynamic]Valve,0,N)
   translations:map[string]int
   rex,_:=regex.create("^Valve ([^ ]+) has flow rate=(\\d+); tunnels? leads? to valves? (.*)$")
   capture:=regex.preallocate_capture()
   id:uint=0x1
   for line in input{
      _,ok:=regex.match(rex,line,&capture)
      if ok{
         name:=capture.groups[1]
         flow_rate:=strconv.parse_int(capture.groups[2]) or_continue
         tunnels:=strings.split(capture.groups[3],", ")
         translations[name]=len(valves)
         if flow_rate>0{
            append(&valves,Valve{id,flow_rate,tunnels})
            id<<=1
         }else{
            append(&valves,Valve{0,flow_rate,tunnels})
         }
      }
   }
   regex.destroy(capture)
   regex.destroy(rex)
   distances:=make_distances(valves,translations)
   cache:map[State_2]int
   result=recursive_2(&cache,valves,distances,State_2{26,translations["AA"],26,translations["AA"],0})
   delete(cache)
   delete(distances)
   delete(translations)
   for valve in valves{
      delete(valve.tunnels)
   }
   delete(valves)
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
      "Valve AA has flow rate=0; tunnels lead to valves DD, II, BB",
      "Valve BB has flow rate=13; tunnels lead to valves CC, AA",
      "Valve CC has flow rate=2; tunnels lead to valves DD, BB",
      "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE",
      "Valve EE has flow rate=3; tunnels lead to valves FF, DD",
      "Valve FF has flow rate=0; tunnels lead to valves EE, GG",
      "Valve GG has flow rate=0; tunnels lead to valves FF, HH",
      "Valve HH has flow rate=22; tunnel leads to valve GG",
      "Valve II has flow rate=0; tunnels lead to valves AA, JJ",
      "Valve JJ has flow rate=21; tunnel leads to valve II"
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
