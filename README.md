# Turing Machine in OCaml

A [Turing Machine](https://en.wikipedia.org/wiki/Turing_machine) interpreter built using [OCaml (A Functional Programming Language)](https://ocaml.org/), with a parser to parse the custom syntax that is used to define input & rules for the machine

## Quick Start

```console
$ dune build --profile release
$ dune exec turing_machine <input_file>
```

## Grammer

```
program    -> (program' ",")* (program')?
program'   -> input | blank | start | limit | table 
input      -> "input" ":" NAME
blank      -> "blank" ":" NAME
start      -> "start" ":" NAME
limit      -> "limit" ":" NAME
table      -> "table" ":" table_body
table_body -> "{" (state ",")* (state)? "}"
state      -> NAME ":" "[" (rule ",")* (rule)? "]"
rule       -> "{" NAME ":" NAME "}"
```

## Examples

All the examples in the examples directory are taken from [here](https://turingmachine.io)

### Example 1 (Repeat 1s 0s)

```console
$ dune exec turing_machine ./examples/repeat1s0s.tu

Input = ``,     Final state = `b`,      Output = `0 1 0 1 0 1 0 1 0 1 `
```

### Example 2 (Binary Increment)

```console
$ dune exec turing_machine ./examples/binary-increment.tu 

Input = `1011`, Final state = `done`,	Output = `1100 `
```

### Example 3 (Palindrome)

```console
$ dune exec turing_machine ./examples/palindrome.tu 

Input = `abba`, Final state = `accept`,	Output = `     `
```

### Example 4 (3 State Busy Beaver)

```console
$ dune exec turing_machine ./examples/3-state-busy-beaver.tu 

Input = ``,     Final state = `H`,      Output = `111111`
```
