input :: [[Int]]
input = [
   [7, 6, 4, 2, 1],
   [1, 2, 7, 8, 9],
   [9, 7, 6, 2, 1],
   [1, 3, 2, 4, 5],
   [8, 6, 4, 4, 1],
   [1, 3, 6, 7, 9]]

diffcheck :: Int -> Int -> [Int] -> Bool
diffcheck lower upper [] = True
diffcheck lower upper [_] = True
diffcheck lower upper (first : second : rest) = (lower <= (second - first)) && ((second - first) <= upper) && (diffcheck lower upper (second : rest))

check1 :: [Int] -> Bool
check1 list = (diffcheck (-3) (-1) list) || (diffcheck 1 3 list)

check2 :: [Int] -> [Int] -> Bool
check2 used [] = check1 used
check2 used (first:rest) = (check1 (used ++ rest)) || (check2 (used ++ [first]) rest)

check2wrapper :: [Int] -> Bool
check2wrapper list = check2 [] list

call :: ([Int] -> Bool) -> [[Int]] -> Int
call func [] = 0
call func (first : rest) = (if (func first) then 1 else 0) + (call func rest)

main :: IO ()
main = do
   print input
   print (call check1 input)
   print (call check2wrapper input)
