input: '',
blank: '0',
start: A,
table:
{
  A:
  [
    { symbol: 0, write: 1, R: B },
    { symbol: 1, L: C }
  ],
  B:
  [
    { symbol: 0, write: 1, L: A },
    { symbol: 1, R: B }
  ],
  C:
  [
    { symbol: 0, write: 1, L: B },
    { symbol: 1, R: H }
  ],
  H: []
}