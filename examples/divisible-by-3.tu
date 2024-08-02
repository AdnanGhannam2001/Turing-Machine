input: '1001',
start: q0,
table:
{
  q0:
  [
    { symbol: 0, R: q0 },
    { symbol: 1, R: q1 },
    { symbol: ' ', R: accept }
  ],
  q1:
  [
    { symbol: 0, R: q2 },
    { symbol: 1, R: q0 }
  ],
  q2:
  [
    { symbol: 0, R: q1 },
    { symbol: 1, R: q2 }
  ],
  accept: []
}