# Lessons learned
- Managing a Visual Studio Solution with multiple Projects
- Day 1
   - remembering `cctype` takes longer than rewriting anything within
   - regex negative lookbehind is still not supported in most languages (shoutouts to powershell 7)
   - awk is still relevant in 2023
- Day 2
   - `stringstream`s are convenient
- Day 3
   - autoformatting is still broken
   ```cpp
   for(std::array<int,2>d:std::array<std::array<int,2>,8>{
      {
         {
            -1,-1
         },{-1,0},{-1,1},{0,-1},{0,1},{1,-1},{1,0},{1,1}
      }}){
      void;
   }
   ```
   - `using enum` exists
- Day 5
   - start-end slices are much easier to reason with than start-range
- Day 7
   - `algorithm`s are convenient and make adding parallel execution easy
