input: '01001#01001',
blank: ' ',
start: start,
table:
{
  start:
  [
    { symbol: 0, write: ' ', R: have0 },
    { symbol: 1, write: ' ', R: have1 },
    { symbol: '#', R: check }
  ],
  have0:
  [
    { symbol: 0, R: have0 },
    { symbol: 1, R: have0 },
    { symbol: '#', R: match0 }
  ],
  have1:
  [
    { symbol: 0, R: have1 },
    { symbol: 1, R: have1 },
    { symbol: '#', R: match1 }
  ],
  match0:
  [
    { symbol: x, R: match0 },
    { symbol: 0, write: x, L: back },
    { symbol: 1, write: x, L: reject }
  ],
  match1:
  [
    { symbol: x, R: match1 },
    { symbol: 1, write: x, L: back },
    { symbol: 0, write: x, L: reject }
  ],
  back:
  [
    { symbol: 0, L: back },
    { symbol: 1, L: back },
    { symbol: '#', L: back },
    { symbol: x, L: back },
    { symbol: ' ', R: start }
  ],
  check:
  [
    { symbol: x, R: check },
    { symbol: ' ', R: accept },
    { symbol: 0, R: reject },
    { symbol: 1, R: reject }
  ],
  accept: [],
  reject: []
}