; r13は文字列ループのカウンタ。フォントに文字があってもなくても関係ない
; r10は文字列のlenght
; edx（[rbp+1D0h+var_138]）は文字ポジションカウンタ

EXTERN	mapJustifyProc1ReturnAddress1	:	QWORD
EXTERN	mapJustifyProc1ReturnAddress2	:	QWORD
EXTERN	mapJustifyProc2ReturnAddress	:	QWORD
EXTERN	mapJustifyProc4ReturnAddress	:	QWORD

;temporary space for code point
.DATA
	mapJustifyProc1TmpFlag	DB	0
	debug	DQ	0

NO_FONT			=	98Fh
NOT_DEF			=	2026h
MAP_LIMIT		=	2Dh-3

.CODE
mapJustifyProc1 PROC
	movss   xmm9, dword ptr [rcx + 848h];

	mov		debug, rax;

	push	rdx;
	cmp     byte ptr[rax + r13], 0C2h;
	jbe		JMP_NOTUTF8;
	cmp		byte ptr [rax + r13 + 1], 80h
	jb		JMP_NOTUTF8;
	cmp		byte ptr [rax + r13 + 1], 0BFh
	ja		JMP_NOTUTF8;
	jmp		JMP_A

JMP_NOTUTF8:
	movzx   edx, byte ptr[rax + r13];
	mov		esi, edx;
	mov		mapJustifyProc1TmpFlag, 0;
	jmp		JMP_RET1

JMP_A:
	movzx   dx, byte ptr [rax + r13];
	and     dx, 1Fh;
	cmp     byte ptr [rax + r13], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rax;
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + r13];

JMP_B:
	inc		rax;
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + r13]
	mov		rax, debug;
	; ここのdecが文字のつまりを制御している
	dec		r10;
	cmp		r13,MAP_LIMIT;
	ja		JMP_NOTDEF
	test	dh, dh;
	jz		JMP_G
	cmp		edx, NO_FONT;
	ja		JMP_G;

JMP_NOTDEF:
	mov		esi, NOT_DEF;

JMP_G:
	mov		mapJustifyProc1TmpFlag, 1;
	mov		esi, 10h; 下の方でsilを比較して'や.と比較しているのでいるので適当に埋める

JMP_RET1:
	mov     rdi, qword ptr [rcx + rdx * 8];
	pop		rdx;
	test	rdi, rdi;
	jz		JMP_RET2;
	push	mapJustifyProc1ReturnAddress1;
	ret;

JMP_RET2:
	push	mapJustifyProc1ReturnAddress2;
	ret;
mapJustifyProc1 ENDP

;-------------------------------------------;

mapJustifyProc2 PROC
	cmp		mapJustifyProc1TmpFlag, 1h;
	jnz		JMP_A;

	; 3byte = 1文字かどうか
	cmp		r10, 2; 
	ja		JMP_A;
	add		r10, 2;
	mov		edx, 1;

JMP_A:
	movd    xmm6, edx;

	cmp		mapJustifyProc1TmpFlag, 1h;
	jz		JMP_B;

	lea     eax, [r10 - 1]; ; -1している
	jmp		JMP_C;

JMP_B:
	lea     eax, [r10 - 2]; ; -2している

JMP_C:
	movd    xmm0, eax;
	cvtdq2ps xmm0, xmm0;

	push	mapJustifyProc2ReturnAddress;
	ret;
mapJustifyProc2 ENDP

;-------------------------------------------;

mapJustifyProc4 PROC
	movsd   xmm3, qword ptr [rbp + 1D0h - 168h];

	cmp		mapJustifyProc1TmpFlag, 1h;
	jnz		JMP_A;
	
	add     edx,2;
	add     r13,2;
JMP_A:
	inc     edx;
	inc     r13;

JMP_C:
	movsd   xmm4, qword ptr [rbp + 1D0h - 1B0h];
	movsd   xmm5, qword ptr [rbp + 1D0h - 1A8h];
	movsxd  rax, r10d;
	mov     qword ptr [rbp + 1D0h - 138h], rdx;

	push	mapJustifyProc4ReturnAddress;
	ret;
mapJustifyProc4 ENDP

END