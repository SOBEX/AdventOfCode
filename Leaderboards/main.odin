package main

import "core:strings"
import "core:reflect"
import "core:strconv"
import "core:slice"
import "core:fmt"
import "core:encoding/json"
import "core:mem"
import os "core:os/os2"
import "core:text/table"
import "core:time"

Star_json::struct{
   star_index:int,
   get_star_ts:i64
}
Day_json::map[int]Star_json
Member_json::struct{
   name:string,
   stars:int,
   local_score:int,
   completion_day_level:map[int]Day_json
}
AoC_json::struct{
   event:string,
   owner_id:int,
   num_days:int,
   day1_ts:i64,
   members:map[int]Member_json,
}

Completion::struct{
   member:int,
   star_index:int,
   time:time.Duration
}
Star::struct{
   completions:[]Completion
}
Day::struct{
   stars:[2]Star
}
Member::struct{
   id:int,
   name:string,
   stars:int,
   score:int,
   scores:[][2]int,
   times:[][2]time.Duration
}
AoC::struct{
   event:string,
   owner:string,
   members:[]Member,
   member_ranks:map[string]int,
   day_starts:[]time.Time,
   days:[]Day
}

parse_aoc_json::proc(aoc_json:AoC_json,allocator:=context.allocator)->(aoc:AoC){
   aoc.event=aoc_json.event
   n_days:=aoc_json.num_days
   n_members:=len(aoc_json.members)
   aoc.members=make([]Member,n_members,allocator)
   i:=0
   for id,member in aoc_json.members{
      aoc.members[i]=Member{
         id=id,
         name=strings.clone(member.name,allocator) if member.name!="" else fmt.aprintf("(anonymous user #%i)",id,allocator=allocator),
         stars=member.stars,
         score=member.local_score,
         scores=make([][2]int,n_days,allocator),
         times=make([][2]time.Duration,n_days,allocator)
      }
      i+=1
   }
   slice.sort_by(aoc.members,proc(l,r:Member)->bool{
      if l.score!=r.score do return l.score>r.score
      if l.stars!=r.stars do return l.stars>r.stars
      return l.id<r.id
   })
   aoc.member_ranks=make(map[string]int,n_members,allocator)
   for member,rank in aoc.members{
      aoc.member_ranks[member.name]=rank
   }
   aoc.day_starts=make([]time.Time,n_days,allocator)
   aoc.day_starts[0]=time.from_nanoseconds(aoc_json.day1_ts*i64(time.Second))
   for day in 1..<n_days{
      aoc.day_starts[day]=time.time_add(aoc.day_starts[day-1],24*time.Hour)
   }
   aoc.days=make([]Day,n_days,allocator)
   for day in 0..<n_days{
      for part in 0..<2{
         count:=0
         for id,member in aoc_json.members{
            day_value,day_ok:=member.completion_day_level[day+1]
            if day_ok{
               part_value,part_ok:=day_value[part+1]
               if part_ok{
                  count+=1
               }
            }
         }
         aoc.days[day].stars[part].completions=make([]Completion,count,allocator)
         i:=0
         for id,member in aoc_json.members{
            day_value,day_ok:=member.completion_day_level[day+1]
            if day_ok{
               part_value,part_ok:=day_value[part+1]
               if part_ok{
                  aoc.days[day].stars[part].completions[i]=Completion{
                     member=aoc.member_ranks[member.name],
                     star_index=part_value.star_index,
                     time=time.diff(aoc.day_starts[day],time.from_nanoseconds(part_value.get_star_ts*i64(time.Second)))
                  }
                  i+=1
               }
            }
         }
         slice.sort_by(aoc.days[day].stars[part].completions,proc(l,r:Completion)->bool{
            if l.time!=r.time do return l.time<r.time
            return l.star_index<r.star_index
         })
         for completion,rank in aoc.days[day].stars[part].completions{
            aoc.members[completion.member].scores[day][part]=n_members-rank
            aoc.members[completion.member].times[day][part]=completion.time
         }
      }
   }
   return aoc
}

delete_aoc::proc(aoc:AoC,allocator:=context.allocator){
   for day in aoc.days{
      for part in 0..<2{
         delete(day.stars[part].completions)
      }
   }
   delete(aoc.days)
   delete(aoc.day_starts)
   delete(aoc.member_ranks)
   for member in aoc.members{
      delete(member.times)
      delete(member.scores)
      delete(member.name)
   }
   delete(aoc.members)
   return
}

