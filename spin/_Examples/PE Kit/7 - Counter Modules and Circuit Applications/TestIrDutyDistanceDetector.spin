''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
'' TestIrDutyDistanceDetector.spin
'' Test distance detection with IrDetector object.

CON

  _xinfreq = 5_000_000                      
  _clkmode = xtal1 + pll16x

OBJ

  ir     : "IrDetector"
  pst    : "Parallax Serial Terminal"
  

PUB TestIr | dist
  ' Starts Parallax Serial Terminal; waits 1 s for you to click Enable button.

  pst.Start(115_200)

  pst.Clear
  pst.Str(string("Distance = "))
  'Configure IR detectors.
  ir.init(1, 2, 0)                   

  repeat            
    'Get and display distance.
    pst.Str(string(pst#PX, 11))
    dist := ir.Distance
    pst.Dec(dist)
    pst.Str(string("/256", pst#CE))
    waitcnt(clkfreq/3 + cnt)
