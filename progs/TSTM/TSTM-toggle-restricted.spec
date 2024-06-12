// Describe the TM
// Flip bit in string (0|1)*
// Example: _1 --> _0
Start = '1
End = '4
Rules =
 '((1 . (SLASH . (RIGHT . 2))) . //next
 ((2 . (1 .     (0     . 3))) . //toggle 1
   nil))


//Simple involution
//Two rules define the rest:
//(1 . (SLASH . (RIGHT . 2))) . //next
//(2 . (1 .     (0     . 3))) //toggle 1
//Since initial involuted must equal end, we have 1 <-> 4 and 2 <-> 3 thus
//(2 . (SLASH . (LEFT . 3))) . //prev (involuted next)
//(2 . (1 .     (0     . 3))) //toggle 2 (involuted toggle 1)

Involution =
 '((1 . 4) .
  ((2 . 3) .
  ((3. 2).
  ((4. 1).
   nil))))


// Tape for full specialization
S_right = '(1 . nil)