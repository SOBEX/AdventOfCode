package main
INPUT::#load("input",string)
main::proc(){
   solve_1(INPUT,len(INPUT)/101-1,0)
   solve_2(INPUT,len(INPUT)/101-1,0)
}
solve_1::proc($input:string,$i:int,$SOLUTION:int){
   when i==-1{
      _::""[/*
      */SOLUTION/*
      */]
   }else{
      from::i*101
      to::(i+1)*101-1
      digits::input[from:to]
      n0::     100-size_of(hundred_minus_index(digits[ 0  : 99],size_of(max(digits[ 0  : 99]))))
      n1::n0+1+100-size_of(hundred_minus_index(digits[n0+1:100],size_of(max(digits[n0+1:100]))))
      result::10*int(digits[n0]-'0')+int(digits[n1]-'0')
      solve_1(input,i-1,SOLUTION+result)
   }
}
combine_2::struct($d0,$d1:u8)#packed{
   _:[10*int(d0-'0')+
       1*int(d1-'0')]u8
}
solve_2::proc($input:string,$i:int,$SOLUTION:int){
   when i==-1{
      _::""[/*
      */SOLUTION/*
      */]
   }else{
      from::i*101
      to::(i+1)*101-1
      digits::input[from:to]
      n0::     100-size_of(hundred_minus_index(digits[ 0  : 89],size_of(max(digits[ 0  : 89]))))
      n1::n0+1+100-size_of(hundred_minus_index(digits[n0+1: 90],size_of(max(digits[n0+1: 90]))))
      n2::n1+1+100-size_of(hundred_minus_index(digits[n1+1: 91],size_of(max(digits[n1+1: 91]))))
      n3::n2+1+100-size_of(hundred_minus_index(digits[n2+1: 92],size_of(max(digits[n2+1: 92]))))
      n4::n3+1+100-size_of(hundred_minus_index(digits[n3+1: 93],size_of(max(digits[n3+1: 93]))))
      n5::n4+1+100-size_of(hundred_minus_index(digits[n4+1: 94],size_of(max(digits[n4+1: 94]))))
      n6::n5+1+100-size_of(hundred_minus_index(digits[n5+1: 95],size_of(max(digits[n5+1: 95]))))
      n7::n6+1+100-size_of(hundred_minus_index(digits[n6+1: 96],size_of(max(digits[n6+1: 96]))))
      n8::n7+1+100-size_of(hundred_minus_index(digits[n7+1: 97],size_of(max(digits[n7+1: 97]))))
      n9::n8+1+100-size_of(hundred_minus_index(digits[n8+1: 98],size_of(max(digits[n8+1: 98]))))
      nA::n9+1+100-size_of(hundred_minus_index(digits[n9+1: 99],size_of(max(digits[n9+1: 99]))))
      nB::nA+1+100-size_of(hundred_minus_index(digits[nA+1:100],size_of(max(digits[nA+1:100]))))
      result::100000000000*int(digits[n0]-'0')+
               10000000000*int(digits[n1]-'0')+
                1000000000*int(digits[n2]-'0')+
                 100000000*int(digits[n3]-'0')+
                  10000000*int(digits[n4]-'0')+
                   1000000*int(digits[n5]-'0')+
                    100000*int(digits[n6]-'0')+
                     10000*int(digits[n7]-'0')+
                      1000*int(digits[n8]-'0')+
                       100*int(digits[n9]-'0')+
                        10*int(digits[nA]-'0')+
                         1*int(digits[nB]-'0')
      solve_2(input,i-1,SOLUTION+result)
   }
}
max::struct(digits:string)#raw_union{
   [digits[ 0] when len(digits)> 0 else 0]u8,
   [digits[ 1] when len(digits)> 1 else 0]u8,
   [digits[ 2] when len(digits)> 2 else 0]u8,
   [digits[ 3] when len(digits)> 3 else 0]u8,
   [digits[ 4] when len(digits)> 4 else 0]u8,
   [digits[ 5] when len(digits)> 5 else 0]u8,
   [digits[ 6] when len(digits)> 6 else 0]u8,
   [digits[ 7] when len(digits)> 7 else 0]u8,
   [digits[ 8] when len(digits)> 8 else 0]u8,
   [digits[ 9] when len(digits)> 9 else 0]u8,
   [digits[10] when len(digits)>10 else 0]u8,
   [digits[11] when len(digits)>11 else 0]u8,
   [digits[12] when len(digits)>12 else 0]u8,
   [digits[13] when len(digits)>13 else 0]u8,
   [digits[14] when len(digits)>14 else 0]u8,
   [digits[15] when len(digits)>15 else 0]u8,
   [digits[16] when len(digits)>16 else 0]u8,
   [digits[17] when len(digits)>17 else 0]u8,
   [digits[18] when len(digits)>18 else 0]u8,
   [digits[19] when len(digits)>19 else 0]u8,
   [digits[20] when len(digits)>20 else 0]u8,
   [digits[21] when len(digits)>21 else 0]u8,
   [digits[22] when len(digits)>22 else 0]u8,
   [digits[23] when len(digits)>23 else 0]u8,
   [digits[24] when len(digits)>24 else 0]u8,
   [digits[25] when len(digits)>25 else 0]u8,
   [digits[26] when len(digits)>26 else 0]u8,
   [digits[27] when len(digits)>27 else 0]u8,
   [digits[28] when len(digits)>28 else 0]u8,
   [digits[29] when len(digits)>29 else 0]u8,
   [digits[30] when len(digits)>30 else 0]u8,
   [digits[31] when len(digits)>31 else 0]u8,
   [digits[32] when len(digits)>32 else 0]u8,
   [digits[33] when len(digits)>33 else 0]u8,
   [digits[34] when len(digits)>34 else 0]u8,
   [digits[35] when len(digits)>35 else 0]u8,
   [digits[36] when len(digits)>36 else 0]u8,
   [digits[37] when len(digits)>37 else 0]u8,
   [digits[38] when len(digits)>38 else 0]u8,
   [digits[39] when len(digits)>39 else 0]u8,
   [digits[40] when len(digits)>40 else 0]u8,
   [digits[41] when len(digits)>41 else 0]u8,
   [digits[42] when len(digits)>42 else 0]u8,
   [digits[43] when len(digits)>43 else 0]u8,
   [digits[44] when len(digits)>44 else 0]u8,
   [digits[45] when len(digits)>45 else 0]u8,
   [digits[46] when len(digits)>46 else 0]u8,
   [digits[47] when len(digits)>47 else 0]u8,
   [digits[48] when len(digits)>48 else 0]u8,
   [digits[49] when len(digits)>49 else 0]u8,
   [digits[50] when len(digits)>50 else 0]u8,
   [digits[51] when len(digits)>51 else 0]u8,
   [digits[52] when len(digits)>52 else 0]u8,
   [digits[53] when len(digits)>53 else 0]u8,
   [digits[54] when len(digits)>54 else 0]u8,
   [digits[55] when len(digits)>55 else 0]u8,
   [digits[56] when len(digits)>56 else 0]u8,
   [digits[57] when len(digits)>57 else 0]u8,
   [digits[58] when len(digits)>58 else 0]u8,
   [digits[59] when len(digits)>59 else 0]u8,
   [digits[60] when len(digits)>60 else 0]u8,
   [digits[61] when len(digits)>61 else 0]u8,
   [digits[62] when len(digits)>62 else 0]u8,
   [digits[63] when len(digits)>63 else 0]u8,
   [digits[64] when len(digits)>64 else 0]u8,
   [digits[65] when len(digits)>65 else 0]u8,
   [digits[66] when len(digits)>66 else 0]u8,
   [digits[67] when len(digits)>67 else 0]u8,
   [digits[68] when len(digits)>68 else 0]u8,
   [digits[69] when len(digits)>69 else 0]u8,
   [digits[70] when len(digits)>70 else 0]u8,
   [digits[71] when len(digits)>71 else 0]u8,
   [digits[72] when len(digits)>72 else 0]u8,
   [digits[73] when len(digits)>73 else 0]u8,
   [digits[74] when len(digits)>74 else 0]u8,
   [digits[75] when len(digits)>75 else 0]u8,
   [digits[76] when len(digits)>76 else 0]u8,
   [digits[77] when len(digits)>77 else 0]u8,
   [digits[78] when len(digits)>78 else 0]u8,
   [digits[79] when len(digits)>79 else 0]u8,
   [digits[80] when len(digits)>80 else 0]u8,
   [digits[81] when len(digits)>81 else 0]u8,
   [digits[82] when len(digits)>82 else 0]u8,
   [digits[83] when len(digits)>83 else 0]u8,
   [digits[84] when len(digits)>84 else 0]u8,
   [digits[85] when len(digits)>85 else 0]u8,
   [digits[86] when len(digits)>86 else 0]u8,
   [digits[87] when len(digits)>87 else 0]u8,
   [digits[88] when len(digits)>88 else 0]u8,
   [digits[89] when len(digits)>89 else 0]u8,
   [digits[90] when len(digits)>90 else 0]u8,
   [digits[91] when len(digits)>91 else 0]u8,
   [digits[92] when len(digits)>92 else 0]u8,
   [digits[93] when len(digits)>93 else 0]u8,
   [digits[94] when len(digits)>94 else 0]u8,
   [digits[95] when len(digits)>95 else 0]u8,
   [digits[96] when len(digits)>96 else 0]u8,
   [digits[97] when len(digits)>97 else 0]u8,
   [digits[98] when len(digits)>98 else 0]u8,
   [digits[99] when len(digits)>99 else 0]u8
}
hundred_minus_index::struct(digits:string,value:u8)#raw_union{
   [100- 0 when digits[ 0 when len(digits)> 0 else len(digits)-1]==value else 0]u8,
   [100- 1 when digits[ 1 when len(digits)> 1 else len(digits)-1]==value else 0]u8,
   [100- 2 when digits[ 2 when len(digits)> 2 else len(digits)-1]==value else 0]u8,
   [100- 3 when digits[ 3 when len(digits)> 3 else len(digits)-1]==value else 0]u8,
   [100- 4 when digits[ 4 when len(digits)> 4 else len(digits)-1]==value else 0]u8,
   [100- 5 when digits[ 5 when len(digits)> 5 else len(digits)-1]==value else 0]u8,
   [100- 6 when digits[ 6 when len(digits)> 6 else len(digits)-1]==value else 0]u8,
   [100- 7 when digits[ 7 when len(digits)> 7 else len(digits)-1]==value else 0]u8,
   [100- 8 when digits[ 8 when len(digits)> 8 else len(digits)-1]==value else 0]u8,
   [100- 9 when digits[ 9 when len(digits)> 9 else len(digits)-1]==value else 0]u8,
   [100-10 when digits[10 when len(digits)>10 else len(digits)-1]==value else 0]u8,
   [100-11 when digits[11 when len(digits)>11 else len(digits)-1]==value else 0]u8,
   [100-12 when digits[12 when len(digits)>12 else len(digits)-1]==value else 0]u8,
   [100-13 when digits[13 when len(digits)>13 else len(digits)-1]==value else 0]u8,
   [100-14 when digits[14 when len(digits)>14 else len(digits)-1]==value else 0]u8,
   [100-15 when digits[15 when len(digits)>15 else len(digits)-1]==value else 0]u8,
   [100-16 when digits[16 when len(digits)>16 else len(digits)-1]==value else 0]u8,
   [100-17 when digits[17 when len(digits)>17 else len(digits)-1]==value else 0]u8,
   [100-18 when digits[18 when len(digits)>18 else len(digits)-1]==value else 0]u8,
   [100-19 when digits[19 when len(digits)>19 else len(digits)-1]==value else 0]u8,
   [100-20 when digits[20 when len(digits)>20 else len(digits)-1]==value else 0]u8,
   [100-21 when digits[21 when len(digits)>21 else len(digits)-1]==value else 0]u8,
   [100-22 when digits[22 when len(digits)>22 else len(digits)-1]==value else 0]u8,
   [100-23 when digits[23 when len(digits)>23 else len(digits)-1]==value else 0]u8,
   [100-24 when digits[24 when len(digits)>24 else len(digits)-1]==value else 0]u8,
   [100-25 when digits[25 when len(digits)>25 else len(digits)-1]==value else 0]u8,
   [100-26 when digits[26 when len(digits)>26 else len(digits)-1]==value else 0]u8,
   [100-27 when digits[27 when len(digits)>27 else len(digits)-1]==value else 0]u8,
   [100-28 when digits[28 when len(digits)>28 else len(digits)-1]==value else 0]u8,
   [100-29 when digits[29 when len(digits)>29 else len(digits)-1]==value else 0]u8,
   [100-30 when digits[30 when len(digits)>30 else len(digits)-1]==value else 0]u8,
   [100-31 when digits[31 when len(digits)>31 else len(digits)-1]==value else 0]u8,
   [100-32 when digits[32 when len(digits)>32 else len(digits)-1]==value else 0]u8,
   [100-33 when digits[33 when len(digits)>33 else len(digits)-1]==value else 0]u8,
   [100-34 when digits[34 when len(digits)>34 else len(digits)-1]==value else 0]u8,
   [100-35 when digits[35 when len(digits)>35 else len(digits)-1]==value else 0]u8,
   [100-36 when digits[36 when len(digits)>36 else len(digits)-1]==value else 0]u8,
   [100-37 when digits[37 when len(digits)>37 else len(digits)-1]==value else 0]u8,
   [100-38 when digits[38 when len(digits)>38 else len(digits)-1]==value else 0]u8,
   [100-39 when digits[39 when len(digits)>39 else len(digits)-1]==value else 0]u8,
   [100-40 when digits[40 when len(digits)>40 else len(digits)-1]==value else 0]u8,
   [100-41 when digits[41 when len(digits)>41 else len(digits)-1]==value else 0]u8,
   [100-42 when digits[42 when len(digits)>42 else len(digits)-1]==value else 0]u8,
   [100-43 when digits[43 when len(digits)>43 else len(digits)-1]==value else 0]u8,
   [100-44 when digits[44 when len(digits)>44 else len(digits)-1]==value else 0]u8,
   [100-45 when digits[45 when len(digits)>45 else len(digits)-1]==value else 0]u8,
   [100-46 when digits[46 when len(digits)>46 else len(digits)-1]==value else 0]u8,
   [100-47 when digits[47 when len(digits)>47 else len(digits)-1]==value else 0]u8,
   [100-48 when digits[48 when len(digits)>48 else len(digits)-1]==value else 0]u8,
   [100-49 when digits[49 when len(digits)>49 else len(digits)-1]==value else 0]u8,
   [100-50 when digits[50 when len(digits)>50 else len(digits)-1]==value else 0]u8,
   [100-51 when digits[51 when len(digits)>51 else len(digits)-1]==value else 0]u8,
   [100-52 when digits[52 when len(digits)>52 else len(digits)-1]==value else 0]u8,
   [100-53 when digits[53 when len(digits)>53 else len(digits)-1]==value else 0]u8,
   [100-54 when digits[54 when len(digits)>54 else len(digits)-1]==value else 0]u8,
   [100-55 when digits[55 when len(digits)>55 else len(digits)-1]==value else 0]u8,
   [100-56 when digits[56 when len(digits)>56 else len(digits)-1]==value else 0]u8,
   [100-57 when digits[57 when len(digits)>57 else len(digits)-1]==value else 0]u8,
   [100-58 when digits[58 when len(digits)>58 else len(digits)-1]==value else 0]u8,
   [100-59 when digits[59 when len(digits)>59 else len(digits)-1]==value else 0]u8,
   [100-60 when digits[60 when len(digits)>60 else len(digits)-1]==value else 0]u8,
   [100-61 when digits[61 when len(digits)>61 else len(digits)-1]==value else 0]u8,
   [100-62 when digits[62 when len(digits)>62 else len(digits)-1]==value else 0]u8,
   [100-63 when digits[63 when len(digits)>63 else len(digits)-1]==value else 0]u8,
   [100-64 when digits[64 when len(digits)>64 else len(digits)-1]==value else 0]u8,
   [100-65 when digits[65 when len(digits)>65 else len(digits)-1]==value else 0]u8,
   [100-66 when digits[66 when len(digits)>66 else len(digits)-1]==value else 0]u8,
   [100-67 when digits[67 when len(digits)>67 else len(digits)-1]==value else 0]u8,
   [100-68 when digits[68 when len(digits)>68 else len(digits)-1]==value else 0]u8,
   [100-69 when digits[69 when len(digits)>69 else len(digits)-1]==value else 0]u8,
   [100-70 when digits[70 when len(digits)>70 else len(digits)-1]==value else 0]u8,
   [100-71 when digits[71 when len(digits)>71 else len(digits)-1]==value else 0]u8,
   [100-72 when digits[72 when len(digits)>72 else len(digits)-1]==value else 0]u8,
   [100-73 when digits[73 when len(digits)>73 else len(digits)-1]==value else 0]u8,
   [100-74 when digits[74 when len(digits)>74 else len(digits)-1]==value else 0]u8,
   [100-75 when digits[75 when len(digits)>75 else len(digits)-1]==value else 0]u8,
   [100-76 when digits[76 when len(digits)>76 else len(digits)-1]==value else 0]u8,
   [100-77 when digits[77 when len(digits)>77 else len(digits)-1]==value else 0]u8,
   [100-78 when digits[78 when len(digits)>78 else len(digits)-1]==value else 0]u8,
   [100-79 when digits[79 when len(digits)>79 else len(digits)-1]==value else 0]u8,
   [100-80 when digits[80 when len(digits)>80 else len(digits)-1]==value else 0]u8,
   [100-81 when digits[81 when len(digits)>81 else len(digits)-1]==value else 0]u8,
   [100-82 when digits[82 when len(digits)>82 else len(digits)-1]==value else 0]u8,
   [100-83 when digits[83 when len(digits)>83 else len(digits)-1]==value else 0]u8,
   [100-84 when digits[84 when len(digits)>84 else len(digits)-1]==value else 0]u8,
   [100-85 when digits[85 when len(digits)>85 else len(digits)-1]==value else 0]u8,
   [100-86 when digits[86 when len(digits)>86 else len(digits)-1]==value else 0]u8,
   [100-87 when digits[87 when len(digits)>87 else len(digits)-1]==value else 0]u8,
   [100-88 when digits[88 when len(digits)>88 else len(digits)-1]==value else 0]u8,
   [100-89 when digits[89 when len(digits)>89 else len(digits)-1]==value else 0]u8,
   [100-90 when digits[90 when len(digits)>90 else len(digits)-1]==value else 0]u8,
   [100-91 when digits[91 when len(digits)>91 else len(digits)-1]==value else 0]u8,
   [100-92 when digits[92 when len(digits)>92 else len(digits)-1]==value else 0]u8,
   [100-93 when digits[93 when len(digits)>93 else len(digits)-1]==value else 0]u8,
   [100-94 when digits[94 when len(digits)>94 else len(digits)-1]==value else 0]u8,
   [100-95 when digits[95 when len(digits)>95 else len(digits)-1]==value else 0]u8,
   [100-96 when digits[96 when len(digits)>96 else len(digits)-1]==value else 0]u8,
   [100-97 when digits[97 when len(digits)>97 else len(digits)-1]==value else 0]u8,
   [100-98 when digits[98 when len(digits)>98 else len(digits)-1]==value else 0]u8,
   [100-99 when digits[99 when len(digits)>99 else len(digits)-1]==value else 0]u8
}
