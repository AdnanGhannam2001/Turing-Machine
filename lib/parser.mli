open Tokenizer

type symbol = string

and tape = symbol list

and direction = Left | Right | None

and state_name = string

and rule =
  { current_symbol: symbol
  ; write_symbol: symbol option
  ; direction: direction
  ; next_state: state_name }

and state = {name: state_name; rules: rule list}

and states = state list

and parser_state = {tokens: token list; current: int}

and program =
  { input: string
  ; start: string
  ; blank: string
  ; limit: int
  ; table: states }

val parse : token list -> program