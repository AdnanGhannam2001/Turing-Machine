input: '',
blank: 0,
start: A,
table:
{
  A:
  [
    { symbol: 0, write: 1, R: B },
    { symbol: 1, L: B }
  ],
  B:
  [
    { symbol: 0, write: 1, L: A },
    { symbol: 1, write: 0, L: C }
  ],
  C:
  [
    { symbol: 0, write: 1, R: H },
    { symbol: 1, L: D }
  ],
  D:
  [
    { symbol: 0, write: 1, R: D },
    { symbol: 1, write: 0, R: A}
  ],
  H: []
}