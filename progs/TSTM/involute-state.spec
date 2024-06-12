Rules =
 '((1 . (SLASH . (Right . 2))) . //next
 ((2 . (1 .     (0     . 3))) . //toggle 1
   nil))


//Simple involution
//Two rules define the rest:
//(1 . (SLASH . (Right . 2))) . //next
//(2 . (1 .     (0     . 3))) //toggle 1
//Since initial involuted must equal end, we have 1 <-> 4 and 2 <-> 3 thus
//(2 . (SLASH . (Left . 3))) . //prev (involuted next)
//(2 . (1 .     (0     . 3))) //toggle 2 (involuted toggle 1)

Involution =
 '((1 . 4) .
  ((2 . 3) .
   nil))
