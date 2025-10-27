; file	puts02.asm   target ATmega128L-4MHz-STK300	
; purose display an ASCII string
.include "macros.asm"
.include "definitions.asm"
.include "lcd.asm"
;.include "printf.asm"

reset:
	LDSP	RAMEND
	rcall	LCD_init
	OUTI	DDRD, 0x00
	rjmp	main


main:
	ldi b0, 0x00	
	;ldi	r16,str0
	ldi	zl, low(0x0190)	; load pointer to string
	ldi	zh, high(0x0190)
	rcall	LCD_putstring	; display string
	rcall LCD_lf
	;ldi r16,str1
	ldi zl, low(0x1f4)
	ldi zh, high(0x1f4)
	rcall LCD_putstring
attente:
	sbis PIND, 6
	rjmp select_lvl
	sbis PIND, 5
	rjmp select_sound
	sbis PIND, 4 
	rjmp select_lvl
	rjmp attente

select_lvl:
	rcall LCD_init
	ldi r16,str2
	ldi zl, low(0x1b0)
	ldi zh, high(0x1b0)
	rcall LCD_putstring
bouclewait:
	sbis PIND, 7
	rjmp reset
	rjmp bouclewait

select_sound:
	rjmp reset


LCD_putstring:
; in	z 
	lpm 			; load program memory into r0
	tst	 r0		; test for end of string
	breq done		 
	mov	 a0, r0	; load argument
	rcall	LCD_putc
	adiw	zl, 1 		; increase pointer address
	rjmp	LCD_putstring 		; restart until end of string
done:	ret

.org 2000
str0:
.db	"HOMEMADE   MARIO",0

.org 250
str1:
.db	"6:LVL 5:SON 4:GO",0

.org 216
str2:
.db	"SELECT LVL:",0

.org 232
str3:
.db "SON:",0