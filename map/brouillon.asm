/*
 * AsmFile1.asm
 *
 *  Created: 28/05/2022 21:11:56
 *   Author: benand
 */ 

 .include "sound.asm"
 .include "lcd.asm"
 .include "encoder.asm"

;===================================================================================================
								;SOUND
;===================================================================================================

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

.org 0x0b00
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

;=======================================================================================================
								;LCD
;=======================================================================================================

mainLCD:	
	rcall LCD_clear	
	PRINTF LCD
.db		"HOMEMADE   MARIO",0			;Affichage au lancement du jeu
	rcall LCD_lf						
	PRINTF LCD
.db		"6:NEXT",0
	sbis PIND, 6						;Il faut appuyer sur le bouton 6 pour accéder au paramètre suivant
	rjmp select_sound
	rjmp PC-2

select_sound:
	rcall LCD_clear
	PRINTF LCD							;Menu pour la sélection du niveau de son 
.db	"SELECT SOUND:",0
	rcall LCD_lf
choix_b0:
	WAIT_MS 20
	rcall encoder						
	cpi b0, 0xff
	breq mise_neuf						;Son réglable du niveau 0 (pas de son) à 9 au moyen de l'encodeur angulaire
	cpi b0, 0x0a
	brsh mise_zero2
	PRINTF LCD
.db "SOUND:",FHEX,b,"  7:NEXT",0
	WAIT_MS 20

	;sbis PIND, 5						;Lorsqu'on appuie sur le bouton 5, une musique se lance pour voir le niveau de son correspondant
	;lance musique
	sbis PIND, 7						;Il faut appuyer sur le bouton 7 pour passer au choix du niveau
	rjmp select_lvl
	rjmp select_sound

mise_zero2:
	ldi b0, 0x00
	rjmp choix_b0
mise_neuf:
	ldi b0, 0x09
	rjmp choix_b0						;Sous-routines qui permettent de garder les valeurs voulues entre deux bornes
mise_un:								;avec b0 qui stocke la valeur pour le son et a0 la valeur pour les niveaux
	ldi a0, 0x01
	rjmp choix_a0
mise_deux:
	ldi a0, 0x02
	rjmp choix_a0

select_lvl:
	rcall LCD_clear
	PRINTF LCD							;Menu pour la sélection du niveau
.db		"SELECT LVL:",0
	rcall LCD_lf
choix_a0:
	WAIT_MS 20
	rcall encoder
	cpi a0, 0x00
	breq mise_deux						;Deux choix de niveau (1 et 2)
	cpi a0, 0x03
	brsh mise_un
	PRINTF LCD
.db	"LVL:",FHEX,a,"    6:PLAY",0
	WAIT_MS 20
	sbis PIND, 6						;Il faut appuyer sur le bouton 6 pour lancer la partie sur le niveau choisi
	rjmp affi_lvl
	rjmp select_lvl

affi_lvl:
	mov r9, a0
	rcall LCD_clear
	PRINTF LCD							
.db		"HOMEMADE   MARIO",0			;Affichage du LCD lorsque la partie commence
	rcall LCD_lf
	PRINTF LCD
.db "LVL:",FHEX,a,0
	ret