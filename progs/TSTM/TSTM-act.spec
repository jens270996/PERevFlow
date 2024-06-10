// Checks if act correctly applies valid transition
//
Start = '3
End = '3
RulesRev =
 '((1 . (BLANK . (BLANK . 2))) .
  ((2 . (SLASH . (RIGHT . 3))) .
  ((3 . (0 .     (1     . 2))) .
  ((3 . (1 .     (0     . 2))) .
  ((3 . (BLANK . (1 . 4))) .
  ((4 . (SLASH . (LEFT  . 5))) .
  ((5 . (0 .     (0     . 4))) .
  ((5 . (1 .     (1     . 4))) .
  ((5 . (BLANK . (BLANK . 6))) .
   nil)))))))))
Q1' ='3
Q2'='4
S1'='BLANK
S2'='1
Rules = 'nil


// Tape for full specialization
S_right = '(1 . (0 . (1 . nil)))
S = 'BLANK
Q = '3