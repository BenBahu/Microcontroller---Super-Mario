; file	ws2812b_4MHz_demo01_S.asm   target ATmega128L-4MHz-STK300
; purpose send data to ws2812b using 4 MHz MCU and standard I/O port
;         display and paralllel process (blinking LED0)
; usage: buttons on PORTC, ws2812 on PORTD (bit 1)
;        press button 0
;       a pattern is stored into memory and displayed on the array
;       LED0 blinks fast; when button0 is pressed and released, LED1
;       akcnowledges and the pattern displayed on the array moves by
;       one memory location
; warnings: 1/2 timings of pulses in the macros are sensitive
;			2/2 intensity of LEDs is high, thus keep intensities
;				within the range 0x00-0x0f, and do not look into
;				LEDs
; 20220315 AxS

.include "macros.asm"		; include macro definitions
.include "definitions.asm"	; include register/constant definitions
.include "macros_map.asm"

; WS2812b4_WR0	; macro ; arg: void; used: void
; purpose: write an active-high zero-pulse to PD1
.macro	WS2812b4_WR0
	clr u
	sbi PORTD, 1
	out PORTD, u
	nop
	nop
	;nop	;deactivated on purpose of respecting timings
	;nop
.endm

; WS2812b4_WR1	; macro ; arg: void; used: void
; purpose: write an active-high one-pulse to PD1
.macro	WS2812b4_WR1
	sbi PORTD, 1
	nop
	nop
	cbi PORTD, 1
	;nop	;deactivated on purpose of respecting timings
	;nop

.endm

; === interrupt table ===

.org 0
	jmp	reset

.org INT7addr
	rjmp ext_int7

; === interrupt service routines ===

ext_int7:
	INVP PORTB, 6
	WAIT_MS 20
	INVP PORTB, 6
	reti

reset:
	LDSP	RAMEND				; Load Stack Pointer (SP)
	rcall	ws2812b4_init		; initialize 
	OUTI	DDRB, 0xff			; connect LEDs to PORTB, output mode
	OUTI	DDRC, 0x00			; connectbuttons to PORTC, input mode
	OUTI	EIMSK, 0b10000000	;enable int0
	OUTI	EICRB, 0b10000000	;so niveau low soit flanc descendant
	_LDI r2, 0x00
	_LDI r8, 0x1c

main:
	; ------ part 1: store image that will be displayed into SRAM
	;ldi	b0,64 ;4 pls = 16 * 4 pls, 17 due to loop condition
	ldi zl,low(0x0400)
	ldi zh,high(0x0400)
	mov r14, zl
	mov r15, zh


;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
imgld_loop:
	
	COLONNE1 a0, 1, 7
	COLONNE1_START a0, 1, 6
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 3, 3, 2
	COLONNE2 a0, 3, 3, 2
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7

	COLONNE1 a0, 2, 6
	COLONNE1 a0, 3, 5
	COLONNE1 a0, 4, 4
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE3 a0, 1, 2, 2, 3
	COLONNE3 a0, 1, 2, 2, 3
	COLONNE1 a0, 1, 7

	COLONNE1 a0, 1, 7
	COLONNE2 a0, 1, 2, 5 
	COLONNE2 a0, 1, 2, 5
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 4, 2, 2
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 1, 2, 5
	COLONNE2 a0, 1, 5, 2

	COLONNE2 a0, 1, 6, 1
	COLONNE3 a0, 1, 2, 1, 4
	COLONNE3 a0, 1, 2, 1, 4
	COLONNE3 a0, 1, 2, 1, 4
	COLONNE3 a0, 1, 4, 1, 2
	COLONNE3 a0, 1, 4, 1, 2
	COLONNE3 a0, 1, 4, 1, 2
	COLONNE1 a0, 1, 7

	COLONNE1 a0, 1, 7
	COLONNE1 a0, 2, 6
	COLONNE1 a0, 3, 5
	COLONNE1 a0, 2, 6
	COLONNE2 a0, 1, 6, 1
	COLONNE2 a0, 1, 5, 2
	COLONNE2 a0, 1, 4, 3
	COLONNE2 a0, 1, 5, 2

	COLONNE2 a0, 1, 6, 1
	COLONNE1 a0, 2, 6
	COLONNE1 a0, 3, 5
	COLONNE1 a0, 4, 4
	COLONNE1 a0, 5, 3
	COLONNE1 a0, 5, 3
	COLONNE1 a0, 5, 3
	COLONNE1 a0, 1, 7

	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 4, 2, 2
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 3, 2, 3
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 2, 2, 4
	COLONNE1 a0, 1, 7

	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7

	COLONNE2 a0, 1, 2, 5
	COLONNE2 a0, 1, 2, 5
	COLONNE2 a0, 1, 2, 5
	COLONNE2 a0, 1, 2, 5
	COLONNE2 a0, 1, 2, 5
	COLONNE2 a0, 1, 2, 5
	COLONNE2 a0, 1, 2, 5
	COLONNE2 a0, 1, 2, 5

