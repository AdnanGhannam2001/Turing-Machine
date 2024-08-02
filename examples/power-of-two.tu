input: '0000',
blank: ' ',
start: zero,
table:
{
  zero:
  [
    { symbol: 0  , write: ' ', R: one },
    { symbol: ' ', R: reject }
  ],
  one:
  [
    { symbol: 0  , write: x, R: even },
    { symbol: ' ', R: accept },
    { symbol: x  , R: one }
  ],
  even:
  [
    { symbol: 0  , R: odd },
    { symbol: ' ', L: back },
    { symbol: x  , R: even }
  ],
  odd:
  [
    { symbol: 0  , write: x, R: even },
    { symbol: ' ', R: reject },
    { symbol: x  , R: odd }
  ],
  back:
  [
    { symbol: ' ', R: one },
    { symbol: 0, L: back },
    { symbol: x, L: back },
  ],
  accept: [],
  reject: []
}