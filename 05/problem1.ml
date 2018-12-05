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

let () =
  let ic = open_in file in
  try
    let line = input_line ic in  (* read line from in_channel and discard \n *)
    print_int (length (iterate line 0));
    close_in ic                  (* close the input channel *) 
  with e ->                      (* some unexpected exception occurs *)
    close_in_noerr ic;           (* emergency closing *)
    raise e
