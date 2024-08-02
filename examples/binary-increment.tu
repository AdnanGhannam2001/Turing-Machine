input: '1011',
blank: ' ',
start: right,
table:
{
  right:
  [
    { symbol: 1, R: right },
    { symbol: 0, R: right },
    { symbol: ' ', L: carry }
  ],
  carry:
  [
    { symbol: 1, write: 0, L: carry },
    { symbol: 0, write: 1, L: done },
    { symbol: ' ', write: 1, L: done }
  ],
  done: []
}