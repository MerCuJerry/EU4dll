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
	cmp		ecx, 0C2h;
	jbe		JMP_D;
	cmp		byte ptr[rdi + rbx + 1], 80h
	jb		JMP_D
	cmp		byte ptr[rdi + rbx + 1], 0BFh
	ja		JMP_D
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
	cmp		al, 0C2h;
	jbe		JMP_D;
	mov		r8, 2;
	cmp		al, 0E0h;
	jb		JMP_E;
	inc		r8
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

JMP_E:
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
	jbe		JMP_NOTUTF8;
	cmp		byte ptr [rax + rcx + 1], 80h
	jb		JMP_NOTUTF8;
	cmp		byte ptr [rax + rcx + 1], 0BFh
	ja		JMP_NOTUTF8;
	jmp		JMP_A

JMP_NOTUTF8:
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
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rcx];

JMP_B:
	inc		rcx;
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rcx]

	movzx	eax, dx; 	
	pop 	rdx;
	cmp		rcx, MAP_LIMIT;
	ja		JMP_G;
	test	ah, ah;
	jz		JMP_E
	cmp		eax, NO_FONT;
	ja		JMP_E;
JMP_G:
	mov		eax, NOT_DEF;

JMP_E:
	push	mapAdjustmentProc4ReturnAddress;
	ret;
mapAdjustmentProc4V130 ENDP

;-------------------------------------------;

mapAdjustmentProc5 PROC
	; ex) {アラゴン}領シチリア ; {} = [rbp+190h-118h
	lea     rdx, [rbp+190h-118h];
	movsxd	rcx,dword ptr [rdx+10h];
	cmp		rcx , 10h;
	jle		JMP_A;
	mov		rdx, qword ptr [rdx];

JMP_A:
	; {}の最後の文字がマルチバイトであるかを確認する
	; 後ろから3バイト目を取得する。2バイト以下ならばスキップ
	cmp		rcx,3;
	jb		JMP_B;

	mov		dl, byte ptr[rdx + rcx - 3];

	cmp		dl, 80h;
	jb		JMP_B;

	mov		r8,	mapAdjustmentProc5SeparatorAddress;
	jmp		JMP_C;

JMP_B: ;英語
	lea		r8,	DefaultSeparator;

JMP_C:
	lea     rcx, [rbp+190h-50h];  元に戻す
	lea     rdx, [rbp+190h-118h];  元に戻す
	push	mapAdjustmentProc5ReturnAddress;
	ret;
mapAdjustmentProc5 ENDP
END