.global _start
jour:   .int 3          @ jour = 3
mois:   .int 3          @ mois = 3
annee:  .int 2001       @ annee = 2001
resultat: .fill 1, 4    @ emplacement mémoire pour stocker le quantième

_start:
        ldr r1, =mois    @ Charger l'adresse du mois dans r1
        ldr r1, [r1]     @ Charger la valeur du mois dans r1
        bl DEBUT         @ Appeler le sous-programme DEBUT pour obtenir le quantième avant le mois

        ldr r2, =jour    @ Charger l'adresse du jour dans r2
        ldr r2, [r2]     @ Charger la valeur du jour dans r2
        add r0, r0, r2   @ Ajouter le jour au quantième du mois

        ldr r3, =annee   @ Charger l'adresse de l'année dans r3
        ldr r3, [r3]     @ Charger la valeur de l'année dans r3
        bl BISSEXTILE    @ Vérifier si l'année est bissextile

        cmp r0, #0       @ Si l'année est bissextile
        beq NOT_BISSEXTILE
		
        ldr r1, =mois    @ Recharger le mois pour vérifier si on est après février
        ldr r1, [r1]
        cmp r1, #3       @ Si le mois est mars ou plus
        blt NOT_BISSEXTILE
        add r0, r0, #1   @ Ajouter un jour supplémentaire pour le 29 février

NOT_BISSEXTILE:
        ldr r4, =resultat @ Charger l'adresse de la variable résultat
        str r0, [r4]      @ Stocker le résultat dans la mémoire

        b fin             @ Appel système pour terminer le programme

@ Sous-programme DEBUT : Calculer le quantième avant le mois donné
DEBUT:
        cmp r1, #1       @ Si mois = janvier
        beq DEBUT_JAN
        cmp r1, #2       @ Si mois = février
        beq DEBUT_FEB
        cmp r1, #3       @ Si mois = mars
        beq DEBUT_MAR
        cmp r1, #4       @ Si mois = avril
        beq DEBUT_APR
        cmp r1, #5       @ Si mois = mai
        beq DEBUT_MAY
        cmp r1, #6       @ Si mois = juin
        beq DEBUT_JUN
        cmp r1, #7       @ Si mois = juillet
        beq DEBUT_JUL
        cmp r1, #8       @ Si mois = août
        beq DEBUT_AUG
        cmp r1, #9       @ Si mois = septembre
        beq DEBUT_SEP
        cmp r1, #10      @ Si mois = octobre
        beq DEBUT_OCT
        cmp r1, #11      @ Si mois = novembre
        beq DEBUT_NOV
        cmp r1, #12      @ Si mois = décembre
        beq DEBUT_DEC
        mov r0, #0       @ Valeur par défaut (janvier)

        mov pc, lr       @ Retour du sous-programme

DEBUT_JAN:
        mov r0, #0
        mov pc, lr
DEBUT_FEB:
        mov r0, #31
        mov pc, lr
DEBUT_MAR:
        mov r0, #59
        mov pc, lr
DEBUT_APR:
        mov r0, #90
        mov pc, lr
DEBUT_MAY:
        mov r0, #120
		mov pc, lr
DEBUT_JUN:
        mov r0, #151
        mov pc, lr
DEBUT_JUL:
        mov r0, #181
        mov pc, lr
DEBUT_AUG:
        mov r0, #212
        mov pc, lr
DEBUT_SEP:
        mov r0, #243
        mov pc, lr
DEBUT_OCT:
        mov r0, #273
        mov pc, lr
DEBUT_NOV:
        mov r0, #304
        mov pc, lr
DEBUT_DEC:
        mov r0, #334
        mov pc, lr

@ Sous-programme DIVISIBLE : Vérifie si a est divisible par b
DIVISIBLE:
        mov r0, #0         @ Initialiser le résultat à 0 (pas divisible)
    	mov r3, r1         @ Charger a (dans r1) dans r3
    	mov r4, r2         @ Charger b (dans r2) dans r4

CHECK_DIV:
    	cmp r3, r4         @ Comparer a (r3) et b (r4)
    	blt NOT_DIVISIBLE  @ Si a < b, a n'est pas divisible par b
    	sub r3, r3, r4     @ Soustraire b de a (a = a - b)
    	b CHECK_DIV        @ Répéter la soustraction

NOT_DIVISIBLE:
    	cmp r3, #0         @ Si après soustractions répétées, a == 0, alors divisible
    	bne END_DIV        @ Si a n'est pas zéro, ce n'est pas divisible
    	mov r0, #1         @ Sinon, c'est divisible, retourner 1

END_DIV:
    	mov pc, lr         @ Retour du sous-programme

@ Sous-programme BISSEXTILE : Vérifie si l'année est bissextile
BISSEXTILE:
        mov r2, #4       @ Vérifie si divisible par 4
        bl DIVISIBLE
        cmp r0, #0       @ Si non divisible par 4
        beq NOT_BISSEXTILE_0

        mov r2, #100     @ Vérifie si divisible par 100
        bl DIVISIBLE
        cmp r0, #0       @ Si divisible par 100
        bne IS_BISSEXTILE

        mov r2, #400     @ Vérifie si divisible par 400
        bl DIVISIBLE
        cmp r0, #0       @ Si divisible par 400
        bne IS_BISSEXTILE

        mov r0, #0       @ Si divisible par 100 mais pas par 400, non bissextile
        mov pc, lr

IS_BISSEXTILE:
        mov r0, #1       @ L'année est bissextile
        mov pc,lr

NOT_BISSEXTILE_0:
        mov r0, #0       @ L'année n'est pas bissextile
        mov pc, lr

fin: _end:



