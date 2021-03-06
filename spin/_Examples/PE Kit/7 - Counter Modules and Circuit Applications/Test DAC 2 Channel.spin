''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
''Test DAC 2 Channel.spin
''2 channel DAC.

OBJ

  dac : "DAC 2 Channel"

PUB TestDuty | level

  dac.Init(0, 4, 8, 0)               ' Ch0, P4, 8-bit DAC, starts at 0 V
  dac.Init(1, 5, 7, 64)              ' Ch1, P5, 7-bit DAC, starts at 1.65 V

  repeat
    repeat level from 0 to 256
      dac.Update(0, level)
      dac.Update(1, level + 64)      ' DAC output automatically truncated to 128
      waitcnt(clkfreq/100 + cnt)