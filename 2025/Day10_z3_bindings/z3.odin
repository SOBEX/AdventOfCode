package main

foreign import zlib "libz3.lib"

Config  ::distinct rawptr
Context ::distinct rawptr
Symbol  ::distinct rawptr
Sort    ::distinct rawptr
Ast     ::distinct rawptr
Optimize::distinct rawptr
Model   ::distinct rawptr

Error_Code :: distinct u32

Bool::distinct b32
LBool::enum i32{
   False=-1,
   Undef=0,
   True=1
}

@(default_calling_convention="c")
@(link_prefix="Z3_")
foreign zlib {
   mk_config::proc()->Config ---
   del_config::proc(c:Config) ---
   mk_context::proc(c:Config)->Context ---
   del_context::proc(c:Context) ---

   mk_string_symbol::proc(c:Context,s:cstring)->Symbol ---
   mk_int_sort::proc(c:Context)->Sort ---

   mk_const::proc(c:Context,s:Symbol,ty:Sort)->Ast ---
   mk_int::proc(c:Context,v:i32,ty:Sort)->Ast ---
   mk_add::proc(c:Context,num_args:u32,args:[^]Ast)->Ast ---
   mk_eq::proc(c:Context,l,r:Ast)->Ast ---
   mk_ge::proc(c:Context,t1,t2:Ast)->Ast ---

   mk_optimize::proc(c:Context)->Optimize ---
   optimize_inc_ref::proc(c:Context,o:Optimize) ---
   optimize_dec_ref::proc(c:Context,o:Optimize) ---
   optimize_assert::proc(c:Context,o:Optimize,a:Ast) ---
   optimize_minimize::proc(c:Context,o:Optimize,t:Ast) ---
   optimize_check::proc(c:Context,o:Optimize,num_assumptions:u32,assumptions:[^]Ast)->LBool ---
   optimize_get_model::proc(c:Context,o:Optimize)->Model ---

   model_inc_ref::proc(c:Context,m:Model) ---
   model_dec_ref::proc(c:Context,m:Model) ---
   model_eval::proc(c:Context,m:Model,t:Ast,model_completion:bool,v:^Ast)->bool ---
   get_numeral_int::proc(c:Context,v:Ast,i:^i32)->Bool ---
}
