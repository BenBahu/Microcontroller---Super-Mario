/*
 * macros_LCD.asm
 *
 *  Created: 28/05/2022 21:08:09
 *   Author: benand
 */ 
.include "lcd.asm"
.include "encoder.asm"
.include "printf.asm"

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