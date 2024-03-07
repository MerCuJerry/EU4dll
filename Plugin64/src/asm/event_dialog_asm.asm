EXTERN	eventDialogProc1ReturnAddress	:	QWORD
EXTERN	eventDialogProc2ReturnAddress1	:	QWORD
EXTERN	eventDialogProc2ReturnAddress2	:	QWORD
EXTERN	eventDialogProc3ReturnAddress	:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

;temporary space for code point
.DATA
	eventDialogProc1Flag	DQ	0

.CODE
eventDialogProc1V132 PROC
	cmp     byte ptr[rax + rdx], 0C2h;
	jbe		JMP_NOTUTF8;
	cmp		byte ptr [rax + rdx + 1], 80h
	jb		JMP_NOTUTF8;
	cmp		byte ptr [rax + rdx + 1], 0BFh
	ja		JMP_NOTUTF8;
	jmp		JMP_A

JMP_NOTUTF8:
	movzx   eax, byte ptr[rax + rdx];
	mov		eventDialogProc1Flag, 0;
	jmp 	JMP_E;

JMP_A:
	push	rdi;
	mov 	rdi, rdx;
	movzx   dx, byte ptr [rax + rdi];
	and     dx, 1Fh;
	cmp     byte ptr [rax + rdi], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rax;
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi];

JMP_B:
	inc		rax;
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi]

	movzx	eax, dx;
	mov		rdx, rdi;
	pop 	rdi;
	mov		eventDialogProc1Flag, 1;
	test	ah, ah;
	jz		JMP_E
	cmp		eax, NO_FONT;
	ja		JMP_E;
	mov		eax, NOT_DEF;

JMP_E:
	mov		rsi, qword ptr [r10 + rax * 8];
	movss	xmm1, dword ptr [r10 + 848h];
	test	rsi, rsi;
	push	eventDialogProc1ReturnAddress;
	ret;
eventDialogProc1V132 ENDP

;-------------------------------------------;

eventDialogProc2 PROC
	cvtdq2ps	xmm0, xmm0;
	mulss		xmm0, xmm1;
	ucomiss		xmm0, xmm8;

	cmp			eventDialogProc1Flag,1h;
	jz			JMP_B;
	jp			JMP_B;
	jnz			JMP_B;

JMP_A:
	push		eventDialogProc2ReturnAddress2;
	ret;

JMP_B:
	push		eventDialogProc2ReturnAddress1;
	ret;
eventDialogProc2 ENDP

;-------------------------------------------;

eventDialogProc3V132 PROC
	cmp		eventDialogProc1Flag, 1;
	jnz		JMP_A;
	add		edi,2;

JMP_A:
	inc		edi;
	cmp		edi, dword ptr [rbx+10h];
	mov		r8d, dword ptr [rsp+1158h+18h];
	lea		r10, [rsi + 120h];
	push	eventDialogProc3ReturnAddress;
	ret;
eventDialogProc3V132 ENDP

END