main::proc(){
   when ODIN_DEBUG{
      original_allocator:=context.allocator
      tracking_allocator:mem.Tracking_Allocator
      mem.tracking_allocator_init(&tracking_allocator,original_allocator)
      tracking_allocator.bad_free_callback=mem.tracking_allocator_bad_free_callback_add_to_array
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

   DIRECTORY::"."
   cwd,os_err:=os.open(DIRECTORY)
   if os_err!=nil{
      fmt.eprintfln("failed opening %q: %s",DIRECTORY,os.error_string(os_err))
      return
   }

   it:=os.read_directory_iterator_create(cwd)

   for info in os.read_directory_iterator(&it) {
      if path,os_err:=os.read_directory_iterator_error(&it);os_err!=nil{
         fmt.eprintfln("failed reading %q: %s",path,os.error_string(os_err))
         continue
      }

      base,ext:=os.split_filename(info.name)
      if ext!="json"{
         continue
      }

      out_name,name_err:=os.join_filename(base,"txt",context.temp_allocator)
      if name_err!=nil{
         fmt.eprintfln("failed writing %q: %s",info.fullpath,os.error_string(name_err))
         continue
      }

      out_path,path_error:=os.join_path([]string{DIRECTORY,out_name},context.temp_allocator)
      if path_error!=nil{
         fmt.eprintfln("failed writing %q: %s",info.fullpath,os.error_string(path_error))
         continue
      }

      content,read_err:=os.read_entire_file(info.fullpath,context.temp_allocator)
      if read_err!=nil{
         fmt.eprintfln("failed reading %q: %s",info.fullpath,os.error_string(read_err))
         continue
      }

      aoc_json:AoC_json
      json_err:=json.unmarshal(content,&aoc_json,allocator=context.temp_allocator)
      if json_err!=nil{
         fmt.eprintfln("failed reading %q: %s",info.fullpath,os.error_string(read_err))
         continue
      }

      aoc:=parse_aoc_json(aoc_json,context.temp_allocator)

      _tm:table.Table
      tm:=table.init_with_allocator(&_tm,context.temp_allocator,context.temp_allocator)
      table.caption(tm,"Members")
      tm_row:=make([]string,5+len(aoc.days)*2,context.temp_allocator)
      tm_row_any:=make([]any,5+len(aoc.days)*2,context.temp_allocator)
      for &r,i in tm_row_any{
         r=tm_row[i]
      }
      tm_row[0]="Rank"
      tm_row[1]="ID"
      tm_row[2]="Name"
      tm_row[3]="Stars"
      tm_row[4]="Score"
      for day in 0..<len(aoc.days){
         for part in 0..<2{
            tm_row[5+day*2+part]=fmt.tprint("Day",day+1,"Part",part+1)
         }
      }
      table.header(tm,..tm_row_any)
      for member,rank in aoc.members{
         tm_row[0]=fmt.tprint(rank+1)
         tm_row[1]=fmt.tprint(member.id)
         tm_row[2]=member.name
         tm_row[3]=fmt.tprint(member.stars)
         tm_row[4]=fmt.tprint(member.score)
         for day in 0..<len(aoc.days){
            for part in 0..<2{
               tm_row[5+day*2+part]=fmt.tprint(member.scores[day][part],'@',member.times[day][part])
            }
         }
         table.row(tm,..tm_row_any)
      }

      _td:table.Table
      td:=table.init(&_td)
      defer table.destroy(td)
      table.caption(td,"Days")
      td_row:=make([]string,1+len(aoc.days)*2,context.temp_allocator)
      td_row_any:=make([]any,1+len(aoc.days)*2,context.temp_allocator)
      for &r,i in td_row_any{
         r=td_row[i]
      }
      td_row[0]="Rank"
      for day in 0..<len(aoc.days){
         for part in 0..<2{
            td_row[1+day*2+part]=fmt.tprint("Day",day+1,"Part",part+1)
         }
      }
      table.header(td,..td_row_any)
      for rank in 0..<len(aoc.members){
         td_row[0]=fmt.tprint(rank)
         empty:=true
         for day,d in aoc.days{
            for part,p in day.stars{
               if rank>=len(part.completions){
                  td_row[1+d*2+p]=""
                  continue
               }
               completion:=part.completions[rank]
               name:=aoc.members[completion.member].name
               td_row[1+d*2+p]=fmt.tprint(name,'@',completion.time)
               empty=false
            }
         }
         if empty{
            break
         }
         table.row(td,..td_row_any)
      }

      out_file,create_err:=os.create(out_path)
      if create_err!=nil{
         fmt.eprintfln("failed creating %q: %s",out_path,os.error_string(read_err))
         continue
      }

      out_writer:=os.to_writer(out_file)

      table.write_plain_table(out_writer,tm)
      table.write_plain_table(out_writer,td)

      os.close(out_file)

      free_all(context.temp_allocator)
   }

   if path,err:=os.read_directory_iterator_error(&it);err!=nil{
      fmt.eprintfln("read directory failed at %q: %s",path,err)
   }

   os.read_directory_iterator_destroy(&it)
   os.close(cwd)
}
