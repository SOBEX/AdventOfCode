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
import "core:sort"

compare_single::proc(l,r:int)->int{
   return l-r
}
compare_double::proc(l,r:[2]int)->int{
   if c:=compare_single(l[0],r[0]);c!=0 do return c
   return compare_single(l[1],r[1])
}

solve_1::proc(input:[]string,target:=2_000_000)->(result:=0){
   ranges:=make([dynamic][2]int,0,len(input))
   holes:=make([dynamic]int,0,len(input))
   rex,_:=regex.create("^Sensor at x=(-?\\d+), y=(-?\\d+): closest beacon is at x=(-?\\d+), y=(-?\\d+)$")
   capture:=regex.preallocate_capture()
   for line in input{
      _,ok:=regex.match(rex,line,&capture)
      if ok{
         sx:=strconv.parse_int(capture.groups[1]) or_continue
         sy:=strconv.parse_int(capture.groups[2]) or_continue
         bx:=strconv.parse_int(capture.groups[3]) or_continue
         by:=strconv.parse_int(capture.groups[4]) or_continue
         d:=abs(sx-bx)+abs(sy-by)-abs(sy-target)
         if d>=0{
            rs:=sx-d
            re:=sx+d
            append(&ranges,[2]int{rs,re})
         }
         if by==target{
            append(&holes,bx)
         }
      }
   }
   regex.destroy(capture)
   regex.destroy(rex)
   sort.quick_sort_proc(ranges[:],compare_double)
   sort.quick_sort_proc(holes[:],compare_single)
   prev:=ranges[0]
   for i:=1;i<len(ranges);i+=1{
      cur:=ranges[i]
      if cur[0]<=prev[1]{
         prev[1]=max(prev[1],cur[1])
      }else{
         result+=prev[1]-prev[0]+1
         if len(holes)>0{
            prev_hole:=holes[0]-1
            for hole in holes{
               if hole!=prev_hole&&prev[0]<=hole&&hole<=prev[1]{
                  result-=1
                  prev_hole=hole
               }
            }
         }
         prev=cur
      }
   }
   result+=prev[1]-prev[0]+1
   if len(holes)>0{
      prev_hole:=holes[0]-1
      for hole in holes{
         if hole!=prev_hole&&prev[0]<=hole&&hole<=prev[1]{
            result-=1
            prev_hole=hole
         }
      }
   }
   delete(holes)
   delete(ranges)
   return result
}

Sensor::struct{
   x,y:int,
   d:int
}
compare_sensor::proc(l,r:Sensor)->int{
   if c:=l.y-r.y;c!=0 do return c
   if c:=l.x-r.x;c!=0 do return c
   return r.d-l.d
}

solve_2::proc(input:[]string,target:=4_000_000)->(result:=0){
   sensors:=make([dynamic]Sensor,0,len(input))
   rex,_:=regex.create("^Sensor at x=(-?\\d+), y=(-?\\d+): closest beacon is at x=(-?\\d+), y=(-?\\d+)$")
   capture:=regex.preallocate_capture()
   for line in input{
      _,ok:=regex.match(rex,line,&capture)
      if ok{
         sx:=strconv.parse_int(capture.groups[1]) or_continue
         sy:=strconv.parse_int(capture.groups[2]) or_continue
         bx:=strconv.parse_int(capture.groups[3]) or_continue
         by:=strconv.parse_int(capture.groups[4]) or_continue
         d:=abs(sx-bx)+abs(sy-by)
         append(&sensors,Sensor{sx,sy,d})
      }
   }
   regex.destroy(capture)
   regex.destroy(rex)
   sort.quick_sort_proc(sensors[:],compare_sensor)
   success: for ty:=0;ty<=target;ty+=1{
      failure: for tx:=0;tx<=target;tx+=1{
         for s in sensors{
            if abs(s.x-tx)+abs(s.y-ty)<=s.d{
               tx=s.x+(s.d-abs(s.y-ty))
               continue failure
            }
         }
         result=tx*4_000_000+ty
         break success
      }
   }
   delete(sensors)
   return result
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
      "Sensor at x=2, y=18: closest beacon is at x=-2, y=15",
      "Sensor at x=9, y=16: closest beacon is at x=10, y=16",
      "Sensor at x=13, y=2: closest beacon is at x=15, y=3",
      "Sensor at x=12, y=14: closest beacon is at x=10, y=16",
      "Sensor at x=10, y=20: closest beacon is at x=10, y=16",
      "Sensor at x=14, y=17: closest beacon is at x=10, y=16",
      "Sensor at x=8, y=7: closest beacon is at x=2, y=10",
      "Sensor at x=2, y=0: closest beacon is at x=2, y=10",
      "Sensor at x=0, y=11: closest beacon is at x=2, y=10",
      "Sensor at x=20, y=14: closest beacon is at x=25, y=17",
      "Sensor at x=17, y=20: closest beacon is at x=21, y=22",
      "Sensor at x=16, y=7: closest beacon is at x=15, y=3",
      "Sensor at x=14, y=3: closest beacon is at x=15, y=3",
      "Sensor at x=20, y=1: closest beacon is at x=15, y=3"
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
            result=solve_1(example_1,10)
         }
         when do_input_1{
            result=solve_1(input)
         }
         when do_example_2{
            result=solve_2(example_2,20)
         }
         when do_input_2{
            result=solve_2(input)
         }
      }
   }

   time_0:=get_time()
   when do_example_1 do answer_1_example:=solve_1(example_1,10)
   time_1:=get_time()
   when do_input_1   do answer_1_input  :=solve_1(input)
   time_2:=get_time()
   when do_example_2 do answer_2_example:=solve_2(example_2,20)
   time_3:=get_time()
   when do_input_2   do answer_2_input  :=solve_2(input)
   time_4:=get_time()

   when do_example_1 do fmt.printfln("Example 1 took % 9.4fms: %v",get_duration_ms(time_0,time_1),answer_1_example)
   when do_input_1   do fmt.printfln("Input   1 took % 9.4fms: %v",get_duration_ms(time_1,time_2),answer_1_input)
   when do_example_2 do fmt.printfln("Example 2 took % 9.4fms: %v",get_duration_ms(time_2,time_3),answer_2_example)
   when do_input_2   do fmt.printfln("Input   2 took % 9.4fms: %v",get_duration_ms(time_3,time_4),answer_2_input)
}
