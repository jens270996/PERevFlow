(Start End Rules) -> (Start End Rules RulesRev Q1' Q2' S1' S2')
with (Q Q1 Q2 S1 S2 Rule Rule' S)

init: entry
      S <- 'BLANK
      Q ^= Start
      goto loop

stop: from done
      'BLANK <- S
      Q ^= End
      exit

done: from loop
      goto stop

loop: fi !RulesRev && Q = Start from init else putInRev
    if !Rules goto done else pickTransition

pickTransition: from loop
    ((Q1 . (S1 . (S2 . Q2))) . Rules) <- Rules
    if Q = Q1 && (S1 = S || S1 = 'SLASH) goto setMatch else putInRev

putInRev: fi Q1 = Q1' && Q2 = Q2' && S1 = S1' && S2 = S2' from setMatch else pickTransition
      RulesRev <- ((Q1 . (S1 . (S2 . Q2))) . RulesRev)
      goto loop

setMatch: from pickTransition
      Rule <- (Q1 . (S1 . (S2 . Q2)))
      Rule' ^= Rule
      (Q1' . (S1' . (S2' . Q2')))<- Rule'
      (Q1 . (S1 . (S2 . Q2))) <- Rule
      goto putInRev