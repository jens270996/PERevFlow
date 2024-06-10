(Start End Rules S_right) -> (Start End Rules S_right)
with (Q Q1 Q2 S1 S2 Q1' Q2' S1' S2' Rule Rule' S S_left RulesRev)

init: entry
      S <- 'BLANK
      Q ^= Start
      goto loop

stop: from loop
      'BLANK <- S
      Q ^= End
      exit




// FIND MATCHING RULE
loop: fi Q = Start from init else cleanup 
      if Q = End goto stop else matchRule


matchRule: fi !RulesRev from loop else putInRev
    if !Rules goto foundRule else pickTransition

pickTransition: from matchRule
    ((Q1 . (S1 . (S2 . Q2))) . Rules) <- Rules
    if Q = Q1 && (S1 = S || S1 = 'SLASH) goto setMatch else putInRev

putInRev: fi Q1 = Q1' && Q2 = Q2' && S1 = S1' && S2 = S2' from setMatch else pickTransition
      RulesRev <- ((Q1 . (S1 . (S2 . Q2))) . RulesRev)
      goto matchRule

setMatch: from pickTransition
      Rule <- (Q1 . (S1 . (S2 . Q2)))
      Rule' ^= Rule
      (Q1' . (S1' . (S2' . Q2')))<- Rule'
      (Q1 . (S1 . (S2 . Q2))) <- Rule
      goto putInRev

foundRule: from matchRule
      goto act




// ACT
act: from foundRule
      if S1' = 'SLASH goto move else write

write: from act
      Q ^= Q1'
      Q ^= Q2'
      S ^= S1'
      S ^= S2'
      goto loopEnd

move: from act
      Q ^= Q1'
      Q ^= Q2'
      if S2' = 'LEFT goto left else right

loopEnd: fi S1' = 'SLASH from move1 else write
    goto cleanup


// CLEANUP
cleanup:
	fi !(Rules)
		from loopEnd
		else pickTransition'
	if (!(RulesRev))
		goto loop
		else putInRules


pickTransition':
	fi ((Q = Q2) && ((S2 = S) || (S1 = 'SLASH)))
		from unsetMatch
		else putInRules
	Rules <- ((Q1 . (S1 . (S2 . Q2))) . Rules)
	goto cleanup

putInRules:
	from cleanup
	((Q1 . (S1 . (S2 . Q2))) . RulesRev) <- RulesRev
	if ((((Q1 = Q1') && (Q2 = Q2')) && (S1 = S1')) && (S2 = S2'))
		goto unsetMatch
		else pickTransition'

unsetMatch:
	from putInRules
	Rule <- (Q1 . (S1 . (S2 . Q2)))
	Rule' <- (Q1' . (S1' . (S2' . Q2')))
	Rule' ^= Rule
	(Q1 . (S1 . (S2 . Q2))) <- Rule
	goto pickTransition'



// ACT AUXILLARY LABELS
left: from move
      if S_right = 'nil && S = 'BLANK goto left_1b else left_1p

left_1b: from left // MERGE? 1
         S ^= 'BLANK
         goto left1

left_1p: from left
         S_right <- (S . S_right)
         goto left1

left1: fi S_right = 'nil from left_1b else left_1p
       if S_left = 'nil goto left_2b else left_2p

left_2b: from left1 // MERGE? 2
         S ^= 'BLANK
         goto left2

left_2p: from left1
         (S . S_left) <- S_left
         goto left2

left2: fi S_left = 'nil && S = 'BLANK from left_2b else left_2p
       goto move1

right: from move
       if S_left = 'nil && S = 'BLANK goto right_1b else right_1p

right_1b: from right // MERGE? 1
          S ^= 'BLANK
          goto right1

right_1p: from right
          S_left <- (S . S_left)
          goto right1

right1: fi S_left = 'nil from right_1b else right_1p
        if S_right = 'nil goto right_2b else right_2p

right_2b: from right1 // MERGE? 2
          S ^= 'BLANK
          goto right2

right_2p: from right1
          (S . S_right) <- S_right
          goto right2

right2: fi S_right = 'nil && S = 'BLANK from right_2b else right_2p
        goto move1

move1: fi S2' = 'LEFT from left2 else right2
       goto loopEnd