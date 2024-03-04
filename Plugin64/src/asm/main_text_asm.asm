EXTERN mainTextProc1ReturnAddress: QWORD
EXTERN mainTextProc2ReturnAddress: QWORD
EXTERN mainTextProc2BufferAddress: QWORD
EXTERN mainTextProc3ReturnAddress1: QWORD
EXTERN mainTextProc3ReturnAddress2: QWORD
EXTERN mainTextProc4ReturnAddress: QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

;temporary space for code point
.DATA
	mainTextProc2TmpCharacter	DD	0

.CODE
mainTextProc1 PROC
	movsxd	rax, edi;

	cmp     byte ptr[rax + rbx], 0C2h;
	ja      JMP_A;
	movzx   eax, byte ptr[rax + rbx];
	jmp 	JMP_E;

JMP_A:
	movsxd  rdi, edi;
	movzx   eax, byte ptr [rdi + rbx];
	and     ax, 1Fh;
	cmp     byte ptr [rdi + rbx], 0E0h;
	jb      JMP_B;
	and     ax, 0Fh;

	inc		rdi;
	rol     ax, 6;
	xor     al, 80h;
	xor     al, byte ptr [rdi + rbx];

JMP_B:
	inc		rdi;
	rol     ax, 6;
	xor     al, 80h;
	xor     al, byte ptr [rdi + rbx]

JMP_C:
	movzx 	eax, ax;
	cmp		ax, NO_FONT;

	ja		JMP_E;
	mov		ax, NOT_DEF;


JMP_E:
	movss	xmm3, dword ptr [r15+848h];
	mov		rbx, qword ptr [r15+rax*8];
	mov		qword ptr [rbp+100h], rbx;

	push	mainTextProc1ReturnAddress;
	ret;
mainTextProc1 ENDP

;-------------------------------------------;

mainTextProc2 PROC
	push	mainTextProc2ReturnAddress;
	ret;
mainTextProc2 ENDP

;-------------------------------------------;

mainTextProc2_v131 PROC
	movsxd  rdx, edi;
	movsxd  rcx, r14d;
	mov     r10, [rbp+750h-7D0h];

	movzx	eax, byte ptr [rdx + r10];
	mov		r9, mainTextProc2BufferAddress;
	mov     byte ptr [rcx+r9], al;

	inc     r14d;
	inc		rcx;

	cmp 	al, 0C0h;
	jb		JMP_A;
	mov 	edi, eax;
	and		edi, 1Fh;
	cmp		al, 0E0h;
	jb		JMP_B;
	and		edi, 0Fh

	inc 	rdx;
	rol		edi, 6;
	xor		edi, 80h;
	movzx 	eax, byte ptr [rdx + r10];
	xor		edi, eax;
	mov		byte ptr [rcx + r9], al;
	inc		rcx;
	inc		r14d;

JMP_B:
	inc 	rdx;
	rol		edi, 6;
	xor		edi, 80h;
	movzx 	eax, byte ptr [rdx + r10];
	xor		edi, eax;
	mov		byte ptr [rcx + r9], al;
	inc		rcx;
	inc		r14d;

	mov 	eax, edi;
	mov		edi, edx;
JMP_A:
	mov		mainTextProc2TmpCharacter, eax;
	
	push	mainTextProc2ReturnAddress;
	ret;
mainTextProc2_v131 ENDP

;-------------------------------------------;

mainTextProc3 PROC
	cmp		word ptr [rcx+6],0;
	jnz		JMP_A;
	jmp		JMP_B;

JMP_A:
	cmp		mainTextProc2TmpCharacter, 00FFh;
	ja		JMP_B;

	push	mainTextProc3ReturnAddress2;
	ret;
	
JMP_B:
	lea     eax, dword ptr [rbx+rbx];
	movd    xmm1, eax;

	push	mainTextProc3ReturnAddress1;
	ret;

mainTextProc3 ENDP

;-------------------------------------------;

mainTextProc4 PROC
	; check code point saved proc1
	cmp		mainTextProc2TmpCharacter, 00FFh;
	ja		JMP_A;

	movzx	eax, byte ptr[rdx + r10];
	jmp		JMP_B;

JMP_A:
	mov		eax, mainTextProc2TmpCharacter;

JMP_B:
	mov		rcx, qword ptr [r15 + rax*8];
	mov		qword ptr [rbp-60h],rcx;
	test	rcx,rcx;

	push	mainTextProc4ReturnAddress;
	ret;
mainTextProc4 ENDP

END