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

Op::struct{
   first,second:[4]u8`fmt:"s,4"`,
   op:u8`fmt:"c"`
}

u8ify::proc(line:string,$from,$to:int)->(result:[to-from]u8){
   for i in 0..<to-from{
      result[i]=line[i+from]
   }
   return result
}

pull::proc(vals:map[[4]u8]int,ops:map[[4]u8]Op,root:[4]u8)->int{
   if root in vals{
      return vals[root]
   }
   if root in ops{
      op:=ops[root]
      first:=pull(vals,ops,op.first)
      second:=pull(vals,ops,op.second)
      switch op.op{
         case '+':
            return first+second
         case '-':
            return first-second
         case '*':
            return first*second
         case '/':
            return first/second
      }
   }
   return 0
}

solve_1::proc(input:[]string)->(result:=0){
   vals:map[[4]u8]int
   ops:map[[4]u8]Op
   for line in input{
      if len(line)==17{
         ops[u8ify(line,0,4)]=Op{u8ify(line,6,10),u8ify(line,13,17),line[11]}
      }else{
         vals[u8ify(line,0,4)]=strconv.parse_int(line[6:]) or_else 0
      }
   }
   result=pull(vals,ops,"root")
   delete(ops)
   delete(vals)
   return result
}

is_in::proc(vals:map[[4]u8]int,ops:map[[4]u8]Op,root,humn:[4]u8)->bool{
   if root==humn{
      return true
   }
   if root in vals{
      return false
   }
   if root in ops{
      op:=ops[root]
      return is_in(vals,ops,op.first,humn)||is_in(vals,ops,op.second,humn)
   }
   return false
}
push::proc(vals:map[[4]u8]int,ops:map[[4]u8]Op,root,humn:[4]u8,goal:int)->int{
   if root==humn{
      return goal
   }
   if root in vals{
      return 0
   }
   if root in ops{
      op:=ops[root]
      is_in_first:=is_in(vals,ops,op.first,humn)
      other:=pull(vals,ops,is_in_first?op.second:op.first)
      new_goal:int
      switch op.op{
         case '+':
            new_goal=goal-other
         case '-':
            if is_in_first{
               new_goal=goal+other
            }else{
               new_goal=other-goal
            }
         case '*':
            new_goal=goal/other
         case '/':
            if is_in_first{
               new_goal=goal*other
            }else{
               new_goal=other/goal
            }
      }
      return push(vals,ops,is_in_first?op.first:op.second,humn,new_goal)
   }
   return 0
}

solve_2::proc(input:[]string)->(result:=0){
   vals:map[[4]u8]int
   ops:map[[4]u8]Op
   for line in input{
      if len(line)==17{
         ops[u8ify(line,0,4)]=Op{u8ify(line,6,10),u8ify(line,13,17),line[11]}
      }else{
         vals[u8ify(line,0,4)]=strconv.parse_int(line[6:]) or_else 0
      }
   }
   op:=ops["root"]
   is_in_first:=is_in(vals,ops,op.first,"humn")
   goal:=pull(vals,ops,is_in_first?op.second:op.first)
   result=push(vals,ops,is_in_first?op.first:op.second,"humn",goal)
   delete(ops)
   delete(vals)
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
      "root: pppw + sjmn",
      "dbpl: 5",
      "cczh: sllz + lgvd",
      "zczc: 2",
      "ptdq: humn - dvpt",
      "dvpt: 3",
      "lfqf: 4",
      "humn: 5",
      "ljgn: 2",
      "sjmn: drzm * dbpl",
      "sllz: 4",
      "pppw: cczh / lfqf",
      "lgvd: ljgn * ptdq",
      "drzm: hmdt - zczc",
      "hmdt: 32"
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
