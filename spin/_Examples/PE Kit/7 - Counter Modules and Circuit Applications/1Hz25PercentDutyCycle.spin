''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
''1Hz25PercentDutyCycle.spin
''Send 1 Hz signal at 25 % duty cycle to P4 LED.

CON
   
  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000

PUB TestPwm | tc, tHa, t

  ctra[30..26] := %00100                     ' Configure Counter A to NCO
  ctra[5..0] := 4
  frqa := 1
  dira[4]~~

  tC := clkfreq                              ' Set up cycle and high times
  tHa := clkfreq/4
  t := cnt                                   ' Mark counter time
  
  repeat                                     ' Repeat PWM signal
    phsa := -tHa                             ' Set up the pulse
    t += tC                                  ' Calculate next cycle repeat
    waitcnt(t)                               ' Wait for next cycle