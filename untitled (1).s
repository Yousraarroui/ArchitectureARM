.global _start
_start:

        bl init            @ Initialisation des registres de LEDs et 7-segments
        bl affiche_etage   @ Afficher l'étage initial
        bl fermer_porte    @ Fermer la porte au départ
        bl wait            @ Attente pour la fermeture de la porte
        b fin              @ Fin du programme

@ Sous-programme d'attente d'environ une seconde
wait1:
        mov r0, #0x100000  @ Valeur pour générer un délai approximatif d'une seconde
wait1_loop:
        subs r0, r0, #1    @ Décrémenter le compteur
        bne wait1_loop     @ Tant que le compteur n'est pas à 0
        mov pc, lr         @ Retour au programme principal

@ Sous-programme d'attente pour plusieurs secondes
wait:
        mov r1, #5         @ Attendre 5 secondes (modifiable)
wait_loop:
        bl wait1           @ Appeler wait1 pour chaque seconde
        subs r1, r1, #1    @ Décrémenter le compteur de secondes
        bne wait_loop      @ Répéter jusqu'à 0
        mov pc, lr         @ Retour au programme principal

@ Sous-programme pour ouvrir la porte de l'ascenseur (LEDs centrales éteintes)
ouvrir_porte:
        ldr r8, =0xff200000 @ Adresse du registre de contrôle des LEDs
        mov r0, #0b11111111  @ Allumer toutes les LEDs
        str r0, [r8]         @ Appliquer les valeurs aux LEDs
        bl wait1             @ Attendre avant de commencer l'ouverture
        mov r0, #0b00111100  @ Éteindre les 4 LEDs centrales pour simuler l'ouverture
        str r0, [r8]         @ Appliquer les valeurs aux LEDs
        mov pc, lr           @ Retour

@ Sous-programme pour fermer la porte de l'ascenseur (toutes les LEDs allumées)
fermer_porte:
        ldr r8, =0xff200000 @ Adresse du registre de contrôle des LEDs
        mov r0, #0b00111100  @ Éteindre les 4 LEDs centrales pour simuler l'ouverture
        str r0, [r8]         @ Appliquer les valeurs aux LEDs
        bl wait1             @ Attendre avant de commencer la fermeture
        mov r0, #0b11111111  @ Allumer toutes les LEDs pour simuler la fermeture complète
        str r0, [r8]         @ Appliquer les valeurs aux LEDs
        mov pc, lr           @ Retour

@ Sous-programme pour afficher l'étage actuel sur l'afficheur 7-segments
affiche_etage:
        ldr r8, =0xff200020  @ Adresse du registre des afficheurs 7-segments
        mov r0, #0b0111111   @ Afficher "0" pour l'étage 0
        str r0, [r8]         @ Écrire sur l'afficheur
        mov pc, lr           @ Retour

@ Sous-programme pour afficher le mouvement de la cabine
affiche_mouv:
        ldr r8, =0xff200030  @ Adresse du registre des afficheurs pour le mouvement
        cmp r0, #0           @ Comparer r0 (0 : arrêt, 1 : montée, 2 : descente)
        beq mov_arret        @ Si arrêt
        cmp r0, #1           @ Si montée
        beq mov_montee
        cmp r0, #2           @ Si descente
        beq mov_descente
        mov pc, lr           @ Retour

mov_arret:
        mov r0, #0b0000000   @ Afficheur éteint pour l'arrêt
        str r0, [r8]
        mov pc, lr

mov_montee:
        mov r0, #0b1000000   @ Symbole "u" (monter)
        str r0, [r8]
        mov pc, lr

mov_descente:
        mov r0, #0b0100000   @ Symbole "d" (descendre)
        str r0, [r8]
        mov pc, lr

@ Sous-programme pour lire l'état des boutons poussoirs
lit_boutons:
        ldr r8, =0xff20005c  @ Adresse du registre des boutons poussoirs
        ldr r0, [r8]         @ Lire l'état des boutons
        cmp r0, #0           @ Vérifier si aucun bouton n'est pressé
        beq no_button        @ Si aucun bouton n'est pressé
        mov r1, #0xF         @ Réinitialiser le registre des boutons
        str r1, [r8]         @ Écrire pour réinitialiser
no_button:
        mov pc, lr           @ Retour au programme principal

@ Initialisation (facultative)
init:
        mov r0, #0           @ Initialiser les registres à zéro
        ldr r8, =0xff200000  @ Adresse du registre de contrôle des LEDs
        str r0, [r8]         @ Éteindre toutes les LEDs
        ldr r8, =0xff200020  @ Adresse du registre des afficheurs 7-segments
        str r0, [r8]         @ Éteindre tous les afficheurs
        mov pc, lr           @ Retour

fin: b end

end: b fin
