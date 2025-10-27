; fichier	Map1Done.asm   cible ATmega128L-4MHz-STK300
;but: Jeu jouable type Mario visualisable sur la matrice de LED 
;    
; usage: boutons sur PORTD, ws2812 sur PORTE (bit 1)
;        presser bouton 0 pour avancer, bouton 1 pour sauter, (bouton 6 pour red�marrer)
;		 Des niveaux de jeu sont stock�s en m�moire puis afficher sur la matrice
;	     Lorsque B0 est press�, la matrice affiche une colonne plus loin en m�moire
;        qui se traduit par un d�calage vers la droite du niveau.
;		 Lorsque B1 est press�, le personnage (pixel vert) effectue un saut. Les deux
;		 actions sont combinables. 
;		 Le codeur angulaire permet de choisir le niveau du son de 0 � 9 (encodeur press�)
;		 puis le choix du niveau (encodeur non press�) 
;		 Le reste des boutons � actionner est indiqu� sur l'�cran LCD au moment voulu
;		L'�cran LCD permet de communiquer avec l'utilisateur
;
; 20220315 AxS

.include "definitions.asm"	
.include "macros.asm"	
		
; === interrupt table ===

.org 0
	jmp	reset

.org INT0addr
	in _sreg, SREG						;L'interruption 0 permet le d�placement lat�ral du personnage
	jmp ext_int0

.org OVF0addr
	in _sreg, SREG						;L'interruption de timer overflow 0 permet de limiter la dur�e d'une partie � 60 secondes
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
	LDSP	RAMEND						;Le reset initialise l'�cran LCD, l'encodeur et le stack pointer
	call	LCD_init					;Le registre r11 est une constante fix�e � 60 pour les 60 secondes � d�cr�menter jusqu'au game over
	call encoder_init
	_LDI r11, 60	
	call	mainLCD						;Le main LCD repr�sente l'interface utilisateur o� le joueur choisit plusieurs param�tres avant de lancer la partie
	rjmp lancement
;==================================================================================================================================================================================
;==================================================================================================================================================================================
;refresh_timer est la sous-routine d'interruption timer overflow 0
;Elle permet de limiter en temps la dur�e du joueur sur un niveau pour ajouter un peu de challenge
refresh_timer:
	;tst r7
	;_BREQ fin_ovf 
	dec r11							
	_CPI r11, 0x00						;On d�cr�mente le registre r11 jusqu'a ce qu'il atteigne z�ro ce qui implique le game over
	_BREQ inter_reset					;pour le joueur.
	mov b0, r11
	call LCD_clear
	PRINTF LCD
.db		"HOMEMADE   MARIO",0				
	call LCD_lf
	mov a0, r9							;L'affichage est rafra�chi � chaque overflow du timer
	PRINTF LCD
.db "LVL:",FHEX,a,"       ",FDEC,b,"s ",0
fin_ovf:
	pop a0
	pop b0
	out SREG, _sreg						;Enfin on restitue les valeurs a0, b0 ainsi que le SREG qui ont pu �tre alt�r�s par la sous-routine (printf notamment)
	reti
;==================================================================================================================================================================================
;==================================================================================================================================================================================
;shift_jump est la sous-routine d'interruption externe 0
;Elle permet le d�calage de la map d'une colonne � chaque fois que le bouton 0 est press�, de plus, 
;elle d�cale aussi le personnage en m�moire et sur la matrice 
shift_jump:
	Wait_MS 100
	mov zl, r13							;z pointe sur la LED du personnage 
	mov zh, r12
	clc
	add zl, b1							;On ajoute 0x18 au byte pour arriver sur la LED � droite du personnage	
	adc zh, r2		

	ld r24, z							;On v�rifie que la LED � droite du personnage soit orange 
	sbrc r24, 1							;Si c'est le cas, le personnage est entr� en collision avec une LED  orange, il perd la partie
	rjmp fin2						;On saute donc � l'affichage du "game over"

	clr r24
	mov	r13, zl							;On sauve la nouvelle position du personnage dans r12 et r13
	mov	r12, zh

	st z+, r8
	st z+, r2							;Ces trois instructions permettent de remplir la nouvelle LED avec les couleurs du personnage
	st z+, r2

	clc
	add r14, b1							;Ici, on d�cale l'origine du niveau d'une colonne, pour faire "avancer" le personnage 
	adc r15, r2							;On ajoute donc 0x18 au byte r15:r14 pour que z pointe une colonne plus loin lors de l'affichage

	;cli								;changer	
	call affichage_matrice
	WAIT_MS 100

	rjmp descente_int

