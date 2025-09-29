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
   return time.duration_milliseconds(time.diff(start,end))
}
get_duration_ms::proc(start,end:Time)->f64{
   return time.duration_microseconds(time.diff(start,end))
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

Node::struct{
   name:string,
   parent:^Node,
   size:int,
   children:map[string]^Node
}
node_new::proc(name:string,parent:^Node=nil,size:int=0)->^Node{
   node:=new(Node)
   node^=Node{
      name=name,
      parent=parent,
      size=size,
      children=make(map[string]^Node)
   }
   return node
}
node_add::proc(parent:^Node,name:string,size:int=0){
   parent.children[name]=node_new(name,parent,size)
}
node_walk_and_free::proc(root:^Node,limit:int)->int{
   sum:=0
   if len(root.children)>0{
      for _,child in root.children{
         sum+=node_walk_and_free(child,limit)
      }
      if root.size<=limit{
         sum+=root.size
      }
   }
   if root.parent!=nil{
      root.parent.size+=root.size
   }
   delete(root.children)
   free(root)
   return sum
}
node_tree_from_input::proc(input:Input)->^Node{
   root:=node_new("/")
   current_node:=root
   in_listing:=false
   for line in input{
      if line=="$ cd /"{
         continue
      }
      split:=strings.split(line," ")
      defer delete(split)
      if in_listing{
         if split[0]=="dir"{
            node_add(current_node,split[1])
            continue
         }else if split[0]!="$"{
            node_add(current_node,split[1],strconv.parse_int(split[0]) or_else 0)
            continue
         }
         in_listing=false
      }
      if split[0]!="$"{
         fmt.eprintln("ERROR1:",line)
      }else if split[1]=="cd"{
         if split[2]==".."{
            if current_node.parent!=nil{
               current_node=current_node.parent
            }else{
               fmt.eprintln("ERROR2:",line)
            }
         }else{
            current_node=current_node.children[split[2]]
         }
      }else if split[1]=="ls"{
         in_listing=true
      }else{
         fmt.eprintln("ERROR3:",line)
      }
   }
   return root
}

solve_1::proc(input:Input)->int{
   root:=node_tree_from_input(input)
   return node_walk_and_free(root,100_000)
}

node_update::proc(root:^Node){
   if len(root.children)>0{
      root.size=0
      for _,child in root.children{
         node_update(child)
      }
   }
   if root.parent!=nil{
      root.parent.size+=root.size
   }
}
node_find_and_free::proc(root:^Node,limit:int)->int{
   best:=70_000_000
   if len(root.children)>0{
      if limit<=root.size&&root.size<best{
         best=root.size
      }
      for _,child in root.children{
         child:=node_find_and_free(child,limit)
         if limit<=child&&child<best{
            best=child
         }
      }
   }
   delete(root.children)
   free(root)
   return best
}

solve_2::proc(input:Input)->int{
   root:=node_tree_from_input(input)
   node_update(root)
   total:=root.size
   needed:=30_000_000-(70_000_000-root.size)
   return node_find_and_free(root,needed)
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
      "$ cd /",
      "$ ls",
      "dir a",
      "14848514 b.txt",
      "8504156 c.dat",
      "dir d",
      "$ cd a",
      "$ ls",
      "dir e",
      "29116 f",
      "2557 g",
      "62596 h.lst",
      "$ cd e",
      "$ ls",
      "584 i",
      "$ cd ..",
      "$ cd ..",
      "$ cd d",
      "$ ls",
      "4060174 j",
      "8033020 d.log",
      "5626152 d.ext",
      "7214296 k"
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

   result:int=0
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

   answer_1_example:int=-1
   answer_1_input:int=-1
   answer_2_example:int=-1
   answer_2_input:int=-1

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

   fmt.printfln("Example 1 took % 6.1fms: %v",get_duration_ms(time_0,time_1),answer_1_example)
   fmt.printfln("Input   1 took % 6.1fms: %v",get_duration_ms(time_1,time_2),answer_1_input)
   fmt.printfln("Example 2 took % 6.1fms: %v",get_duration_ms(time_2,time_3),answer_2_example)
   fmt.printfln("Input   2 took % 6.1fms: %v",get_duration_ms(time_3,time_4),answer_2_input)
}
