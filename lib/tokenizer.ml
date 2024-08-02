type token_type =
  | Left_Braces (* { *)
  | Right_Braces (* } *)
  | Left_Square_Brackets (* [ *)
  | Right_Square_Brackets (* ] *)
  | Colon
  | Comma
  | Name of string
  | Eof

and position = {start_col: int; end_col: int; line: int; index: int}

and token = {position: position; t: token_type}

let token_type_of_string (t : token_type) : string =
  match t with
  | Left_Braces -> "{"
  | Right_Braces -> "}"
  | Left_Square_Brackets -> "["
  | Right_Square_Brackets -> "]"
  | Colon -> ":"
  | Comma -> ","
  | Name str -> Printf.sprintf "Name: '%s'" str
  | Eof -> "End of File"
;;

let token_of_string (token : token) : string =
  Printf.sprintf "\"%s\" at: line %d, column: %d-%d"
    (token_type_of_string token.t)
    token.position.line token.position.start_col token.position.end_col
;;

let advance_block (position : position) (length : int) : position =
  { position with
    index= position.index
  ; start_col= position.end_col
  ; end_col= position.end_col + length }
;;

let advance_char (position : position) : position =
  { position with
    index= position.index + 1
  ; start_col= position.end_col
  ; end_col= position.end_col + 1 }
;;

let new_line (position : position) : position =
  { line= position.line + 1
  ; index= position.index + 1
  ; start_col= 0
  ; end_col= 0 }
;;

let is_digit (c : char) : bool = c >= '0' && c <= '9'

and is_alpha (c : char) : bool =
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
;;

let ( @@ ) (str : string) (c : char) : string = String.make 1 c |> ( ^ ) str

let scan (content : string) : token list =
  let next_char (i : int) : char option =
    if i < String.length content then Some content.[i] else None
  in
  let rec scan_string_literal (opening : char) (position : position)
      (acc : string) =
    match next_char position.index with
    | None | Some '\n' ->
        failwith "expected a `closing quote` after an opening one"
    | Some c when c = opening ->
        (advance_block position (String.length acc), acc)
    | Some c ->
        acc @@ c
        |> scan_string_literal opening
             {position with index= position.index + 1}
  in
  let rec scan_alpha_numeric (position : position) (acc : string) =
    match next_char position.index with
    | None | Some '\n' -> (advance_block position (String.length acc), acc)
    | Some c when is_digit c || is_alpha c ->
        acc @@ c
        |> scan_alpha_numeric {position with index= position.index + 1}
    | Some _ -> (advance_block position (String.length acc), acc)
  in
  let rec scan' (position : position) (tokens : token list) =
    match next_char position.index with
    | None -> List.rev tokens
    | Some c -> (
        let advanced = advance_char position in
        match c with
        | ' ' | '\t' -> tokens |> scan' advanced
        | '\n' -> tokens |> scan' (new_line position)
        | '{' ->
            {position= advanced; t= Left_Braces} :: tokens |> scan' advanced
        | '}' ->
            {position= advanced; t= Right_Braces} :: tokens |> scan' advanced
        | '[' ->
            {position= advanced; t= Left_Square_Brackets} :: tokens
            |> scan' advanced
        | ']' ->
            {position= advanced; t= Right_Square_Brackets} :: tokens
            |> scan' advanced
        | ':' -> {position= advanced; t= Colon} :: tokens |> scan' advanced
        | ',' -> {position= advanced; t= Comma} :: tokens |> scan' advanced
        | ('\'' | '"') as opening ->
            let position, str = scan_string_literal opening advanced "" in
            let position = advance_char position in
            {position; t= Name str} :: tokens |> scan' position
        | c when is_alpha c || is_digit c ->
            let position, str = scan_alpha_numeric position "" in
            {position; t= Name str} :: tokens |> scan' position
        | c -> Printf.sprintf "Unexpected char '%c'" c |> failwith )
  in
  scan' {start_col= 0; end_col= 0; line= 1; index= 0} []
;;
