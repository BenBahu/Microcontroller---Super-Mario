; fichier	Map1Done.asm   cible ATmega128L-4MHz-STK300
;but: Jeu jouable type Mario visualisable sur la matrice de LED 
;    
; usage: boutons sur PORTD, ws2812 sur PORTE (bit 1)
;        presser bouton 0 pour avancer, bouton 1 pour sauter, (bouton 6 pour redémarrer)
;		 Des niveaux de jeu sont stockés en mémoire puis afficher sur la matrice
;	     Lorsque B0 est pressé, la matrice affiche une colonne plus loin en mémoire
;        qui se traduit par un décalage vers la droite du niveau.
;		 Lorsque B1 est pressé, le personnage (pixel vert) effectue un saut. Les deux
;		 actions sont combinables. 
;		 Le codeur angulaire permet de choisir le niveau du son de 0 à 9 (encodeur pressé)
;		 puis le choix du niveau (encodeur non pressé) 
;		 Le reste des boutons à actionner est indiqué sur l'écran LCD au moment voulu
;		L'écran LCD permet de communiquer avec l'utilisateur
;
; 20220315 AxS

.include "definitions.asm"	
.include "macros.asm"	
		
; === interrupt table ===

.org 0
	jmp	reset

.org INT0addr
	in _sreg, SREG						;L'interruption 0 permet le déplacement latéral du personnage
	jmp ext_int0

.org OVF0addr
	in _sreg, SREG						;L'interruption de timer overflow 0 permet de limiter la durée d'une partie à 60 secondes
	jmp ovf_int0

.include "macros_map.asm"
.include "file_sound.asm"
.include "macros_LCD.asm"
; === interrupt service routines ===
ext_int0:
	jmp shift_jump
ovf_int0:
	push b0								
	push a0
	rjmp refresh_timer
;===================================
reset:
	cli
	LDSP	RAMEND						;Le reset initialise l'écran LCD, l'encodeur et le stack pointer
	call	LCD_init					;Le registre r11 est une constante fixée à 60 pour les 60 secondes à décrémenter jusqu'au game over
	call encoder_init
	_LDI r11, 60	
	call	mainLCD						;Le main LCD représente l'interface utilisateur où le joueur choisit plusieurs paramètres avant de lancer la partie
	rjmp lancement
;==================================================================================================================================================================================
;==================================================================================================================================================================================
;refresh_timer est la sous-routine d'interruption timer overflow 0
;Elle permet de limiter en temps la durée du joueur sur un niveau pour ajouter un peu de challenge
refresh_timer:
	;tst r7
	;_BREQ fin_ovf 
	dec r11							
	_CPI r11, 0x00						;On décrémente le registre r11 jusqu'a ce qu'il atteigne zéro ce qui implique le game over
	_BREQ inter_reset					;pour le joueur.
	mov b0, r11
	call LCD_clear
	PRINTF LCD
.db		"HOMEMADE   MARIO",0				
	call LCD_lf
	mov a0, r9							;L'affichage est rafraîchi à chaque overflow du timer
	PRINTF LCD
.db "LVL:",FHEX,a,"       ",FDEC,b,"s ",0
fin_ovf:
	pop a0
	pop b0
	out SREG, _sreg						;Enfin on restitue les valeurs a0, b0 ainsi que le SREG qui ont pu être altérés par la sous-routine (printf notamment)
	reti
;==================================================================================================================================================================================
;==================================================================================================================================================================================
;shift_jump est la sous-routine d'interruption externe 0
;Elle permet le décalage de la map d'une colonne à chaque fois que le bouton 0 est pressé, de plus, 
;elle décale aussi le personnage en mémoire et sur la matrice 
shift_jump:
	Wait_MS 100
	mov zl, r13							;z pointe sur la LED du personnage 
	mov zh, r12
	clc
	add zl, b1							;On ajoute 0x18 au byte pour arriver sur la LED à droite du personnage	
	adc zh, r2		

	ld r24, z							;On vérifie que la LED à droite du personnage soit orange 
	sbrc r24, 1							;Si c'est le cas, le personnage est entré en collision avec une LED  orange, il perd la partie
	rjmp fin2						;On saute donc à l'affichage du "game over"

	clr r24
	mov	r13, zl							;On sauve la nouvelle position du personnage dans r12 et r13
	mov	r12, zh

	st z+, r8
	st z+, r2							;Ces trois instructions permettent de remplir la nouvelle LED avec les couleurs du personnage
	st z+, r2

	clc
	add r14, b1							;Ici, on décale l'origine du niveau d'une colonne, pour faire "avancer" le personnage 
	adc r15, r2							;On ajoute donc 0x18 au byte r15:r14 pour que z pointe une colonne plus loin lors de l'affichage

	;cli								;changer	
	call affichage_matrice
	WAIT_MS 100

	rjmp descente_int

fin:
	_LDI r10, 0x01						;Ici on charge r10 avec 0x01 pour stoper le saut du personnage si l'interruption à lieu pendant un saut
	out SREG, _sreg						;On rétablit le SREG
	reti
	
