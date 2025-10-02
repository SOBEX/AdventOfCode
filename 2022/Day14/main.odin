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

import "core:strconv"

solve_1::proc(input:[]string)->(result:=0){
   xmin,ymin:=500,0
   xmax,ymax:=500,0
   for line in input{
      splits:=strings.split(line," -> ")
      for split in splits{
         comma:=strings.index_byte(split,',')
         x:=strconv.parse_int(split[:comma]) or_else 500
         y:=strconv.parse_int(split[comma+1:]) or_else 0
         if x<xmin do xmin=x
         if x>xmax do xmax=x
         if y<ymin do ymin=y
         if y>ymax do ymax=y
      }
      delete(splits)
   }
   width:=xmax-xmin+1
   height:=ymax-ymin+1
   rocks:=make([]bool,width*height)
   for line in input{
      splits:=strings.split(line," -> ")
      comma:=strings.index_byte(splits[0],',')
      x:=(strconv.parse_int(splits[0][:comma]) or_else 500)-xmin
      y:=(strconv.parse_int(splits[0][comma+1:]) or_else 0)-ymin
      for i in 1..<len(splits){
         split:=splits[i]
         comma:=strings.index_byte(split,',')
         nx:=(strconv.parse_int(split[:comma]) or_else 500)-xmin
         ny:=(strconv.parse_int(split[comma+1:]) or_else 0)-ymin
         for ;x>nx;x-=1 do rocks[y*width+x]=true
         for ;x<nx;x+=1 do rocks[y*width+x]=true
         for ;y>ny;y-=1 do rocks[y*width+x]=true
         for ;y<ny;y+=1 do rocks[y*width+x]=true
         rocks[y*width+x]=true
      }
      delete(splits)
   }
   loop: for{
      x,y:=500-xmin,0-ymin
      for{
         if !(0<=y&&y<height&&0<=x&&x<width){
            break loop
         }
         if !rocks[(y+1)*width+x]{
            y+=1
            continue
         }
         if !rocks[(y+1)*width+(x-1)]{
            y+=1
            x-=1
            continue
         }
         if !rocks[(y+1)*width+(x+1)]{
            y+=1
            x+=1
            continue
         }
         break
      }
      rocks[y*width+x]=true
      result+=1
   }
   delete(rocks)
   return result
}

solve_2::proc(input:[]string)->(result:=0){
   xmin,ymin:=500,0
   xmax,ymax:=500,0
   for line in input{
      splits:=strings.split(line," -> ")
      for split in splits{
         comma:=strings.index_byte(split,',')
         x:=strconv.parse_int(split[:comma]) or_else 500
         y:=strconv.parse_int(split[comma+1:]) or_else 0
         if x<xmin do xmin=x
         if x>xmax do xmax=x
         if y<ymin do ymin=y
         if y>ymax do ymax=y
      }
      delete(splits)
   }
   ymax+=2
   xmin=min(xmin,500-ymax)
   xmax=max(xmax,500+ymax)
   width:=xmax-xmin+1
   height:=ymax-ymin+1
   rocks:=make([]bool,width*height)
   for line in input{
      splits:=strings.split(line," -> ")
      comma:=strings.index_byte(splits[0],',')
      x:=(strconv.parse_int(splits[0][:comma]) or_else 500)-xmin
      y:=(strconv.parse_int(splits[0][comma+1:]) or_else 0)-ymin
      for i in 1..<len(splits){
         split:=splits[i]
         comma:=strings.index_byte(split,',')
         nx:=(strconv.parse_int(split[:comma]) or_else 500)-xmin
         ny:=(strconv.parse_int(split[comma+1:]) or_else 0)-ymin
         for ;x>nx;x-=1 do rocks[y*width+x]=true
         for ;x<nx;x+=1 do rocks[y*width+x]=true
         for ;y>ny;y-=1 do rocks[y*width+x]=true
         for ;y<ny;y+=1 do rocks[y*width+x]=true
         rocks[y*width+x]=true
      }
      delete(splits)
   }
   for x in 0..<width{
      rocks[ymax*width+x]=true
   }
   loop: for{
      x,y:=500-xmin,0-ymin
      for{
         if rocks[y*width+x]{
            break loop
         }
         if !rocks[(y+1)*width+x]{
            y+=1
            continue
         }
         if !rocks[(y+1)*width+(x-1)]{
            y+=1
            x-=1
            continue
         }
         if !rocks[(y+1)*width+(x+1)]{
            y+=1
            x+=1
            continue
         }
         break
      }
      rocks[y*width+x]=true
      result+=1
   }
   delete(rocks)
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
      "498,4 -> 498,6 -> 496,6",
      "503,4 -> 502,4 -> 502,9 -> 494,9"
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
