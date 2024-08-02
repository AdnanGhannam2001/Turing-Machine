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

val token_type_of_string : token_type -> string
val token_of_string : token -> string

val scan : string -> token list
