''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
'' Test RC decay measurements on two circuits concurrently with fixed pauses removed
'' and polling that waits for both measurements to complete.  Displays number of
'' measurements taken to demonstrate that it takes very little time to take two
'' concurrent RC measurements and transmit the display of those measurements
'' to the Parallax Serial Terminal.

CON
   
  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000

OBJ
   
  pst : "Parallax Serial Terminal"           ' Use with Parallax Serial Terminal to
                                             ' display values 
   
PUB Init

  ' Starts Parallax Serial Terminal; waits 1 s for you to click Enable button.

  pst.Start(115_200)

  ' Configure counter modules.

  ctra[30..26] := %01000                     ' Set CTRA mode to "POS detector"
  ctra[5..0] := 17                           ' Set APIN to 17 (P17)
  frqa := 1                                  ' Increment phsa by 1 for each clock tick

  ctrb[30..26] := %01000                     ' Set CTRB mode to "POS detector"
  ctrb[5..0] := 25                           ' Set APIN to 25 (P25)
  frqb := 1                                  ' Increment phsb by 1 for each clock tick

  main                                       ' Call the Main method

PUB Main | time[2], repscnt

'' Repeatedly takes and displays P17 RC decay measurements.

  repscnt~                                   ' Clear repetitions count                                 

  repeat

     ' Charge RC circuits.

     dira[17] := outa[17] := 1               ' Set P17 to output-high
     dira[25] := outa[25] := 1               ' Set P25 to output-high
     waitcnt(clkfreq/10_000 + cnt)           ' Wait for circuit to charge
      
     ' Start RC decay measurements...

     phsa~                                   ' Clear the phsa register
     dira[17]~                               ' Pin to input stops charging circuit
     phsb~                                   ' Clear the phsb register
     dira[25]~                               ' Pin to input stops charging circuit

     ' Poll until both measurements are done.  Then, adjust ticks between phsa~
     ' and dira[17]~ as well as phsb~ and dira[25]~.

     repeat until ina[17] == 0 and ina[25] == 0
 
     time[0] := (phsa - 624) #> 0                
     time[1] := (phsb - 624) #> 0                
     
     ' Display Results including the number of measurements taken and displayed.                                  

     pst.Str(String(pst#NL, "time[0] = "))
     pst.Dec(time[0])
     pst.Str(String(pst#NL, "time[1] = "))
     pst.Dec(time[1])
     repscnt++
     pst.Str(String(pst#NL, "repscnt = "))
     pst.Dec(repscnt)
     pst.NewLine                 
'     waitcnt(clkfreq/2 + cnt)