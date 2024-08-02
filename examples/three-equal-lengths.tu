input: aabbcc,
blank: ' ',
start: qA,
table:
{
  qA:
  [
    { symbol: a, write: A, R: qB },
    { symbol: B, R: scan }
  ],
  qB:
  [
    { symbol: a, R: qB },
    { symbol: B, R: qB },
    { symbol: b, write: B, R: qC }
  ],
  qC:
  [
    { symbol: b, R: qC },
    { symbol: C, R: qC },
    { symbol: c, write: C, L: back }
  ],
  back:
  [
    { symbol: a, L: back },
    { symbol: B, L: back },
    { symbol: b, L: back },
    { symbol: C, L: back },
    { symbol: A, R: qA }
  ],
  scan:
  [
    { symbol: B, R: scan },
    { symbol: C, R: scan },
    { symbol: ' ', R: accept }
  ],
  accept: []
}