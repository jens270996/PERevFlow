(Start End Rules S_right Involution) -> (Start End Rules S_right Involution)
with (Q Q1 Q2 S1 S2 Q1' Q2' S1' S2' Rule Rule' S S_left RulesRev RulesOut InvolutionRev From To Q1_ Q2_ S1_ S2_)

init: entry
      S <- 'BLANK
      Q ^= Start
      goto loop

stop: from loop
      'BLANK <- S
      Q ^= End
      exit




// FIND MATCHING RULE
loop: fi Q = Start from init else cleanup2
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
      goto involuteRules

involuteRules: from foundRule
      (RulesRev . Rules) <- (Rules . RulesRev)
      goto invol_init

involuteRulesDone: from invol_done
      goto matchRule1



// FIND MATCHING INVOLUTED RULE

matchRule1: fi !RulesRev from involuteRulesDone else putInRev1
    if !Rules goto foundRule1 else pickTransition1

pickTransition1: from matchRule1
    ((Q1 . (S1 . (S2 . Q2))) . Rules) <- Rules
    if Q = Q1 && (S1 = S || S1 = 'SLASH) goto setMatch1 else putInRev1

putInRev1: fi Q1 = Q1' && Q2 = Q2' && S1 = S1' && S2 = S2' from setMatch1 else pickTransition1
      RulesRev <- ((Q1 . (S1 . (S2 . Q2))) . RulesRev)
      goto matchRule1

setMatch1: from pickTransition1
      Rule <- (Q1 . (S1 . (S2 . Q2)))
      Rule' ^= Rule
      (Q1' . (S1' . (S2' . Q2')))<- Rule'
      (Q1 . (S1 . (S2 . Q2))) <- Rule
      goto putInRev1

foundRule1: from matchRule1
      goto act



// ACT
act: from foundRule1
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


// CLEANUP 1
cleanup:
	fi !Rules
		from loopEnd
		else pickTransition'
	if !RulesRev
		goto afterCleanup1
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

afterCleanup1:from cleanup
      goto invol1_init

involuteRulesDone1: from invol1_done
      (RulesRev . Rules) <- (Rules . RulesRev)
      goto cleanup2
      

// CLEANUP 2
cleanup2:
	fi !Rules
		from involuteRulesDone1
		else pickTransition'2
	if !RulesRev
		goto loop
		else putInRules2


pickTransition'2:
	fi ((Q = Q2) && ((S2 = S) || (S1 = 'SLASH)))
		from unsetMatch2
		else putInRules2
	Rules <- ((Q1 . (S1 . (S2 . Q2))) . Rules)
	goto cleanup2

putInRules2:
	from cleanup2
	((Q1 . (S1 . (S2 . Q2))) . RulesRev) <- RulesRev
	if ((((Q1 = Q1') && (Q2 = Q2')) && (S1 = S1')) && (S2 = S2'))
		goto unsetMatch2
		else pickTransition'2

unsetMatch2:
	from putInRules2
	Rule <- (Q1 . (S1 . (S2 . Q2)))
	Rule' <- (Q1' . (S1' . (S2' . Q2')))
	Rule' ^= Rule
	(Q1 . (S1 . (S2 . Q2))) <- Rule
	goto pickTransition'2



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














//------------------------- Involute Rules
invol_init: from involuteRules
    goto invol_loop

invol_loop: fi !RulesOut from invol_init else invol_resetsDone
    if !Rules goto invol_done else invol_pickRule

invol_pickRule: from invol_loop
    ((Q1 . (S1 . (S2 . Q2))).Rules) <- Rules
    goto invol_loop1

invol_invertAction: from invol_foundInvolution2
    if S1 = 'SLASH goto invol_invertMove else invol_invertWrite

invol_invertMove: from invol_invertAction
    S1_ <- S1 //maybe pattern match instead?
    if S2 = 'LEFT goto invol_invertLeft else invol_invertRight

invol_invertRight: from invol_invertMove
    'RIGHT <- S2 //Not working for some reason? S2 ^= 'RIGHT instead?
    S2_ <- 'LEFT
    goto invol_invertMove1

invol_invertLeft: from invol_invertMove
    S2_ <- 'RIGHT
    'LEFT <- S2
    goto invol_invertMove1

invol_invertMove1: fi S2_ = 'LEFT from invol_invertRight else invol_invertLeft
    goto invol_invertionDone

invol_invertWrite: from invol_invertAction
    (S1_ . S2_) <- (S2 . S1)
    goto invol_invertionDone

invol_invertionDone: fi S1_ = 'SLASH from invol_invertMove1 else invol_invertWrite
    goto invol_resetQ1AndQ2

invol_resetsDone: from invol_Q2reset
    RulesOut <- ( (Q1_ . (S1_ . (S2_ . Q2_))). RulesOut) // insert involuted rule
    goto invol_loop

invol_done: from invol_loop
    (RulesOut . Rules) <- (Rules . RulesOut)
    goto involuteRulesDone
    //RulesOut contains inverted rules
    //Rules is empty
    //Involution is same as start of call


//--------------------------------------------------------------------------------
//                         PICKS OUT Q1_ and Q2_ does nothing else
//---------------------------------------------------------------------------------

invol_loop1: fi !InvolutionRev from invol_pickRule else invol_putInRev
    if !Involution goto invol_foundInvolution1 else invol_findInvolution1

invol_findInvolution1: from invol_loop1
    ((From . To) . Involution) <- Involution
    if From = Q1 goto invol_setMatch else invol_putInRev

invol_putInRev: fi Q2_ = To from invol_setMatch else invol_findInvolution1
    InvolutionRev <- ((From . To) . InvolutionRev)
    goto invol_loop1

invol_setMatch: from invol_findInvolution1
    Q2_ ^= To
    goto invol_putInRev

invol_foundInvolution1: from invol_loop1
    (Involution . InvolutionRev ) <- (InvolutionRev . Involution)
    goto invol_loop2

invol_loop2: fi !InvolutionRev from invol_foundInvolution1 else invol_putInRev2
    if !Involution goto invol_foundInvolution2 else invol_findInvolution2

invol_findInvolution2: from invol_loop2
    ((From . To) . Involution) <- Involution
    if From = Q2 goto invol_setMatch2 else invol_putInRev2

invol_putInRev2: fi Q1_ = To from invol_setMatch2 else invol_findInvolution2
    InvolutionRev <- ((From . To) . InvolutionRev)
    goto invol_loop2
invol_setMatch2: from invol_findInvolution2
    Q1_ ^= To
    goto invol_putInRev2

invol_foundInvolution2: from invol_loop2
    (Involution . InvolutionRev ) <- (InvolutionRev . Involution)
    //Q1_ contains mapping for Q2
    //Q2_ contains mapping for Q1
    goto invol_invertAction

// ---------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
//                         RESETS OUT Q1 and Q2 does nothing else
//---------------------------------------------------------------------------------
invol_resetQ1AndQ2:from invol_invertionDone
    goto invol_rloop1

invol_rloop1: fi !InvolutionRev from invol_resetQ1AndQ2 else invol_rputInRev
    if !Involution goto invol_Q1reset else invol_findQ1

invol_findQ1: from invol_rloop1
    ((From . To) . Involution) <- Involution
    if To = Q2_ goto invol_unsetMatch else invol_rputInRev

invol_rputInRev: fi To = Q2_ from invol_unsetMatch else invol_findQ1
    InvolutionRev <- ((From . To) . InvolutionRev)
    goto invol_rloop1
invol_unsetMatch: from invol_findQ1
    Q1 ^= From //Resets Q1
    goto invol_rputInRev

invol_Q1reset: from invol_rloop1
    (Involution . InvolutionRev ) <- (InvolutionRev . Involution)
    goto invol_rloop2

invol_rloop2: fi !InvolutionRev from invol_Q1reset else invol_rputInRev2
    if !Involution goto invol_Q2reset else invol_findQ2

invol_findQ2: from invol_rloop2
    ((From . To) . Involution) <- Involution
    if To = Q1_ goto invol_unsetMatch2 else invol_rputInRev2

invol_rputInRev2: fi Q1_ = To from invol_unsetMatch2 else invol_findQ2
    InvolutionRev <- ((From . To) . InvolutionRev)
    goto invol_rloop2
invol_unsetMatch2: from invol_findQ2
    Q2 ^= From //Resets Q2
    goto invol_rputInRev2

invol_Q2reset: from invol_rloop2
    (Involution . InvolutionRev ) <- (InvolutionRev . Involution)
    //Q1' contains mapping for Q2
    //Q2' contains mapping for Q1
    goto invol_resetsDone

// ---------------------------------------------------------------------------------





//------------------------- Involute Rules 2
invol1_init: from afterCleanup1
    goto invol1_loop

invol1_loop: fi !RulesOut from invol1_init else invol1_resetsDone
    if !Rules goto invol1_done else invol1_pickRule

invol1_pickRule: from invol1_loop
    ((Q1 . (S1 . (S2 . Q2))).Rules) <- Rules
    goto invol1_loop1

invol1_invertAction: from invol1_foundInvolution2
    if S1 = 'SLASH goto invol1_invertMove else invol1_invertWrite

invol1_invertMove: from invol1_invertAction
    S1_ <- S1 //maybe pattern match instead?
    if S2 = 'LEFT goto invol1_invertLeft else invol1_invertRight

invol1_invertRight: from invol1_invertMove
    'RIGHT <- S2 //Not working for some reason? S2 ^= 'RIGHT instead?
    S2_ <- 'LEFT
    goto invol1_invertMove1

invol1_invertLeft: from invol1_invertMove
    S2_ <- 'RIGHT
    'LEFT <- S2
    goto invol1_invertMove1

invol1_invertMove1: fi S2_ = 'LEFT from invol1_invertRight else invol1_invertLeft
    goto invol1_invertionDone

invol1_invertWrite: from invol1_invertAction
    (S1_ . S2_) <- (S2 . S1)
    goto invol1_invertionDone

invol1_invertionDone: fi S1_ = 'SLASH from invol1_invertMove1 else invol1_invertWrite
    goto invol1_resetQ1AndQ2

invol1_resetsDone: from invol1_Q2reset
    RulesOut <- ( (Q1_ . (S1_ . (S2_ . Q2_))). RulesOut) // insert involuted rule
    goto invol1_loop

invol1_done: from invol1_loop
    (RulesOut . Rules) <- (Rules . RulesOut)
    goto involuteRulesDone1
    //RulesOut contains inverted rules
    //Rules is empty
    //Involution is same as start of call


//--------------------------------------------------------------------------------
//                         PICKS OUT Q1_ and Q2_ does nothing else
//---------------------------------------------------------------------------------

invol1_loop1: fi !InvolutionRev from invol1_pickRule else invol1_putInRev
    if !Involution goto invol1_foundInvolution1 else invol1_findInvolution1

invol1_findInvolution1: from invol1_loop1
    ((From . To) . Involution) <- Involution
    if From = Q1 goto invol1_setMatch else invol1_putInRev

invol1_putInRev: fi Q2_ = To from invol1_setMatch else invol1_findInvolution1
    InvolutionRev <- ((From . To) . InvolutionRev)
    goto invol1_loop1

invol1_setMatch: from invol1_findInvolution1
    Q2_ ^= To
    goto invol1_putInRev

invol1_foundInvolution1: from invol1_loop1
    (Involution . InvolutionRev ) <- (InvolutionRev . Involution)
    goto invol1_loop2

invol1_loop2: fi !InvolutionRev from invol1_foundInvolution1 else invol1_putInRev2
    if !Involution goto invol1_foundInvolution2 else invol1_findInvolution2

invol1_findInvolution2: from invol1_loop2
    ((From . To) . Involution) <- Involution
    if From = Q2 goto invol1_setMatch2 else invol1_putInRev2

invol1_putInRev2: fi Q1_ = To from invol1_setMatch2 else invol1_findInvolution2
    InvolutionRev <- ((From . To) . InvolutionRev)
    goto invol1_loop2
invol1_setMatch2: from invol1_findInvolution2
    Q1_ ^= To
    goto invol1_putInRev2

invol1_foundInvolution2: from invol1_loop2
    (Involution . InvolutionRev ) <- (InvolutionRev . Involution)
    //Q1_ contains mapping for Q2
    //Q2_ contains mapping for Q1
    goto invol1_invertAction

// ---------------------------------------------------------------------------------


//--------------------------------------------------------------------------------
//                         RESETS OUT Q1 and Q2 does nothing else
//---------------------------------------------------------------------------------
invol1_resetQ1AndQ2:from invol1_invertionDone
    goto invol1_rloop1

invol1_rloop1: fi !InvolutionRev from invol1_resetQ1AndQ2 else invol1_rputInRev
    if !Involution goto invol1_Q1reset else invol1_findQ1

invol1_findQ1: from invol1_rloop1
    ((From . To) . Involution) <- Involution
    if To = Q2_ goto invol1_unsetMatch else invol1_rputInRev

invol1_rputInRev: fi To = Q2_ from invol1_unsetMatch else invol1_findQ1
    InvolutionRev <- ((From . To) . InvolutionRev)
    goto invol1_rloop1
invol1_unsetMatch: from invol1_findQ1
    Q1 ^= From //Resets Q1
    goto invol1_rputInRev

invol1_Q1reset: from invol1_rloop1
    (Involution . InvolutionRev ) <- (InvolutionRev . Involution)
    goto invol1_rloop2

invol1_rloop2: fi !InvolutionRev from invol1_Q1reset else invol1_rputInRev2
    if !Involution goto invol1_Q2reset else invol1_findQ2

invol1_findQ2: from invol1_rloop2
    ((From . To) . Involution) <- Involution
    if To = Q1_ goto invol1_unsetMatch2 else invol1_rputInRev2

invol1_rputInRev2: fi Q1_ = To from invol1_unsetMatch2 else invol1_findQ2
    InvolutionRev <- ((From . To) . InvolutionRev)
    goto invol1_rloop2
invol1_unsetMatch2: from invol1_findQ2
    Q2 ^= From //Resets Q2
    goto invol1_rputInRev2

invol1_Q2reset: from invol1_rloop2
    (Involution . InvolutionRev ) <- (InvolutionRev . Involution)
    //Q1' contains mapping for Q2
    //Q2' contains mapping for Q1
    goto invol1_resetsDone

// ---------------------------------------------------------------------------------