fin:
	_LDI r10, 0x01						;Ici on charge r10 avec 0x01 pour stoper le saut du personnage si l'interruption � lieu pendant un saut
	out SREG, _sreg						;On r�tablit le SREG
	reti
	
fin2:
	_LDI r7, 0x01						;Ici on charge r7 avec 0x01 pour 
	out SREG, _sreg						;On r�tablit le SREG
	reti							

descente_int:
	mov zl, r13							;On fait pointer z sur la nouvelle position du personnage avant qu'il amorce sa descente
	mov zh, r12

	clc
	sub zl, r28							;Cette partie est similaire � la descente de la sous-routine descente de jump_mario
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
;Ces deux morceaux de code servent � terminer la partie, que ce soit une victoire ou une d�faite
inter_reset:
	call LCD_clear						 
	PRINTF LCD
.db "   GAME  OVER   ",0
	;PLAY_SOUND game_over, 50									;on arrive dans cette partie du programme lorsque le joueur a perdu la partie (collision ou manque de temps)
	WAIT_MS 5000						;un "game over" est alors affich� sur le LCD
play_again:
	_LDI r14,0x00
	_LDI r15, 0x04
	mov zl, r14							;Ici on charge le pointeur z sur le debut du niveau pour nettoyer et "�teindre" la matrice de LEDs
	mov zh, r15
	RESET_MAT							
	call affichage_matrice
	CLEARALL							;Le CLEARALL permet de mettre � z�ro tous les registres, ainsi que les ports, interrupts et timers avant de pouvoir recommencer la partie 
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
	rjmp play_again						;A la fin de l'affichage, on saute � "play_again" pour mettre � z�ro comme lors de la d�faite du joueur
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;Partie lancement de la partie
;Initialisation des diff�rents ports et registres n�cessaires au bon fonctionnement du jeu
lancement:
	call	ws2812b4_init				; initialise la matrice de LEDs 
	OUTI	DDRD, 0x00					; Connecte les boutons du port D en mode entr�e
	sbi	DDRB, SPEAKER					;changer
	OUTI	EIMSK, 0b00000001			;On autorise l'interruption externe 0
	OUTI ASSR, (1<<AS0)					;On choisit le quartz horloger
	OUTI TCCR0, 5						;ainsi qu'un prescaler � 5 pour obtenir un overflow toutes les secondes
	OUTI TIMSK, (1<<TOIE0)				;On autorise le timer overflow interrupt 0
	_LDI r2, 0x00
	_LDI r28, 0x03						;Constantes utilis�s lors de l'ex�cution du programme
	_LDI r6, 0x06
	_LDI r8, 0x1c
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================
;Partie chargement de la map
main:
	ldi zl,low(0x0400)
	ldi zh,high(0x0400)					;On fait pointer le pointeur z � l'adresse 0x0400 de la memoire, l� o� sera sauvegard� le niveau � afficher
	mov r14, zl
	mov r15, zh							;On sauve dans les registres le "d�but" du niveau, utilis�s dans d'autres parties du code

	sbrs r9, 0
	rjmp map2							;Selon le choix fait avec l'encodeur angulaire, on place le niveau 1 ou 2 en m�moire
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
	ldi zh,high(0x0400)					;On replace z � l'origine du niveau						

	_LDI	r0,64
loop:
	ld a0, z+
	ld a1, z+							;On charge dans a0, a1, a2 les composantes GRB de chaque pixel
	ld a2, z+							

	sbrc a0,4							;On v�rifie que ici que le pixel soit vert
	call shift_mario_in_memory			;S'il est vert, on enregistre l'adresse de la premi�re composante du pixel vert pour de futurs calculs

	cli
	call ws2812b4_byte3wr				;Sous-routine qui va �crire des 0 et des 1 pour allumer les LEDs de la matrice
	sei

	dec r0
	brne loop
	call ws2812b4_reset					;Reset n�cessaire au bon fonctionnement de la matrice
						
attente_jump:		
	sbis PIND, 1						;Lorsque le bouton 1 et press�, le personnage saute, sinon  
	call jump_mario						;on attend juste que le joueur avance ou saute dans cette boucle
	sbrc r7, 0
	jmp inter_reset
	sbrc r7, 1
	jmp victory
	rjmp attente_jump
;==================================================================================================================================================================================================================
;==================================================================================================================================================================================================================