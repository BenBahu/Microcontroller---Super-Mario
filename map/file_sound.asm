/*
 * macros_sound.asm
 *
 *  Created: 28/05/2022 21:09:53
 *   Author: benand
 */ 
 .include "sound.asm"

 .org 0x3000
mario :
	.db do2, do2, do2, do2, so, so, so, so, mi, mi, mi, mi
	.db la, la, la, si, si, si, lam, lam, la, la, la, so
	.db so, so, mi2, mi2, so2, so2, la2, la2, la2, fa2, fa2, so2, so2, so2
	.db mi2, mi2, mi2, do2, do2, re2, re2, si, si, si, si, si
	.db do2, do2, do2, do2, so, so, so, so, mi, mi, mi, mi
	.db la, la, la, si, si, si, lam, lam, la, la, la, so
	.db so, so, mi2, mi2, so2, so2, la2, la2, la2, fa2, fa2, so2, so2, so2
	.db mi2, mi2, mi2, do2, do2, re2, re2, si, si, si, si, si
	.db 0

.org 0x0a50
game_over : 
	.db do3, do3, do3, do3, so2, so2, so2, so2, mi2, mi2, mi2, mi2
	.db la2, la2, si2, si2, la2, la2, som2, som2, lam2, lam2, som2, som2
	.db so2, fa2, so2, so2, so2, so2, so2, so2
	.db 0

.org 0x0a80
level_complete : 
	.db so, si, re2, so2, si2, re3, so3, so3, so3, re3, re3, re3
	.db som, do2, rem2, som2, do3, rem3, som3, som3, som3, rem3, rem3, rem3
	.db lam, re2, fa2, lam2, re3, fa3, lam3, lam3, lam3, lam3, lam3, lam3
	.db do4, do4, do4, do4
	.db 0

.org 0x0ab0
jump : 
	.db si3, mi4
	.db 0

 .macro PLAY_SOUND
    push a0
    push b0
	push a1
	push a2
    ldi zl, low(2*@0)
    ldi zh, high(2*@0)
    lpm
    adiw zl, 1
    tst r0
    breq PC+5
    mov a0, r0
    ldi b0, @1
    call sound
    rjmp PC-7
	pop a2
	pop a1
    pop b0
    pop a0
.endmacro