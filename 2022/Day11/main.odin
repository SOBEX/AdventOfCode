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

Line::string
Input::[]Line
Position::[2]int
Cell::int
Row::[]Cell
Board::[]Row

import "core:strconv"
import "core:slice"

MONKEY_OPERATION_SELF::-1
Monkey::struct{
   id:int,
   items:[dynamic]int,
   operation_symbol:u8,
   operation_number:int,
   test_divisibility:int,
   test_true:int,
   test_false:int,
   inspections:int
}
monkey_make::proc(input:[]string)->Monkey{
   monkey:Monkey
   monkey.id=strconv.parse_int(input[0][7:len(input[0])-1]) or_else 0
   starting_items_strings:=strings.split(input[1][18:],", ")
   monkey.items=make([dynamic]int,0,len(starting_items_strings))
   for starting_items_string in starting_items_strings{
      append(&monkey.items,strconv.parse_int(starting_items_string) or_else 0)
   }
   delete(starting_items_strings)
   monkey.operation_symbol=input[2][23]
   monkey.operation_number=input[2][25:]=="old"?MONKEY_OPERATION_SELF:strconv.parse_int(input[2][25:]) or_else 0
   monkey.test_divisibility=strconv.parse_int(input[3][21:]) or_else 0
   monkey.test_true=strconv.parse_int(input[4][29:]) or_else 0
   monkey.test_false=strconv.parse_int(input[5][30:]) or_else 0
   return monkey
}
monkey_delete::proc(monkey:Monkey){
   delete(monkey.items)
}

solve_1::proc(input:Input)->int{
   monkeys:[dynamic]Monkey
   for i:=0;i+5<len(input);i+=7{
      append(&monkeys,monkey_make(input[i:i+6]))
   }
   inspections:=make([]int,len(monkeys))
   for i in 0..<20{
      for &monkey,index in monkeys{
         for item in monkey.items{
            other:=monkey.operation_number==MONKEY_OPERATION_SELF?item:monkey.operation_number
            new:=monkey.operation_symbol=='*'?item*other:item+other
            new/=3
            target:=new%monkey.test_divisibility==0?monkey.test_true:monkey.test_false
            append(&monkeys[target].items,new)
         }
         inspections[index]+=len(monkey.items)
         clear(&monkey.items)
      }
   }
   for monkey in monkeys{
      monkey_delete(monkey)
   }
   delete(monkeys)
   slice.sort(inspections)
   l:=len(inspections)
   result:=inspections[l-1]*inspections[l-2]
   delete(inspections)
   return result
}

import "core:math"

solve_2::proc(input:Input)->int{
   monkeys:[dynamic]Monkey
   modulo:=1
   for i:=0;i+5<len(input);i+=7{
      append(&monkeys,monkey_make(input[i:i+6]))
      modulo=math.lcm(modulo,monkeys[len(monkeys)-1].test_divisibility)
   }
   inspections:=make([]int,len(monkeys))
   for i in 0..<10000{
      for &monkey,index in monkeys{
         for item in monkey.items{
            other:=monkey.operation_number==MONKEY_OPERATION_SELF?item:monkey.operation_number
            new:=monkey.operation_symbol=='*'?item*other:item+other
            new%%=modulo
            target:=new%monkey.test_divisibility==0?monkey.test_true:monkey.test_false
            append(&monkeys[target].items,new)
         }
         inspections[index]+=len(monkey.items)
         clear(&monkey.items)
      }
   }
   for monkey in monkeys{
      monkey_delete(monkey)
   }
   delete(monkeys)
   slice.sort(inspections)
   l:=len(inspections)
   result:=inspections[l-1]*inspections[l-2]
   delete(inspections)
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

   do_warming  :=0
   do_example_1:=true
   do_input_1  :=true
   do_example_2:=true
   do_input_2  :=true

   example_1:=Input{
      "Monkey 0:",
      "  Starting items: 79, 98",
      "  Operation: new = old * 19",
      "  Test: divisible by 23",
      "    If true: throw to monkey 2",
      "    If false: throw to monkey 3",
      "",
      "Monkey 1:",
      "  Starting items: 54, 65, 75, 74",
      "  Operation: new = old + 6",
      "  Test: divisible by 19",
      "    If true: throw to monkey 2",
      "    If false: throw to monkey 0",
      "",
      "Monkey 2:",
      "  Starting items: 79, 60, 97",
      "  Operation: new = old * old",
      "  Test: divisible by 13",
      "    If true: throw to monkey 1",
      "    If false: throw to monkey 3",
      "",
      "Monkey 3:",
      "  Starting items: 74",
      "  Operation: new = old + 3",
      "  Test: divisible by 17",
      "    If true: throw to monkey 0",
      "    If false: throw to monkey 1"
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

   result:=0
   for warming in 0..<do_warming{
      if do_example_1{
         result=solve_1(example_1)
      }
      if do_input_1{
         result=solve_1(input)
      }
      if do_example_2{
         result=solve_2(example_2)
      }
      if do_input_2{
         result=solve_2(input)
      }
   }
   result=0

   answer_1_example:=-1
   answer_1_input:=-1
   answer_2_example:=-1
   answer_2_input:=-1

   time_0:=get_time()
   if do_example_1{
      answer_1_example=solve_1(example_1)
   }
   time_1:=get_time()
   if do_input_1{
      answer_1_input=solve_1(input)
   }
   time_2:=get_time()
   if do_example_2{
      answer_2_example=solve_2(example_2)
   }
   time_3:=get_time()
   if do_input_2{
      answer_2_input=solve_2(input)
   }
   time_4:=get_time()

   fmt.printfln("Example 1 took % 9.4fms: %v",get_duration_ms(time_0,time_1),answer_1_example)
   fmt.printfln("Input   1 took % 9.4fms: %v",get_duration_ms(time_1,time_2),answer_1_input)
   fmt.printfln("Example 2 took % 9.4fms: %v",get_duration_ms(time_2,time_3),answer_2_example)
   fmt.printfln("Input   2 took % 9.4fms: %v",get_duration_ms(time_3,time_4),answer_2_input)
}
