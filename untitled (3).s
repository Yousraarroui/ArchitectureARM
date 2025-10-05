.global _start
_start:


adr r5,tab
adr r1,fintab
mov r0,#0

tq: 
	cmp r5,r1
	bhs end
	ldrb r2,[r5]
	add r2,r2,r0
	strb r2,[r5],#1
	add r0,r0,#1
	b tq
end: 
	b end
	
tab: .fill 10,1
fintab: