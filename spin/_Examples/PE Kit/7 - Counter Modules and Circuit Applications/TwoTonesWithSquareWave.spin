''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
''TwoTonesWithSquareWave.spin
''Play individual notes with each piezospeaker, then play notes with both at the
''same time.

CON
   
  _clkmode = xtal1 + pll16x               ' System clock → 80 MHz
  _xinfreq = 5_000_000

OBJ

  SqrWave : "SquareWave"


PUB PlayTones | index, pin, duration

  'Look tones and durations in DAT section and play them.
  repeat index from 0 to 4
    SqrWave.Freq(0, 27, word[@Anotes][index])
    SqrWave.Freq(1, 3, word[@Bnotes][index])
    duration := clkfreq/(byte[@durations][index])
    waitcnt(duration + cnt)  

DAT
  pins       byte  27, 3

  'index           0        1        2        3        4 
  durations  byte  1,       2,       1,       2,       1
  anotes     word  1047,    0,       0,       0,       1047
  bnotes     word  0,       0,       1319,    0,       1319