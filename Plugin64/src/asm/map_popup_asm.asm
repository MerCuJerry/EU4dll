EXTERN	mapPopupProc1ReturnAddress		:	QWORD
EXTERN	mapPopupProc1CallAddress		:	QWORD
EXTERN	mapPopupProc2ReturnAddress		:	QWORD
EXTERN	mapPopupProc3ReturnAddress		:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

; temporary space for code point
.DATA
	mapPopupProc1TmpCharacterAddress	DQ	0
	mapPopupProc1MultibyteFlag			DD	0

.CODE
mapPopupProc1 PROC
	cmp		byte ptr[rdi + rax], 0C2h;
	jb		JMP_A;

	movzx	r8d, byte ptr [rdi + rax];
	mov     edx, 1;
	lea		rcx, [rbp - 30h];
	call	mapPopupProc1CallAddress;
	jmp		JMP_B;

JMP_A:
	lea		rdx, qword ptr [rdi + rax];
	mov		mapPopupProc1TmpCharacterAddress, rdx;
	mov		edx, 3;  
	lea		rcx, [rbp - 30h];
	call	mapPopupProc1CallAddress;

	; overwrite
	mov		rcx, mapPopupProc1TmpCharacterAddress;
	mov		ecx, dword ptr [rcx];
	mov		dword ptr [rax], ecx; 

JMP_B:
	push	mapPopupProc1ReturnAddress;
	ret;
mapPopupProc1 ENDP

;-------------------------------------------;

mapPopupProc2V130 PROC
	cmp     byte ptr[rax + rdi], 0C2h;
	ja      JMP_A;
	movzx   eax, byte ptr[rax + rdi];
	jmp 	JMP_H;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [rax + rdi];
	and     dx, 1Fh;
	cmp     byte ptr [rax + rdi], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		edi;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi];

JMP_B:
	inc		edi;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi]

	movzx	eax, dx; 	
	pop 	rdx;
	cmp		eax, NO_FONT;
	ja		JMP_H;
	mov		eax, NOT_DEF;

JMP_H:
	mov     r14, qword ptr [r15 + rax * 8 + 120h];
	test	r14, r14;

	push	mapPopupProc2ReturnAddress;
	ret;
mapPopupProc2V130 ENDP

;-------------------------------------------;

mapPopupProc3V130 PROC
	cmp     byte ptr[rax + rbx], 0C2h;
	ja      JMP_A;
	movzx   eax, byte ptr[rax + rbx];
	jmp 	JMP_H;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [rax + rbx];
	and     dx, 1Fh;
	cmp     byte ptr [rax + rbx], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		ebx;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rbx];

JMP_B:
	inc		ebx;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rbx]

	movzx	eax, dx; 	
	pop 	rdx;
	cmp		eax, NO_FONT;
	ja		JMP_H;
	mov		eax, NOT_DEF;

JMP_H:
	mov     r11, qword ptr [r15 + rax * 8 + 120h];
	mov     qword ptr [rbp + 0D0h], r11;

	push	mapPopupProc3ReturnAddress;
	ret;
mapPopupProc3V130 ENDP

END