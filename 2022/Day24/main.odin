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
   height:=len(input)-2
   width:=len(input[0])-2
   blizzards:map[[2]int][2]int
   for y in 0..<height{
      for x in 0..<width{
         switch input[y+1][x+1]{
            case '>':
               blizzards[[2]int{x,y}]=[2]int{1,0}
            case 'v':
               blizzards[[2]int{x,y}]=[2]int{0,1}
            case '<':
               blizzards[[2]int{x,y}]=[2]int{-1,0}
            case '^':
               blizzards[[2]int{x,y}]=[2]int{0,-1}
         }
      }
   }
   turn:=0
   for{
      for blizzard,direction in blizzards{
         if (blizzard.y+turn*direction.y)%%height==0&&(blizzard.x+turn*direction.x)%%width==0{
            turn+=1
            continue
         }
      }
      break
   }
   start:=[2]int{0,0}
   end:=[2]int{width-1,height-1}
   positions:=make(map[[2]int]struct{})
   board:=make([][]bool,height)
   for &row in board{
      row=make([]bool,width)
   }
   for positions[start]={};(end not_in positions);turn+=1{
      for row in board{
         for &cell in row{
            cell=true
         }
      }
      for blizzard,direction in blizzards{
         y:=(blizzard.y+turn*direction.y)%%height
         x:=(blizzard.x+turn*direction.x)%%width
         board[y][x]=false
      }
      new_positions:=make(map[[2]int]struct{},len(positions))
      for position in positions{
         if board[position.y][position.x]{
            new_positions[position]={}
         }
         if position.y>start.y{
            new_position:=position+[2]int{0,-1}
            if board[new_position.y][new_position.x]{
               new_positions[new_position]={}
            }
         }
         if position.y<end.y{
            new_position:=position+[2]int{0,1}
            if board[new_position.y][new_position.x]{
               new_positions[new_position]={}
            }
         }
         if position.x>start.x{
            new_position:=position+[2]int{-1,0}
            if board[new_position.y][new_position.x]{
               new_positions[new_position]={}
            }
         }
         if position.x<end.x{
            new_position:=position+[2]int{1,0}
            if board[new_position.y][new_position.x]{
               new_positions[new_position]={}
            }
         }
      }
      old_positions:=positions
      positions=new_positions
      delete(old_positions)
   }
   for row in board{
      delete(row)
   }
   delete(board)
   delete(positions)
   delete(blizzards)
   return turn
}

run::proc(height,width:int,blizzards:map[[2]int][2]int,start,end:[2]int,turn:=0)->int{
   turn:=turn
   positions:=make(map[[2]int]struct{})
   board:=make([][]bool,height)
   for &row in board{
      row=make([]bool,width)
   }
   board[start.y][start.x]=true
   board[end.y][end.x]=true
   for positions[start]={};(end not_in positions);turn+=1{
      if len(positions)==0 do fmt.panicf("no positions left")
      for y in 1..<height-1{
         for x in 1..<width-1{
            board[y][x]=true
         }
      }
      for blizzard,direction in blizzards{
         y:=(blizzard.y-1+turn*direction.y)%%(height-2)+1
         x:=(blizzard.x-1+turn*direction.x)%%(width-2)+1
         board[y][x]=false
      }
      new_positions:=make(map[[2]int]struct{},len(positions))
      for position in positions{
         if board[position.y][position.x]{
            new_positions[position]={}
         }
         if position.y>0{
            new_position:=position+[2]int{0,-1}
            if board[new_position.y][new_position.x]{
               new_positions[new_position]={}
            }
         }
         if position.y<height-1{
            new_position:=position+[2]int{0,1}
            if board[new_position.y][new_position.x]{
               new_positions[new_position]={}
            }
         }
         if position.x>0{
            new_position:=position+[2]int{-1,0}
            if board[new_position.y][new_position.x]{
               new_positions[new_position]={}
            }
         }
         if position.x<width-1{
            new_position:=position+[2]int{1,0}
            if board[new_position.y][new_position.x]{
               new_positions[new_position]={}
            }
         }
      }
      old_positions:=positions
      positions=new_positions
      delete(old_positions)
   }
   for row in board{
      delete(row)
   }
   delete(board)
   delete(positions)
   return turn
}

solve_2::proc(input:[]string)->(result:=0){
   height:=len(input)
   width:=len(input[0])
   blizzards:map[[2]int][2]int
   for y in 0..<height{
      for x in 0..<width{
         switch input[y][x]{
            case '>':
               blizzards[[2]int{x,y}]=[2]int{1,0}
            case 'v':
               blizzards[[2]int{x,y}]=[2]int{0,1}
            case '<':
               blizzards[[2]int{x,y}]=[2]int{-1,0}
            case '^':
               blizzards[[2]int{x,y}]=[2]int{0,-1}
         }
      }
   }
   start:=[2]int{1,0}
   before_end:=[2]int{width-2,height-2}
   end:=[2]int{width-2,height-1}
   before_start:=[2]int{1,1}
   turn:=run(height,width,blizzards,start,before_end)
   fmt.println(turn)
   turn=run(height,width,blizzards,end,before_start,turn+1)
   fmt.println(turn)
   turn=run(height,width,blizzards,start,before_end,turn+1)
   fmt.println(turn)
   delete(blizzards)
   return turn
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
      "#.######",
      "#>>.<^<#",
      "#.<..<<#",
      "#>v.><>#",
      "#<^v^^>#",
      "######.#"
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