;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
	; ------ part 2, display: read image from SRAM and send to display
restart:
	ldi b1, 0x18
	ldi zl,low(0x0400)
	ldi zh,high(0x0400)
	clc
	ldi r28, 0x00
	add r14, b1							;		
	adc r15, r28						;Shift à gauche (ptet adci)
	mov zl, r14							;
	mov zh, r15						;

	_LDI	r0,64
loop:
	ld a0, z+
	ld a1, z+		
	ld a2, z+							; j'ai load GRB du mario dans les registres (2eme tour de boucle)

	sbrc a0,4							;on check si le pixel a cote est orange
	rjmp shift_mario_in_memory			; on enregistre les compo du mario sur la stack puis l'adress (zl/zh) du a0 du mario   (STACK : zh / zl / a0 / a1 / a2)
next:

	cli
	rcall ws2812b4_byte3wr				; on affiche les 64 pixels
	;sei

	dec r0
	brne loop
	rcall ws2812b4_reset
										; tous les pixels affichés mario compris (STACK : zh / zl / a0 / a1 / a2) r12=zh r13=zl du mario

switch1:
	sbic PINC,0
	rjmp cproc01						;on check s'il y a un jump du mario
	sbis PINC,0
	rjmp PC-1							;ne va pas plus loin tant que b0 pas enclenché
	rjmp move_mario_on_shift
next2:
	INVP PORTB, 1
	jmp restart


cproc01:				
	INVP PORTB,0						; blink LED to assume a parallel process
	WAIT_MS 20
	in r24, PINC
	sbrs r24, 1						;etat du bouton1 
	rjmp jump_mario	
finjump:				; go à la sous routine du jump  (STACK : a0 / a1 / a2) r12=zh r13=zl du mario
	rjmp switch1

; ws2812b4_init		; arg: void; used: r16 (w)
; purpose: initialize AVR to support ws2812
ws2812b4_init:
	OUTI	DDRD,0x02
ret

; ws2812b4_byte3wr	; arg: a0,a1,a2 ; used: r16 (w)
; purpose: write contents of a0,a1,a2 (24 bit) into ws2812, 1 LED configuring
;     GBR color coding, LSB first
ws2812b4_byte3wr:

	ldi w,8
ws2b3_starta0:
	sbrc a0,7
	rjmp	ws2b3w1
	WS2812b4_WR0			; write a zero
	rjmp	ws2b3_nexta0
ws2b3w1:
	WS2812b4_WR1
ws2b3_nexta0:
	lsl a0
	dec	w
	brne ws2b3_starta0

	ldi w,8
ws2b3_starta1:
	sbrc a1,7
	rjmp	ws2b3w1a1
	WS2812b4_WR0			; write a zero
	rjmp	ws2b3_nexta1
ws2b3w1a1:
	WS2812b4_WR1
ws2b3_nexta1:
	lsl a1
	dec	w
	brne ws2b3_starta1

	ldi w,8
ws2b3_starta2:
	sbrc a2,7
	rjmp	ws2b3w1a2
	WS2812b4_WR0			; write a zero
	rjmp	ws2b3_nexta2
