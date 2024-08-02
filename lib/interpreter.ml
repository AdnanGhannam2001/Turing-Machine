open Parser

let interpret (program : program) =
  let rec interpret' (cursor : int) (tape : tape) (current : state_name)
      (i : int) =
    if program.limit > -1 && i <= 0 then (current, tape)
    else
      let cursor, tape =
        if cursor >= List.length tape then
          (cursor, List.append tape [program.blank])
        else if cursor < 0 then (cursor + 1, program.blank :: tape)
        else (cursor, tape)
      in
      let current_symbol = List.nth tape cursor in
      let state_opt =
        List.find_opt (fun s -> s.name = current) program.table
      in
      match state_opt with
      | None -> Printf.sprintf "Didn't find state %s\n" current |> failwith
      | Some state -> (
          if List.length state.rules = 0 then (current, tape)
          else
            let rule_opt =
              List.find_opt
                (fun rule -> rule.current_symbol = current_symbol)
                state.rules
            in
            match rule_opt with
            | None ->
                Printf.sprintf "Didn't find rule for `%s` in state `%s`"
                  current_symbol current
                |> failwith
            | Some rule ->
                let dir =
                  match rule.direction with
                  | Right -> cursor + 1
                  | Left -> cursor - 1
                  | None -> cursor
                in
                let tape =
                  match rule.write_symbol with
                  | None -> tape
                  | Some write_symbol ->
                      List.mapi
                        (fun i symbol ->
                          if i = cursor then write_symbol else symbol )
                        tape
                in
                i - 1 |> interpret' dir tape rule.next_state )
  in
  let tape : tape =
    String.fold_left
      (fun symbol c -> String.make 1 c :: symbol)
      [] program.input
    |> List.rev
  in
  let current, tape = interpret' 0 tape program.start program.limit in
  tape
  |> List.fold_left (fun acc c -> acc ^ c) ""
  |> Printf.sprintf "Input = `%s`,\tFinal state = `%s`,\tOutput = `%s`" program.input current
;;
