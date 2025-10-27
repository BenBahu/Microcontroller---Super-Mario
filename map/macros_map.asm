/*
 * macros_map.asm
 *
 *  Created: 08/05/2022 16:27:24
 *   Author: patri
 */ 
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
 ; WS2812b4_WR0	; macro ; arg: void; used: void
; purpose: write an active-high zero-pulse to PD1
.macro	WS2812b4_WR0
	clr u
	sbi PORTE, 1
	out PORTE, u
	nop
	nop
	;nop	;deactivated on purpose of respecting timings
	;nop
.endm
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; WS2812b4_WR1	; macro ; arg: void; used: void
; purpose: write an active-high one-pulse to PD1
.macro	WS2812b4_WR1
	sbi PORTE, 1
	nop
	nop
	cbi PORTE, 1
	;nop	;deactivated on purpose of respecting timings
	;nop
.endm
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; ORANGE	; macro ; arg: @0=a0; used: z
; but: remplir 3 cases m�moires pour obtenir une LED orange lors de l'affichage
 .macro ORANGE
	ldi	@0, 0x06	; pixel , orange
	st	z+,@0
	ldi @0,0x1c
	st	z+,@0
	ldi	@0, 0x00
	st z+,@0
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; VERT	; macro ; arg: @0=a0; used: z
; but: remplir 3 cases m�moires pour obtenir une LED verte lors de l'affichage
.macro VERT
	ldi	@0, 0x1c	; pixel , vert
	st	z+,@0
	ldi @0,0x00
	st	z+,@0
	ldi	@0, 0x00
	st z+,@0
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; VOID	; macro ; arg: @0=a0; used: z
; but: remplir 3 cases m�moires pour obtenir une LED �teinte lors de l'affichage
.macro VOID
	ldi	@0, 0x00	; pixel , vide
	st	z+,@0
	ldi @0,0x00
	st	z+,@0
	ldi	@0, 0x00
	st z+,@0
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; PURPLE	; macro ; arg: @0=a0; used: z
; but: remplir 3 cases m�moires pour obtenir une LED violette lors de l'affichage
.macro PURPLE
	ldi	@0, 0x00	; pixel , violet
	st	z+,@0
	ldi @0,0x06
	st	z+,@0
	ldi	@0, 0x06
	st z+,@0
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; COLONNE1	; macro ; arg: @0=a0, @1 et @2 sont des constantes; used: w
; but: remplir 24 cases m�moires pour afficher une colonne sur la matrice, colonnes modulables selon les constantes
;COLONNEx, le x repr�sente le nombre de changements de couleur dans la colonne 
.macro COLONNE1
	ldi w, @1
	loop_base:
		ORANGE @0
		dec w
		brne loop_base
	ldi w, @2
	loop_base0:
		VOID @0
		dec w
		brne loop_base0
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; COLONNE1_START	; macro ; arg: @0=a0, @1 et @2 sont des constantes; used: w
; but: remplir 24 cases m�moires pour afficher une colonne sur la matrice, colonnes modulables selon les constantes
;	   de plus, la colonne comporte une LED verte pour le personnage
.macro COLONNE1_START
	ldi w, @1
	loop_base:
		ORANGE @0
		dec w
		brne loop_base
	VERT @0
	ldi w, @2
	loop_base0:
		VOID @0
		dec w
		brne loop_base0
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; COLONNE2	; macro ; arg: @0=a0, @1 @2 et @3 sont des constantes; used: w
; but: remplir 24 cases m�moires pour afficher une colonne sur la matrice, colonnes modulables selon les constantes
;COLONNEx, le x repr�sente le nombre de changements de couleur dans la colonne 
.macro COLONNE2
	ldi w, @1
	loop_base1:
		ORANGE @0
		dec w 
		brne loop_base1
	ldi w, @2
	loop_base2:
		VOID @0
		dec w
		brne loop_base2
	ldi w, @3
	loop_base3:
		ORANGE @0
		dec w
		brne loop_base3
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; COLONNE3	; macro ; arg: @0=a0, @1 @2 @3 et @4 sont des constantes; used: w
; but: remplir 24 cases m�moires pour afficher une colonne sur la matrice, colonnes modulables selon les constantes
;COLONNEx, le x repr�sente le nombre de changements de couleur dans la colonne 
.macro COLONNE3
	ldi w, @1
	loop_base4:
		ORANGE @0
		dec w 
		brne loop_base4
	ldi w, @2
	loop_base5:
		VOID @0
		dec w
		brne loop_base5
	ldi w, @3
	loop_base6:
		ORANGE @0
		dec w
		brne loop_base6
	ldi w, @4
	loop_base7:
		VOID @0
		dec w
		brne loop_base7
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; COLONNE6	; macro ; arg: @0=a0, @1 @2 @3 @4 @5 @6 et @7 sont des constantes; used: w
; but: remplir 24 cases m�moires pour afficher une colonne sur la matrice, colonnes modulables selon les constantes
;COLONNEx, le x repr�sente le nombre de changements de couleur dans la colonne 
.macro COLONNE6
	ldi w, @1
	loop_base8:
		ORANGE @0
		dec w 
		brne loop_base8
	ldi w, @2
	loop_base9:
		VOID @0
		dec w
		brne loop_base9
	ldi w, @3
	loop_base10:
		ORANGE @0
		dec w
		brne loop_base10
	ldi w, @4
	loop_base11:
		VOID @0
		dec w
		brne loop_base11
	ldi w, @5
	loop_base12:
		ORANGE @0
		dec w
		brne loop_base12
	ldi w, @6
	loop_base13:
		VOID @0
		dec w
		brne loop_base13
	ldi w, @7
	loop_base14:
		ORANGE @0
		dec w
		brne loop_base14
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; COLONNE5	; macro ; arg: @0=a0, @1 @2 @3 @4 et @5 sont des constantes; used: w
; but: remplir 24 cases m�moires pour afficher une colonne sur la matrice, colonnes modulables selon les constantes
;COLONNEx, le x repr�sente le nombre de changements de couleur dans la colonne 
.macro COLONNE5
	ldi w, @1
	loop_base15:
		ORANGE @0
		dec w 
		brne loop_base15
	ldi w, @2
	loop_base16:
		VOID @0
		dec w
		brne loop_base16
	ldi w, @3
	loop_base17:
		ORANGE @0
		dec w
		brne loop_base17
	ldi w, @4
	loop_base18:
		VOID @0
		dec w
		brne loop_base18
		ldi w, @5
	loop_base19:
		ORANGE @0
		dec w
		brne loop_base19
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================