ws2b3w1a2:
	WS2812b4_WR1
ws2b3_nexta2:
	lsl a2
	dec	w
	brne ws2b3_starta2
	
ret

; ws2812b4_reset	; arg: void; used: r16 (w)
; purpose: reset pulse, configuration becomes effective
ws2812b4_reset:
	cbi PORTD, 1
	WAIT_US	50 	; 50 us are required, NO smaller works
ret
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;PARTIE SHIFT DE LA MAP (PTET RJMP PR INTERRUPTION SAUT+SHIFT)

shift_mario_in_memory:
	push a2
	push a1
	push a0
	mov r13, zl
	mov r12, zh
	clc
	_SUBI r13, 0x03
	_SBCI r12, 0							;ici on  r12 et r13 qui pointe sur l premiere adresse des pixels du mario
	push r13
	push r12
	rjmp next

move_mario_on_shift:
	;pop r12
	;pop r13
	clc
	_ADDI r13, 0x18 
	_ADCI r12, 0
	mov zl, r13			
	mov zh, r12	
				 
	ld r24, z		;===> si r24 =/= orange a0
	cpi r24, 6
	breq sinon

	;pop r24	
	st z+, r8
	;pop r24
	st z+, r2
	;pop r24
	st z+, r2
	clr r24	
	rjmp next2		;plus rien sur la pile 

sinon:
	pop r24
	pop r24
	clr r24
	rjmp reset

;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================

;PARTIE JUMP DU MARIO

jump_mario:				; (STACK : zh / zl / a0 / a1 / a2) r12=zh r13=zl du mario		pointeur z pointe sur zl
	clr r24
	_LDI r10, 3
	_LDI r11, 3

loop_jump:
	cli
	mov zl, r13			
	mov zh, r12
	clc
	ADDI zl, 3
	clc
	ADCI zh, 0

	ld r24, z			
	sbrc r24, 1			;on check sur le pixel du dessus est orange ou vide
	rjmp descente			; si orange --> descente ou stay ici r12 et r13 sont à z normal

	mov zl, r13				;(je reviens à position du mario)
	mov zh, r12	
	st z+, r2
	st z+, r2
	st z+, r2				;je vide la case mario
			
	mov r12, zh
	mov r13, zl				;on sauve la nouvelle pos du z pr la boucle suivnte
							;(STACK : zh / zl / a0 / a1 / a2) r12=zh+3 r13=zl+3 du mario       
montee:
	st z+, r8	
	st z+, r2			;je remplis le pixel du dessus	
	st z+, r2		; (STACK : zh / zl / a0 / a1 / a2) r12=zh+3 r13=zl+3 du mario    pointeur pointe sur zl+6
	;WAIT_MS 1000
	rcall affichage_matrice
	sei	
	WAIT_MS 1000
	dec r10
	brne loop_jump

descente:
	mov zl, r13			
	mov zh, r12
	clc
	SUBI zl, 0x03
	clc
	SBCI zh, 0x00

	ld r24, z			
	sbrc r24, 1
	rjmp sortie_jump

	mov zl, r13				;(je reviens à position du mario)
	mov zh, r12

	st z+, r2
	st z+, r2
	st z+, r2

	clc
	SUBI zl, 0x06
	clc
	SBCI zh, 0x00

	mov r12, zh
	mov r13, zl

	st z+, r8
	st z+, r2
	st z+, r2
	;WAIT_MS 1000			;(je suis en haut du nouveau zl)
	rcall affichage_matrice
	WAIT_MS 1000
	dec r11
	brne descente			;à la fin de la descente on est de retour a zl ici 0x0418
	rjmp finjump

sortie_jump:
	clr r10
	clr r11
	rcall affichage_matrice
ret

;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
affichage_matrice:
	mov zl, r14
	mov zh, r15
	_LDI r4, 64
	boucle_affi:
		ld a0, z+
		ld a1, z+
		ld a2, z+

		cli
		rcall ws2812b4_byte3wr				; on affiche les 64 pixels
		sei

		dec r4
		brne boucle_affi
		rcall ws2812b4_reset
ret
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
