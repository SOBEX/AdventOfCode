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

import pq "core:container/priority_queue"
import sa "core:container/small_array"
State::struct{
   steps:int,
   position:[2]int
}
state_less::proc(l,r:State)->bool{
   return l.steps<r.steps
}
state_swap::proc(q:[]State,l,r:int){
   q[l],q[r]=q[r],q[l]
}

solve_1::proc(input:[]string)->(result:=0){
   height:=len(input)
   width:=len(input[0])
   start,end:[2]int
   for line,y in input{
      if x:=strings.index_byte(line,'S');x!=-1{
         start={x,y}
      }
      if x:=strings.index_byte(line,'E');x!=-1{
         end={x,y}
      }
   }
   visited:=make([dynamic]bool,height*width)
   defer delete(visited)
   queue:pq.Priority_Queue(State)
   pq.init(&queue,state_less,state_swap)
   defer pq.destroy(&queue)
   if start[0]>0        do pq.push(&queue,State{1,{start[0]-1,start[1]  }})
   if start[0]<width-1  do pq.push(&queue,State{1,{start[0]+1,start[1]  }})
   if start[1]>0        do pq.push(&queue,State{1,{start[0]  ,start[1]-1}})
   if start[1]<height-1 do pq.push(&queue,State{1,{start[0]  ,start[1]+1}})
   for pq.len(queue)>0{
      state:=pq.pop(&queue)
      using state
      x,y:=position[0],position[1]
      if visited[y*width+x] do continue
      visited[y*width+x]=true
      nexts:sa.Small_Array(4,[2]int)
      if x>0        do sa.push(&nexts,[2]int{x-1,y  })
      if x<width-1  do sa.push(&nexts,[2]int{x+1,y  })
      if y>0        do sa.push(&nexts,[2]int{x  ,y-1})
      if y<height-1 do sa.push(&nexts,[2]int{x  ,y+1})
      cur:=input[y][x]
      for i:=0;i<sa.len(nexts);i+=1{
         next:=sa.get(nexts,i)
         n:=input[next[1]][next[0]]
         if cur=='z'&&n=='E' do return steps+1
         if n<=cur+1 do pq.push(&queue,State{steps+1,next})
      }
   }
   return -1
}

solve_2::proc(input:[]string)->(result:=0){
   height:=len(input)
   width:=len(input[0])
   end:[2]int
   for line,y in input{
      if x:=strings.index_byte(line,'E');x!=-1{
         end={x,y}
         break
      }
   }
   visited:=make([dynamic]bool,height*width)
   defer delete(visited)
   queue:pq.Priority_Queue(State)
   pq.init(&queue,state_less,state_swap)
   defer pq.destroy(&queue)
   for line,y in input do for char,x in line do if char=='a'do pq.push(&queue,State{0,{x,y}})
   for pq.len(queue)>0{
      state:=pq.pop(&queue)
      using state
      x,y:=position[0],position[1]
      if visited[y*width+x] do continue
      visited[y*width+x]=true
      nexts:sa.Small_Array(4,[2]int)
      if x>0        do sa.push(&nexts,[2]int{x-1,y  })
      if x<width-1  do sa.push(&nexts,[2]int{x+1,y  })
      if y>0        do sa.push(&nexts,[2]int{x  ,y-1})
      if y<height-1 do sa.push(&nexts,[2]int{x  ,y+1})
      cur:=input[y][x]
      for i:=0;i<sa.len(nexts);i+=1{
         next:=sa.get(nexts,i)
         n:=input[next[1]][next[0]]
         if cur=='z'&&n=='E' do return steps+1
         if n<=cur+1 do pq.push(&queue,State{steps+1,next})
      }
   }
   return -1
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
      "Sabqponm",
      "abcryxxl",
      "accszExk",
      "acctuvwj",
      "abdefghi"
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