ws2812b4_init:
	OUTI	DDRE,0x02
ret

ws2812b4_byte3wr:
	ldi w,8
ws2b3_starta0:
	sbrc a0,7
	rjmp	ws2b3w1
	WS2812b4_WR0						; write a zero
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
	WS2812b4_WR0						; write a zero
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
	WS2812b4_WR0						; write a zero
	rjmp	ws2b3_nexta2
ws2b3w1a2:
	WS2812b4_WR1
ws2b3_nexta2:
	lsl a2
	dec	w
	brne ws2b3_starta2	

ret

ws2812b4_reset:
	cbi PORTE, 1
	WAIT_US	50 	; 50 us are required, NO smaller works
ret
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;shift_mario_in_memory ; sous-routine ; arg:void ; used:r12 et r13, z 
;Cette sous-routine permet de sauvegarder l'adresse de la premi�re composante de la LED repr�sentant le personnage dans r12 et r13
shift_mario_in_memory:
	mov r13, zl
	mov r12, zh							;On sauve la position la position de la premi�re composante de la LED juste apr�s celle du personnage
	clc
	_SUBI r13, 0x03						;On retire 3 au byte pour retomber surl'adresse de la premi�re composante 
	_SBCI r12, 0						;de le LED du personnage, alors stock� dans r12 et r13	
	ret
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;affichage_matrice ; arg:void ; used: r0,r14,r15,a0,a1,a2, z
;Cette sous-routine permet de rafra�chir l'affichage de la matrice, elle diff�re du premier remplissage de la matrice 
;car elle n'enregistre pas la position du personnage � chaque invocation, cependant elle v�rifie si le personnage a atteint 
;la fin du niveau.
affichage_matrice:
	mov zl, r14
	mov zh, r15							;z pointe sur le d�but du niveau
	_LDI r0, 64							;on charge r0 avec 64 pour les 64 LEDs � remplir
	boucle_affi:
		ld a0, z+
		ld a1, z+						;M�me fonctionnement que pour le premier affichage 
		ld a2, z+

		cli
		call ws2812b4_byte3wr			

		dec r0
		brne boucle_affi
		call ws2812b4_reset

		cpi zh, 0x0a					;Ici, le bout de la map est fix� � l'adresse 0x0a30
		brsh fin_lvl					
		rjmp retour
	fin_lvl:
		cpi zl, 0x30
		brsh escape						;Lorsque z va pointer sur cette adresse, cela siginifiera que le personnage 
		rjmp retour						;a termin� le niveau, il a donc gagn� la partie	(l'adresse de retour du rcall devra donc �tre effac� de la pile)
	escape: 
		_LDI r7, 0x02
		ret
retour:
ret										;S'il n'est pas au bout de la carte, l'affichage est juste raffra�chi 
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;jump_mario ; sous-routine ; arg:void ; used: r2,r6,r8,r10,r12,r13,r24,r28, z 
;Cette sous-routine permet de faire sauter le personnage, permettant de passer certains obstacles du niveau
jump_mario:
	;PLAY_SOUND jump, 50				
	clr r24								;r24 est utilis� comme condition pour arr�ter la mont�e et la descente du personnage
	_LDI r10, 3							;r10 limite le nombre de pixels sautables � 3

loop_jump:
	mov zl, r13			
	mov zh, r12							;On place le pointeur � l'adresse du personnage 
	clc
	add zl, r28							
	adc zh, r2							;On ajoute 3 au byte actuel, ainsi z pointe sur la LED au-dessus du personnage

	ld r24, z							;On charge la premi�re composante de la LED sup�rieure
	sbrc r24, 1							;On v�rifie alors si elle est orange ou pas 
	rjmp descente						;Si c'est le cas, le personnage ne peut pas aller plus haut et entame alors sa descente
	clr r24								 
										;Si la LED n'est pas orange on continue le programme
	mov zl, r13							;z pointe de nouveau sur la LED du personnage
	mov zh, r12	

	st z+, r2
	st z+, r2							;Ces trois instructions permettent de remplacer les composantes GRB du personnage par du vide (LED �teinte)
	st z+, r2				
			
	mov r12, zh							;Ces trois instructions induisent un d�calage de 3 dans la m�moire 
	mov r13, zl							;qui va �tre la nouvelle adresse de la LED du personnage	

	st z+, r8	
	st z+, r2							;Ces trois instructions permettent de remplacer les composantes GRB de la LED �teinte par celle du personnage (vert)	
	st z+, r2

	sbrc r7, 0
	jmp inter_reset
	sbrc r7, 1
	jmp victory

	cli						
	call affichage_matrice				;On affiche alors la nouvelle matrice avec le personnage ayant effectu� un saut d'une LED
	sei						
	WAIT_MS 100
	dec r10
	brne loop_jump						;Lorsque le personnage a saut� 3 LEDs, ou qu'il a rencontr� une LED orange, il amorce sa descente

descente:
	mov zl, r13							
	mov zh, r12							;z pointe donc sur l'adresse de la LED � laquelle le personnage s'est arr�t�
	clc
	sub zl, r28							
	sbc zh, r2							;On retire 3 au byte, z pointe donc sur la LED du dessous

	ld r24, z							;On charge la premi�re composante de la LED inf�rieure		
	sbrc r24, 1							;On v�rifie alors si elle est orange ou pas 
	ret									;Si c'est le cas, le personnage ne peut pas aller plus bas, on va sortir de la sous-routine apr�s rafra�chissement de l'affichage
	
	clr r24
	mov zl, r13							;z pointe sur la LED du personnage 
	mov zh, r12

	st z+, r2
	st z+, r2							;Ces trois instructions permettent de remplacer les composantes GRB du personnage par du vide (LED �teinte)
	st z+, r2							;z pointe donc actuellement sur la LED sup�rieure au personnage

	clc
	sub zl, r6							;Ici on retire 6 � l'adresse point�e par z pr arriver � la LED inf�rieure au personnage d�sormais effac�
	sbc zh, r2					

	mov r12, zh																					
	mov r13, zl							;on enregistre la position du personnage dans r12 et r13

	st z+, r8
	st z+, r2							;Ces trois instructions permettent de remplacer les composantes GRB de la LED �teinte par celle du personnage (vert)
	st z+, r2

	sbrc r7, 0
	jmp inter_reset
	sbrc r7, 1
	jmp victory

	cli						
	call affichage_matrice				;Rafra�chissement de la matrice
	sei						
	WAIT_MS 100	
	rjmp descente						;Tant que le personnage ne rencontre pas de LED orange, il continue de descendre (Boucle TANT QUE)
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; LEVEL1	; macro ; arg:void ; used:void 
; but: remplir en m�moire toutes les colonnes pour cr�er le niveau 1
.macro LEVEL1
	COLONNE1_START a0, 1, 6
	COLONNE1 a0, 1, 7
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
	COLONNE2 a0, 3, 3, 2
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
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; LEVEL2	; macro ; arg:void ; used:void 
; but: remplir en m�moire toutes les colonnes pour cr�er le niveau 2
.macro LEVEL2
	COLONNE1_START a0, 1, 6
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 2, 3, 3
	COLONNE2 a0, 2, 3, 3
	COLONNE2 a0, 3, 3, 2
	COLONNE2 a0, 3, 3, 2
	COLONNE2 a0, 4, 3, 1
	COLONNE2 a0, 4, 3, 1
	COLONNE1 a0, 5, 3
	COLONNE1 a0, 5, 3
	COLONNE2 a0, 4, 2, 2
	COLONNE2 a0, 4, 2, 2
	COLONNE2 a0, 3, 2, 3
	COLONNE2 a0, 3, 2, 3
	COLONNE2 a0, 2, 2, 4
	COLONNE2 a0, 2, 2, 4
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 3, 2, 3
	COLONNE2 a0, 3, 2, 3
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE3 a0, 1, 1, 1, 5
	COLONNE3 a0, 1, 1, 1, 5
	COLONNE3 a0, 1, 4, 1, 2
	COLONNE3 a0, 1, 4, 1, 2
	COLONNE3 a0, 1, 2, 1, 4
	COLONNE3 a0, 1, 2, 1, 4
	COLONNE1 a0, 7, 1
	COLONNE3 a0, 2, 3, 2, 1
	COLONNE3 a0, 1, 5, 1, 1
	COLONNE3 a0, 2, 3, 2, 1
	COLONNE1 a0, 6, 2
	COLONNE1 a0, 6, 2
	COLONNE1 a0, 5, 3
	COLONNE1 a0, 5, 3
	COLONNE1 a0, 4, 4
	COLONNE1 a0, 4, 4
	COLONNE1 a0, 3, 5
	COLONNE1 a0, 3, 5
	COLONNE1 a0, 2, 6
	COLONNE1 a0, 2, 6
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 1, 2, 5
	COLONNE6 a0, 1, 2, 1, 1, 1, 1, 1
	COLONNE5 a0, 1, 2, 1, 3, 1
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 1, 2, 5
	COLONNE3 a0, 1, 4, 2, 1
	COLONNE3 a0, 1, 3, 2, 2
	COLONNE2 a0, 1, 2, 5
	COLONNE1 a0, 1, 7
	COLONNE2 a0, 1, 2, 5
	COLONNE5 a0, 1, 2, 1, 3, 1
	COLONNE3 a0, 1, 3, 3, 1
	COLONNE1 a0, 1, 7
	COLONNE5 a0, 1, 1, 1, 1, 4
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
	COLONNE1 a0, 1, 7
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; CLEARALL	; macro ; arg:void ; used:void 
; but: Mettre � z�ro les registres, ports I/O utilis�s, timer/interrupts, stack
.macro CLEARALL
	clr_stack:
		pop a0
		in w, SPL
		cpi w, 0xff
		breq PC+2
		rjmp clr_stack
	clr r0
	clr r1
	clr r2
	clr r3
	clr r4
	clr r5
	clr r6
	clr r7
	clr r8
	clr r9
	clr r10
	clr r11
	clr r12
	clr r13
	clr r14
	clr r15
	clr r16
	clr r17
	clr r18
	clr r19
	clr r20
	clr r21
	clr r22
	clr r23
	clr r24
	clr r25
	clr r26
	clr r27
	clr r28
	clr r29
	clr r30
	clr r31		
	OUTI	DDRD, 0x00	
	OUTI	DDRE, 0x00		
	OUTI	EIMSK, 0x00	
	OUTI ASSR, 0x00
	OUTI TCCR0, 0x00
	OUTI TIMSK, 0x00
	OUTI SREG, 0x00
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
; RESET_MAT	; macro ; arg:void ; used:void 
; but: remplir en m�moire l'�quivalent de 64 LEDs vides pour �teindre la matrice
.macro RESET_MAT
	ldi w, 64
	loop_baseNull:
		VOID a0
		dec w
		brne loop_baseNull
.endmacro
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================	
; mainLCD	; sous-routine ; arg:void ; used:b0,PIND,a0
; but: Offrir � l'utilisateur des menus et param�tres � r�gler avant de lancer la partie visibles 
;sur l'�cran LCD

;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================	