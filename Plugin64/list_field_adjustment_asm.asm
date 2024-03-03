EXTERN	listFieldAdjustmentProc1ReturnAddress	:	QWORD
EXTERN	listFieldAdjustmentProc2ReturnAddress	:	QWORD
EXTERN	listFieldAdjustmentProc3ReturnAddress	:	QWORD
EXTERN	listFieldAdjustmentProc2V1315ReturnAddress : QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

; temporary space
.DATA
	listFieldAdjustmentProc1MultibyteFlag			DD	0
	listFieldAdjustmentProc2MultibyteFlag			DD	0

.CODE
listFieldAdjustmentProc1 PROC
	push	listFieldAdjustmentProc1ReturnAddress;
	ret;
listFieldAdjustmentProc1 ENDP

;-------------------------------------------;

listFieldAdjustmentProc1_v131 PROC
	push	listFieldAdjustmentProc1ReturnAddress;
	ret;
listFieldAdjustmentProc1_v131 ENDP

;-------------------------------------------;

listFieldAdjustmentProc1_v1315 PROC
	mov		rcx, qword ptr [rbp + 0D0h - 130h];
	movss	xmm6, dword ptr [rcx + 848h];

	cmp     byte ptr[r12 + rax], 7Eh;
	ja      JMP_A;
	movzx   eax, byte ptr[r12 + rax];
	mov		listFieldAdjustmentProc1MultibyteFlag, 0;
	jmp 	JMP_G;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [r12 + rax];
	and     dx, 1Fh;
	cmp     byte ptr [r12 + rax], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rax;
	rcl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [r12 + rax];

JMP_B:
	inc		rax;
	rcl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [r12 + rax]

	movzx	eax, dx;
	pop 	rdx;
	mov		listFieldAdjustmentProc1MultibyteFlag, 1;
	cmp		eax, NO_FONT;
	ja		JMP_G;
	mov		eax, NOT_DEF;

JMP_G:
	mov     r15, qword ptr [rcx + rax * 8];
	test    r15, r15;

	push	listFieldAdjustmentProc1ReturnAddress;
	ret;
listFieldAdjustmentProc1_v1315 ENDP

;-------------------------------------------;

listFieldAdjustmentProc2 PROC
	cmp		listFieldAdjustmentProc1MultibyteFlag, 1h;
	jnz		JMP_A;
	mov		listFieldAdjustmentProc2MultibyteFlag, 1h;
	add		ebx,2;

JMP_A:
	inc		ebx;
	mov		listFieldAdjustmentProc1MultibyteFlag, 0h; reset

	mov		r9, qword ptr [rdi + 10h];
	movzx	edx, byte ptr [rbp + 0B0h + 048h];arg_8=0x48
	cmp		ebx, r9d;

	push	listFieldAdjustmentProc2ReturnAddress;
	ret;
listFieldAdjustmentProc2 ENDP

;-------------------------------------------;

listFieldAdjustmentProc2_v131 PROC
	cmp		listFieldAdjustmentProc1MultibyteFlag, 1h;
	jnz		JMP_A;
	mov		listFieldAdjustmentProc2MultibyteFlag, 1h;
	add		ebx,2;

JMP_A:
	inc		ebx;
	mov		listFieldAdjustmentProc1MultibyteFlag, 0h; reset

	mov		r10, qword ptr [rdi + 10h];
	movzx	edx, byte ptr [rbp + 0C0h + 048h];arg_38=0x48
	cmp		ebx, r10d;

	push	listFieldAdjustmentProc2ReturnAddress;
	ret;
listFieldAdjustmentProc2_v131 ENDP

;-------------------------------------------;

listFieldAdjustmentProc2_v1315 PROC
	cmp		listFieldAdjustmentProc1MultibyteFlag, 1h;
	jnz		JMP_A;
	mov		listFieldAdjustmentProc2MultibyteFlag, 1h;
	add		ebx,2;

JMP_A:
	inc		ebx;
	mov		listFieldAdjustmentProc1MultibyteFlag, 0h; reset

	mov		r9, qword ptr [rdi + 10h];
	cmp		ebx, r9d;
	jge		JMP_B;

	push	listFieldAdjustmentProc2ReturnAddress;
	ret;

JMP_B:
	push	listFieldAdjustmentProc2V1315ReturnAddress;
	ret;

listFieldAdjustmentProc2_v1315 ENDP

;-------------------------------------------;

listFieldAdjustmentProc3 PROC
	mov		rcx, qword ptr [rax + rcx * 8];
	mov		r9d, dword ptr [rcx + rdx * 4];

	cmp		listFieldAdjustmentProc2MultibyteFlag, 1h;
	jnz		JMP_A;
	mov		r9d, ebx;
	sub		r9d, 3;

JMP_A:
	xor		r8d, r8d;
	lea		rdx, [rsp + 180h - 160h];
	mov		rcx, rdi;

	push	listFieldAdjustmentProc3ReturnAddress;
	ret;
listFieldAdjustmentProc3 ENDP

;-------------------------------------------;

listFieldAdjustmentProc3_v1315 PROC
	mov		rcx, qword ptr [rax + rcx * 8];
	mov		r9d, dword ptr [rcx + rdx * 4];

	cmp		listFieldAdjustmentProc2MultibyteFlag, 1h;
	jnz		JMP_A;
	mov		r9d, ebx;
	sub		r9d, 3;

JMP_A:
	xor		r8d, r8d;
	lea		rdx, [rsp + 1D0h - 1A8h];
	mov		rcx, rdi;

	push	listFieldAdjustmentProc3ReturnAddress;
	ret;
listFieldAdjustmentProc3_v1315 ENDP
END