EXTERN	mapViewProc1ReturnAddress	:	QWORD
EXTERN	mapViewProc2ReturnAddress	:	QWORD
EXTERN	mapViewProc3ReturnAddress	:	QWORD
EXTERN	mapViewProc3CallAddress		:	QWORD
EXTERN	mapViewProc3CallAddress		:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

; temporary space for code point
.DATA
	mapViewProc3TmpCharacterAddress	DQ	0

.CODE
mapViewProc1 PROC
	cmp     byte ptr[rax + r8], 7Eh;
	ja      JMP_A;
	movzx   eax, byte ptr[rax + r8];
	jmp 	JMP_G;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [rax + r8];
	and     dx, 1Fh;
	cmp     byte ptr [rax + r8], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		ebx;
	inc		r8d;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + r8];

JMP_B:
	inc		ebx
	inc		r8d;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + r8]

	movzx	eax, dx; 	
	pop 	rdx;
	cmp		eax, NO_FONT;
	ja		JMP_G;
	mov		eax, NOT_DEF;
	jmp		JMP_G;

JMP_G:
	mov     r11, qword ptr [ rdi + rax * 8];

	;issue-161
	cmp		r11,0;
	jnz		JMP_N;

	; issue-237
	cmp		rax, 0FFh;
	jl		JMP_N;
	
	mov		eax, 2dh ; -
	mov     r11, qword ptr [ rdi + rax * 8];

JMP_N:
	mov     qword ptr [rbp + 38h], r11;
	movss   dword ptr [rbp + 40h], xmm2

	push	mapViewProc1ReturnAddress;
	ret;
mapViewProc1 ENDP

;-------------------------------------------;

mapViewProc2 PROC
	push	mapViewProc2ReturnAddress;
	ret;
mapViewProc2 ENDP

;-------------------------------------------;

mapViewProc2V130 PROC
	lea     r9, [r12 + 120h];

	cmp     byte ptr[rax + r15], 7Eh;
	ja      JMP_A;
	movzx   eax, byte ptr[rax + r15];
	jmp 	JMP_E;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [rax + r15];
	and     dx, 1Fh;
	cmp     byte ptr [rax + r15], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		esi;
	inc		r15;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + r15];

JMP_B:
	inc		esi;
	inc		r15;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + r15]

	movzx	eax, dx; 	
	pop 	rdx;
	cmp		eax, NO_FONT;
	ja		JMP_E;
	mov		eax, NOT_DEF;

JMP_E:
	mov     r12, qword ptr [r9 + rax * 8];

	push	mapViewProc2ReturnAddress;
	ret;
mapViewProc2V130 ENDP

;-------------------------------------------;

mapViewProc3 PROC
    mov		qword ptr[rsp + 488h - 448h],0;

	cmp		byte ptr [rax + r15], 7Eh;
	ja		JMP_A;

	movzx	r8d, byte ptr[rax + r15];
	mov     edx, 1;
	lea     rcx, qword ptr [rsp + 488h - 448h];
	call	mapViewProc3CallAddress;

	jmp		JMP_B;
JMP_A:
	lea		r8, qword ptr [rax + r15];
	mov		mapViewProc3TmpCharacterAddress, r8;
	movzx	r8d, byte ptr[rax + r15];
	mov     edx, 3; The memory is allocated 3 byte, but the first byte is copied 3 times.
	lea     rcx, qword ptr [rsp + 488h - 448h];
	call	mapViewProc3CallAddress;

	; overwrite
	mov		rcx, mapViewProc3TmpCharacterAddress;
	mov		cx, word ptr [rcx+1];
	mov		word ptr [rax+1], cx; 

JMP_B:
	push	mapViewProc3ReturnAddress;
	ret;
mapViewProc3 ENDP

END