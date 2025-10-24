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

ORE::0
CLAY::1
OBSIDIAN::2
GEODE::3
State::struct{
   resources:[4]int,
   robots:[4]int,
   missed:[4]bool,
   turns_left:int
}
NO_MISSED::[4]bool{0..<4=false}
quality::proc(costs:[4][4]int,turns:int)->(result:=0){
   limit:=(turns-1)*4+1
   states:=make([]State,limit)
   states[0]=State{robots=[4]int{0=1},turns_left=turns}
   index:=0
   cache:=make([]int,turns)
   for index>=0{
      state:=states[index]
      index-=1
      using state
      if turns_left==1{
         new_result:=resources[GEODE]+robots[GEODE]
         if new_result>result{
            result=new_result
         }
         continue
      }
      if resources[GEODE]+2<cache[turns_left-1]{
         continue
      }else if resources[GEODE]>cache[turns_left-1]{
         cache[turns_left-1]=resources[GEODE]
      }
      can:=[4]bool{
         !missed[ORE]&&resources[ORE]>=costs[ORE][ORE],
         !missed[CLAY]&&resources[ORE]>=costs[CLAY][ORE],
         !missed[OBSIDIAN]&&resources[ORE]>=costs[OBSIDIAN][ORE]&&resources[CLAY]>=costs[OBSIDIAN][CLAY],
         !missed[GEODE]&&resources[ORE]>=costs[GEODE][ORE]&&resources[OBSIDIAN]>=costs[GEODE][OBSIDIAN],
      }
      new_missed:=[4]bool{
         missed[ORE]||can[ORE],
         missed[CLAY]||can[CLAY],
         missed[OBSIDIAN]||can[OBSIDIAN],
         missed[GEODE]||can[GEODE],
      }
      new_resources:=resources+robots
      index+=1
      states[index]=State{new_resources,robots,new_missed,turns_left-1}
      for resource in 0..<4{
         if can[resource]{
            new_robots:=robots
            new_robots[resource]+=1
            index+=1
            states[index]=State{new_resources-costs[resource],new_robots,NO_MISSED,turns_left-1}
         }
      }
   }
   delete(cache)
   delete(states)
   return result
}

solve_1::proc(input:[]string)->(result:=0){
   rex,_:=regex.create("^Blueprint (\\d+): Each ore robot costs (\\d+) ore. Each clay robot costs (\\d+) ore. Each obsidian robot costs (\\d+) ore and (\\d+) clay. Each geode robot costs (\\d+) ore and (\\d+) obsidian.$")
   capture:=regex.preallocate_capture()
   for line in input{
      _,ok:=regex.match(rex,line,&capture)
      if ok{
         id            :=strconv.parse_int(capture.groups[1]) or_continue
         ore_ore       :=strconv.parse_int(capture.groups[2]) or_continue
         clay_ore      :=strconv.parse_int(capture.groups[3]) or_continue
         obsidian_ore  :=strconv.parse_int(capture.groups[4]) or_continue
         obsidian_clay :=strconv.parse_int(capture.groups[5]) or_continue
         geode_ore     :=strconv.parse_int(capture.groups[6]) or_continue
         geode_obsidian:=strconv.parse_int(capture.groups[7]) or_continue
         costs:=[4][4]int{
            {ore_ore,0,0,0},
            {clay_ore,0,0,0},
            {obsidian_ore,obsidian_clay,0,0},
            {geode_ore,0,geode_obsidian,0}
         }
         result+=id*quality(costs,24)
      }
   }
   regex.destroy(capture)
   regex.destroy(rex)
   return result
}

solve_2::proc(input:[]string)->(result:=1){
   rex,_:=regex.create("^Blueprint (\\d+): Each ore robot costs (\\d+) ore. Each clay robot costs (\\d+) ore. Each obsidian robot costs (\\d+) ore and (\\d+) clay. Each geode robot costs (\\d+) ore and (\\d+) obsidian.$")
   capture:=regex.preallocate_capture()
   for line in input[:min(3,len(input))]{
      _,ok:=regex.match(rex,line,&capture)
      if ok{
         id            :=strconv.parse_int(capture.groups[1]) or_continue
         ore_ore       :=strconv.parse_int(capture.groups[2]) or_continue
         clay_ore      :=strconv.parse_int(capture.groups[3]) or_continue
         obsidian_ore  :=strconv.parse_int(capture.groups[4]) or_continue
         obsidian_clay :=strconv.parse_int(capture.groups[5]) or_continue
         geode_ore     :=strconv.parse_int(capture.groups[6]) or_continue
         geode_obsidian:=strconv.parse_int(capture.groups[7]) or_continue
         costs:=[4][4]int{
            {ore_ore,0,0,0},
            {clay_ore,0,0,0},
            {obsidian_ore,obsidian_clay,0,0},
            {geode_ore,0,geode_obsidian,0}
         }
         old_result:=result
         result*=quality(costs,32)
         fmt.println(result/old_result,line)
      }
   }
   regex.destroy(capture)
   regex.destroy(rex)
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
      "Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.",
      "Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian."
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