fin2:
	_LDI r7, 0x01						;Ici on charge r7 avec 0x01 pour 
	out SREG, _sreg						;On rétablit le SREG
	reti							

descente_int:
	mov zl, r13							;On fait pointer z sur la nouvelle position du personnage avant qu'il amorce sa descente
	mov zh, r12

	clc
	sub zl, r28							;Cette partie est similaire à la descente de la sous-routine descente de jump_mario
	sbc zh, r2

	ld r24, z
	sbrc r24,1
	rjmp fin

	clc
	mov zl, r13
	mov zh, r12

	st z+, r2
	st z+, r2
	st z+, r2

	clc 
	sub zl, r6
	sbc zh, r2

	mov r13, zl
	mov r12, zh

	st z+, r8
	st z+, r2
	st z+, r2

	;cli								; changer
	call affichage_matrice
	;sei								; changer
	WAIT_MS 100
	rjmp descente_int
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;Ces deux morceaux de code servent à terminer la partie, que ce soit une victoire ou une défaite
inter_reset:
	call LCD_clear						 
	PRINTF LCD
.db "   GAME  OVER   ",0
	;PLAY_SOUND game_over, 50									;on arrive dans cette partie du programme lorsque le joueur a perdu la partie (collision ou manque de temps)
	WAIT_MS 5000						;un "game over" est alors affiché sur le LCD
play_again:
	_LDI r14,0x00
	_LDI r15, 0x04
	mov zl, r14							;Ici on charge le pointeur z sur le debut du niveau pour nettoyer et "éteindre" la matrice de LEDs
	mov zh, r15
	RESET_MAT							
	call affichage_matrice
	CLEARALL							;Le CLEARALL permet de mettre à zéro tous les registres, ainsi que les ports, interrupts et timers avant de pouvoir recommencer la partie 
	rjmp reset

victory:
	call LCD_clear
	PRINTF LCD							;Cet affichage est produit lorsque le joueur parvient au bout du niveau
.db " YOU  COMPLETED ",0
	;PLAY_SOUND level_complete, 50
	call LCD_lf
	mov a0, r9
	PRINTF LCD
.db "    LEVEL ",FHEX,a,"    ",0
	clr a0
	WAIT_MS 5000
	rjmp play_again						;A la fin de l'affichage, on saute à "play_again" pour mettre à zéro comme lors de la défaite du joueur
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;Partie lancement de la partie
;Initialisation des différents ports et registres nécessaires au bon fonctionnement du jeu
lancement:
	call	ws2812b4_init				; initialise la matrice de LEDs 
	OUTI	DDRD, 0x00					; Connecte les boutons du port D en mode entrée
	sbi	DDRB, SPEAKER					;changer
	OUTI	EIMSK, 0b00000001			;On autorise l'interruption externe 0
	OUTI ASSR, (1<<AS0)					;On choisit le quartz horloger
	OUTI TCCR0, 5						;ainsi qu'un prescaler à 5 pour obtenir un overflow toutes les secondes
	OUTI TIMSK, (1<<TOIE0)				;On autorise le timer overflow interrupt 0
	_LDI r2, 0x00
	_LDI r28, 0x03						;Constantes utilisés lors de l'exécution du programme
	_LDI r6, 0x06
	_LDI r8, 0x1c
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;Partie chargement de la map
main:
	ldi zl,low(0x0400)
	ldi zh,high(0x0400)					;On fait pointer le pointeur z à l'adresse 0x0400 de la memoire, là où sera sauvegardé le niveau à afficher
	mov r14, zl
	mov r15, zh							;On sauve dans les registres le "début" du niveau, utilisés dans d'autres parties du code

	sbrs r9, 0
	rjmp map2							;Selon le choix fait avec l'encodeur angulaire, on place le niveau 1 ou 2 en mémoire
	rjmp map1
map2:
	LEVEL2
	rjmp restart
map1:
	LEVEL1
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;Partie affichage de la map
restart:
	ldi b1, 0x18
	ldi zl,low(0x0400)
	ldi zh,high(0x0400)					;On replace z à l'origine du niveau						

	_LDI	r0,64
loop:
	ld a0, z+
	ld a1, z+							;On charge dans a0, a1, a2 les composantes GRB de chaque pixel
	ld a2, z+							

	sbrc a0,4							;On vérifie que ici que le pixel soit vert
	call shift_mario_in_memory			;S'il est vert, on enregistre l'adresse de la première composante du pixel vert pour de futurs calculs

	cli
	call ws2812b4_byte3wr				;Sous-routine qui va écrire des 0 et des 1 pour allumer les LEDs de la matrice
	sei

	dec r0
	brne loop
	call ws2812b4_reset					;Reset nécessaire au bon fonctionnement de la matrice
						
attente_jump:		
	sbis PIND, 1						;Lorsque le bouton 1 et pressé, le personnage saute, sinon  
	call jump_mario						;on attend juste que le joueur avance ou saute dans cette boucle
	sbrc r7, 0
	jmp inter_reset
	sbrc r7, 1
	jmp victory
	rjmp attente_jump
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================