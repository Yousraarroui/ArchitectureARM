.global _start
_start:

.equ N, 128         @ Définition de la constante N = 128

main: 
    mov r1, #0      @ Initialisation de la somme des multiples de 2 (r1 = 0)
    mov r2, #0      @ Initialisation de la somme des multiples de 4 (r2 = 0)
    mov r3, #0      @ Initialisation de la somme des multiples de 8 (r3 = 0)
    mov r4, #0      @ Initialisation de i (r4 = 0)

boucle: 
    cmp r4, #N      @ Comparer i à N
    bgt fin         @ Si i > N, on sort de la boucle

    @ Test si i est multiple de 2 (i % 2 == 0)
    tst r4, #1      @ Tester le bit 0 de i (i AND 1)
    bne suite2      @ Si le bit est 1, i n'est pas un multiple de 2
    add r1, r1, r4  @ Sinon, ajouter i à la somme des multiples de 2 (r1)

suite2:
    @ Test si i est multiple de 4 (i % 4 == 0)
    tst r4, #3      @ Tester les 2 bits de poids faible de i (i AND 3)
    bne suite4      @ Si le résultat n'est pas 0, i n'est pas un multiple de 4
    add r2, r2, r4  @ Sinon, ajouter i à la somme des multiples de 4 (r2)

suite4:
    @ Test si i est multiple de 8 (i % 8 == 0)
    tst r4, #7      @ Tester les 3 bits de poids faible de i (i AND 7)
    bne suite8      @ Si le résultat n'est pas 0, i n'est pas un multiple de 8
    add r3, r3, r4  @ Sinon, ajouter i à la somme des multiples de 8 (r3)

suite8:
    add r4, r4, #1  @ Incrémenter i
    b boucle        @ Revenir au début de la boucle

fin: 
    @ Fin du programme, à cet endroit on suppose qu'on arrête le programme
    b fin           @ Boucle infinie pour arrêter l'exécution
