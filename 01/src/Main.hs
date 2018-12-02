module Main where

import Data.Set (Set,empty,insert,member)

part1 :: String -> Int
part1 = sum . map (read :: String -> Int) . map (filter (/= '+')) . filter (\x -> length x > 0) . lines

part2 :: String -> Int
part2 = searchFirst (0,empty)
  . map (read . filter (/= '+')) . filter (\x -> length x > 0) . lines

searchFirst :: (Int,Set Int) -> [Int] -> Int
searchFirst (x,y) (a:as) = if next `member` (insert x y) then next else searchFirst (next,insert x y) (as ++ [a])
  where
    next = a+x

main :: IO ()
main = do
  input <- readFile "input.txt"
  let solution1 = part1 input
  let solution2 = part2 input
  print solution1
  print solution2
