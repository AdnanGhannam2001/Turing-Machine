input: 111,
blank: '0',
start: each,
table:
{
  each:
  [
    { symbol: 0, R: H },
    { symbol: 1, write: 0, R: sep }
  ],
  sep:
  [
    { symbol: 0, R: add },
    { symbol: 1, R: sep }
  ],
  add:
  [
    { symbol: 0, write: 1, L: sepL },
    { symbol: 1, R: add }
  ],
  sepL:
  [
    { symbol: 0, L: next },
    { symbol: 1, L: sepL }
  ],
  next:
  [
    { symbol: 0, write: 1, R: each },
    { symbol: 1, L: next }
  ],
  H: []
}