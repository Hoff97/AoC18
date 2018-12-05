open Printf
open String
open Char

let file = "input.txt"

let inverse (c1: char) (c2: char) =
  (((uppercase c1) <> c1) && (lowercase c2 <> c2) && (lowercase c2 = c1) || (lowercase c1 <> c1 && uppercase c2 <> c2 && uppercase c2 = c1))

let rec iterate (s: string) (i: int): string =
  if i < length s - 1
  then
    let c1 = get s i in
    let c2 = get s (i+1) in
    if inverse c1 c2 then iterate (sub s 0 i ^ sub s (i+2) (length s-i-2)) 0 else iterate s (i+1)
  else s

let rec removeChar (s: string) (c: char) (i: int): string = if i < length s
  then
    if get s i = c || lowercase (get s i) = c then removeChar (sub s 0 i ^ sub s (i+1) (length s-i-1)) c i else removeChar s c (i+1)
  else s

let d (s: string) (c: char) = 
  let r = removeChar s c 0 in
  let a = length (iterate r 0) in
  a

let rec min_list l =
    match l with 
      | [] -> 100000000
      | x::xs -> min x (min_list xs)

let () =
  let ic = open_in file in
  try
    let line = input_line ic in  (* read line from in_channel and discard \n *)
    let chars = ['a';'b';'c';'d';'e';'f';'g';'h';'i';'j';'k';'l';'m';'n';'o';'p';'q';'r';'s';'t';'u';'v';'w';'x';'y';'z'] in
    print_int (min_list (List.map (d line) chars));
    close_in ic                  (* close the input channel *) 
  with e ->                      (* some unexpected exception occurs *)
    close_in_noerr ic;           (* emergency closing *)
    raise e
