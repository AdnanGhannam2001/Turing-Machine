input: 'abba',
blank: ' ',
start: start,
table:
{
  start:
  [
    { symbol: a, write: ' ', R: haveA },
    { symbol: b, write: ' ', R: haveB },
    { symbol: ' ', R: accept }
  ],
  haveA:
  [
    { symbol: a, R: haveA },
    { symbol: b, R: haveA },
    { symbol: ' ', L: matchA }
  ],
  haveB:
  [
    { symbol: a, R: haveB },
    { symbol: b, R: haveB },
    { symbol: ' ', L: matchB }
  ],
  matchA:
  [
    { symbol: a, write: ' ', L: back },
    { symbol: b, R: reject },
    { symbol: ' ', R: accept }
  ],
  matchB:
  [
    { symbol: a, R: reject },
    { symbol: b, write: ' ', L: back },
    { symbol: ' ', R: accept }
  ],
  back:
  [
    { symbol: a, L: back },
    { symbol: b, L: back },
    { symbol: ' ', R: start }
  ],
  accept: [],
  reject: []
}