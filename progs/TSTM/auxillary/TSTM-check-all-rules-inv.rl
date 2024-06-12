(Start End Rules RulesRev Q1' Q2' S1' S2') -> (Start End Rules) with (Q Q1 Q2 S1 S2 Rule Rule' S)

init:
	from loop
	Q ^= Start
	'BLANK <- S
	exit

stop:
	entry
	Q ^= End
	S <- 'BLANK
	goto done

done:
	from stop
	goto loop

loop:
	fi !(Rules)
		from done
		else pickTransition
	if (!(RulesRev) && (Q = Start))
		goto init
		else putInRev

pickTransition:
	fi ((Q = Q1) && ((S1 = S) || (S1 = 'SLASH)))
		from setMatch
		else putInRev
	Rules <- ((Q1 . (S1 . (S2 . Q2))) . Rules)
	goto loop

putInRev:
	from loop
	((Q1 . (S1 . (S2 . Q2))) . RulesRev) <- RulesRev
	if ((((Q1 = Q1') && (Q2 = Q2')) && (S1 = S1')) && (S2 = S2'))
		goto setMatch
		else pickTransition

setMatch:
	from putInRev
	Rule <- (Q1 . (S1 . (S2 . Q2)))
	Rule' <- (Q1' . (S1' . (S2' . Q2')))
	Rule' ^= Rule
	(Q1 . (S1 . (S2 . Q2))) <- Rule
	goto pickTransition
