open Turing_machine.Tokenizer
open Turing_machine.Parser
open Turing_machine.Interpreter

let read_file filename =
  let chl = open_in filename in
  let content = chl |> in_channel_length |> really_input_string chl in
  close_in chl ; content
;;

let () =
  if Array.length Sys.argv <> 2 then
    Printf.sprintf "Expected file name as the first argument" |> failwith
  else
    Sys.argv.(1) |> read_file |> scan |> parse |> interpret |> print_endline
;;
