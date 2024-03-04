EXTERN	mapAdjustmentProc1ReturnAddress		:	QWORD
EXTERN	mapAdjustmentProc1CallAddress		:	QWORD
EXTERN	mapAdjustmentProc2ReturnAddress		:	QWORD
EXTERN	mapAdjustmentProc3ReturnAddress1	:	QWORD
EXTERN	mapAdjustmentProc3ReturnAddress2	:	QWORD
EXTERN	mapAdjustmentProc4ReturnAddress		:	QWORD
EXTERN	mapAdjustmentProc5ReturnAddress		:	QWORD
EXTERN	mapAdjustmentProc5SeparatorAddress	:	QWORD


NO_FONT			=	98Fh
NOT_DEF			=	2026h
MAP_LIMIT		=	2Dh-1

.DATA
DefaultSeparator	DB	" ", 0

.CODE
mapAdjustmentProc1 PROC
	movsx	ecx, byte ptr[rdi + rbx];
	cmp		ecx, 0C0h;
	jb		JMP_D;
	cmp		ecx, 0E0h;
	jb		JMP_A;

	inc		r14d;
	jmp		JMP_A;

JMP_D:
	call	mapAdjustmentProc1CallAddress;
	mov     byte ptr [rdi + rbx], al;
	inc     r14d;

	jmp		JMP_B;

JMP_A:
	add		r14d, 2;
JMP_B:
	mov     ebx, r14d;

	cmp		r14d, 45;
	jbe		JMP_C;
	nop;
JMP_C:
	push	mapAdjustmentProc1ReturnAddress;
	ret;
mapAdjustmentProc1 ENDP

;-------------------------------------------;

mapAdjustmentProc2V130 PROC
	cmp		al, 0C0h;
	jb		JMP_D;
	cmp		al, 0E0h;
	jb		JMP_A;
	jmp		JMP_E;

JMP_D:
	lea     rax, qword ptr [rbp + 200h - 200h];
	or      r8, 0FFFFFFFFFFFFFFFFh;
	nop;

JMP_B:
	inc     r8;
	cmp     byte ptr [rax+r8], 0;
	jnz		JMP_B;
	jmp		JMP_C;

JMP_A:
	mov		r8, 2;
JMP_E:
	mov		r8, 3;

	lea     rax, qword ptr [rbp + 200h - 160h];
	cmp     qword ptr [rbp + 200h - 148h], 10h;
	cmovnb  rax, qword ptr [rbp + 200h - 160h];
	mov		dx, word ptr [rbx + rax + 1];

	mov		word ptr[rbp + 200h - 200h + 1], dx;
	add		rbx, 2;

JMP_C:
	push	mapAdjustmentProc2ReturnAddress;
	ret;
mapAdjustmentProc2V130 ENDP

;-------------------------------------------;

mapAdjustmentProc3V130 PROC
	mov		dword ptr[rbp + 200h - 200h], 0000h;
	cmp     rbx, rdi;
	jz		JMP_A;
	or      r9, 0FFFFFFFFFFFFFFFFh;
	xor     r8d, r8d;
	lea     rdx, qword ptr [rbp + 200h - 130h];
	lea     rcx, qword ptr [rbp + 200h - 1D0h];

	push	mapAdjustmentProc3ReturnAddress1;
	ret;

JMP_A:
	push	mapAdjustmentProc3ReturnAddress2;
	ret;
mapAdjustmentProc3V130 ENDP

;-------------------------------------------;

mapAdjustmentProc4V130 PROC
	lea		rax, [rbp + 200h - 160h];
	cmp		r8, 10h;
	cmovnb	rax, r9;

	cmp     byte ptr[rax + rcx], 0C2h;
	ja      JMP_A;
	movzx   eax, byte ptr[rax + rcx];
	jmp 	JMP_E;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [rax + rcx];
	and     dx, 1Fh;
	cmp     byte ptr [rax + rcx], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rcx;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rcx];

JMP_B:
	inc		rcx;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rcx]

	movzx	eax, dx; 	
	pop 	rdx;
	cmp		rcx, MAP_LIMIT;
	ja		JMP_G;

	cmp		eax, NO_FONT;
	ja		JMP_E;
JMP_G:
	mov		eax, NOT_DEF;
	movzx	eax, ax;

JMP_E:

	push	mapAdjustmentProc4ReturnAddress;
	ret;
mapAdjustmentProc4V130 ENDP

;-------------------------------------------;

mapAdjustmentProc5 PROC
	; ex) {�A���S��}�̃V�`���A ; {} = [rbp+190h-118h
	lea     rdx, [rbp+190h-118h];
	movsxd	rcx,dword ptr [rdx+10h];
	cmp		rcx , 10h;
	jle		JMP_A;
	mov		rdx, qword ptr [rdx];

JMP_A:
	; {}�̍Ō�̕������}���`�o�C�g�ł��邩���m�F����
	; ��납��3�o�C�g�ڂ��擾����B2�o�C�g�ȉ��Ȃ�΃X�L�b�v
	cmp		rcx,3;
	jb		JMP_B;

	mov		dl, byte ptr[rdx + rcx - 3];

	cmp		dl, 80h;
	jb		JMP_B;

	mov		r8,	mapAdjustmentProc5SeparatorAddress;
	jmp		JMP_C;

JMP_B: ;�p��
	lea		r8,	DefaultSeparator;

JMP_C:
	lea     rcx, [rbp+190h-50h]; ���ɖ߂�
	lea     rdx, [rbp+190h-118h]; ���ɖ߂�
	push	mapAdjustmentProc5ReturnAddress;
	ret;
mapAdjustmentProc5 ENDP
END