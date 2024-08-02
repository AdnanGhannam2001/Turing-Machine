open Tokenizer

type symbol = string

and state_name = string

and tape = symbol list

and direction = Left | Right | None

and rule =
  { current_symbol: symbol
  ; write_symbol: symbol option
  ; direction: direction
  ; next_state: state_name }

and state = {name: state_name; rules: rule list}

and states = state list

and parser_state = {tokens: token list; current: int}

and program =
  {input: string; start: string; blank: string; limit: int; table: states}

let current_token (state : parser_state) : token =
  try List.nth state.tokens state.current
  with Failure _ ->
    token_type_of_string Eof
    |> Printf.sprintf "Expected a token, found '%s'"
    |> failwith
;;

let current_token_opt (state : parser_state) : token option =
  List.nth_opt state.tokens state.current
;;

let consume (state : parser_state) (expected_token : token_type) :
    parser_state =
  match current_token state with
  | token when token.t = expected_token ->
      {state with current= state.current + 1}
  | _ ->
      current_token state |> token_of_string
      |> Printf.sprintf "Expected `%s`, found %s"
           (token_type_of_string expected_token)
      |> failwith

and consume_next (state : parser_state) : parser_state =
  {state with current= state.current + 1}
;;

let check_duplicate (key : string) (defined : string list) : unit =
  if List.exists (fun item -> item = key) defined then
    Printf.sprintf "`%s` is already defined" key |> failwith
;;

let parse (tokens : token list) : program =
  let parse_key_value (key : string) (state : parser_state) :
      parser_state * string =
    let state = consume_next state in
    let state = consume state Colon in
    let current = current_token state in
    match current.t with
    | Name str ->
        let state = consume_next state in
        (state, str)
    | _ ->
        current |> token_of_string
        |> Printf.sprintf "Expected name after `%s`, found %s" key
        |> failwith
  in
  let rec parse_rule_values (state : parser_state) (rule : rule) =
    let current = current_token_opt state in
    match current with
    | None -> (state, rule)
    | Some token -> (
      match token.t with
      | Name str -> (
          let state, value = parse_key_value str state in
          let state =
            let current = current_token_opt state in
            if
              Option.is_some current && (Option.get current).t = Right_Braces
            then state
            else consume state Comma
          in
          match str with
          | "symbol" ->
              parse_rule_values state {rule with current_symbol= value}
          | "write" ->
              parse_rule_values state {rule with write_symbol= Some value}
          | "R" ->
              parse_rule_values state
                {rule with direction= Right; next_state= value}
          | "L" ->
              parse_rule_values state
                {rule with direction= Left; next_state= value}
          | str -> Printf.sprintf "Unknown Key %s" str |> failwith )
      | _ -> (state, rule) )
  in
  let parse_rule (state : parser_state) : parser_state * rule =
    let rule =
      { current_symbol= ""
      ; write_symbol= None
      ; direction= None
      ; next_state= "" }
    in
    let state = consume state Left_Braces in
    let state, rule = parse_rule_values state rule in
    let state = consume state Right_Braces in
    (state, rule)
  in
  let rec parse_rules (state : parser_state) (acc : rule list) :
      parser_state * rule list =
    let current = current_token state in
    match current.t with
    | Left_Braces ->
        let state, rule = parse_rule state in
        let state =
          let current = current_token_opt state in
          if
            Option.is_some current
            && (Option.get current).t = Right_Square_Brackets
          then state
          else consume state Comma
        in
        rule :: acc |> parse_rules state
    | Right_Square_Brackets -> (state, acc)
    | _ ->
        current |> token_of_string
        |> Printf.sprintf "Expected rule in `state`, found %s"
        |> failwith
  in
  let parse_state (name : string) (state : parser_state) (program : program)
      : parser_state * program =
    let state = consume_next state in
    let state = consume state Colon in
    let state = consume state Left_Square_Brackets in
    let state, rules = parse_rules state [] in
    let state = consume state Right_Square_Brackets in
    (state, {program with table= {name; rules} :: program.table})
  in
  let rec parse_states (state : parser_state) (program : program) :
      parser_state * program =
    let current = current_token state in
    match current.t with
    | Name str ->
        let state, program = parse_state str state program in
        let state =
          let current = current_token_opt state in
          if Option.is_some current && (Option.get current).t = Right_Braces
          then state
          else consume state Comma
        in
        parse_states state program
    | Right_Braces -> (state, program)
    | _ ->
        current |> token_of_string
        |> Printf.sprintf "Expected rules after `state`, found %s"
        |> failwith
  in
  let parse_table (state : parser_state) (program : program) :
      parser_state * program =
    let state = consume_next state in
    let state = consume state Colon in
    let state = consume state Left_Braces in
    let state, program = parse_states state program in
    let state = consume state Right_Braces in
    (state, program)
  in
  let rec parse' (state : parser_state) (program : program)
      (defined : string list) =
    let current = current_token_opt state in
    match current with
    | None -> program
    | Some token -> (
      match token.t with
      | Name ("table" as name) ->
          check_duplicate name defined ;
          let state, program = parse_table state program in
          let state =
            if current_token_opt state <> None then consume state Comma
            else state
          in
          name :: defined |> parse' state program
      | Name name -> (
          let state, value = parse_key_value name state in
          let state =
            if current_token_opt state <> None then consume state Comma
            else state
          in
          match name with
          | "input" ->
              check_duplicate name defined ;
              name :: defined |> parse' state {program with input= value}
          | "start" ->
              check_duplicate name defined ;
              name :: defined |> parse' state {program with start= value}
          | "blank" ->
              check_duplicate name defined ;
              name :: defined |> parse' state {program with blank= value}
          | "limit" ->
              check_duplicate name defined ;
              let limit =
                try int_of_string value
                with Failure _ -> failwith "'limit' should be a number"
              in
              name :: defined |> parse' state {program with limit}
          | str -> Printf.sprintf "Unexpected name `%s`" str |> failwith )
      | t ->
          token_type_of_string t
          |> Printf.sprintf "Expected a name, found `%s`"
          |> failwith )
  in
  let state = {tokens; current= 0} in
  let program =
    {input= ""; start= "start"; blank= " "; limit= -1; table= []}
  in
  parse' state program []
;;
