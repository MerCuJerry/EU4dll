EXTERN	originalinputProcAddress	:	QWORD
EXTERN	inputProc1ReturnAddress2	:	QWORD
EXTERN	inputProc2ReturnAddress		:	QWORD
EXTERN	KeyPadLeftReturnAddress		:	QWORD
EXTERN	CursorAtZeroReturnAddress	:	QWORD
EXTERN 	KeyPadRightReturnAddress	:	QWORD
EXTERN  KeyPadRightProcCallAddress	:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

.DATA
	inputProc1Var1	DB		03,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
	inputProc2Tmp	DQ		0
	deleteProcFlag	DB		00
.CODE

inputProc1V130 PROC
	; ebxにはIMEからutf8の文字が渡されてくる
	mov		ebx, dword ptr [rbp + 120h - 18Ch];
	; if bl is less than C3, this character must be 1 byte in Unicode;
	cmp		bl, 0C3h;
	ja		JMP_A;

	; change original code, not use rax anymore;
	cmp		bl, 80h;
	jb		JMP_Y;

	shl		bl, 6;
	xor		bl, 80h;
	xor		bl, bh;

JMP_Y:
	push	originalinputProcAddress;
	ret;

JMP_A:
	; null文字チェック null check
	test	bl,bl;
	je		JMP_B;
	; そのままコピーした
	mov		rax, [r13 + 0];
	xor		r9d,r9d;
	mov		r8d, [rbp + 120h - 184h];
	mov		edx,303h;
	mov		rcx,r13;
	call	qword ptr [rax + 20h];

	; character count fix
	mov		dword ptr [r14+44h] , 2

	; eu4.00007FF7740F6122
	mov		rax, [r14];
	lea     rdx, [rsp+220h - 1F0h];
	xorps	xmm0, xmm0;
	mov		byte ptr [rsp + 220h - 1E0h], bl;
	movdqu	xmmword ptr [rsp + 220h - 1F0h], xmm0;
	mov		rcx, r14;
	mov		dword ptr [rsp + 220h + 1CCh], 0;
	movdqa  xmm0, xmmword ptr [inputProc1Var1];
	xorps   xmm1, xmm1;
	movdqu  xmmword ptr [rsp + 220h - 1B8h], xmm0;
	mov		dword ptr [rsp + 220h - 1C4h], esi;
	movdqu	xmmword ptr [rsp + 220h - 1DCh], xmm1;
	mov		qword ptr [rsp + 220h - 1C0h], rsi;
	mov		dword ptr [rsp + 220h - 1A8h], esi;
	mov		dword ptr [rbp + 120h - 1A0h], 2;
	mov		word ptr [rbp + 120h - 19Ch], si;
	mov		byte ptr [rbp + 120h - 19Ah], 0;
	call	qword ptr [rax + 18h];

	; 1byte進める
	shr		ebx, 8;
	jnz		JMP_A;

JMP_B:
	;戻す
	push	inputProc1ReturnAddress2;
	ret;
inputProc1V130 ENDP

;-------------------------------------------;

; 下記はqword ptr [rax+138h];の関数（40 57 48 83 EC 20 48 8B 01 48 8B F9 48 8B 90 68 01 00 00）から割り出した
; rdi+54h : キャレット位置
; rdi+40h : 文字列長さ
; rdi+30h : 文字列アドレス

inputProc2 PROC
	mov		inputProc2Tmp,rsi; // カウンタとして使う
	xor		rsi,rsi; 

	mov		rcx, qword ptr [rdi + 40h];
	cmp		rcx, 10h;
	lea		rcx, [rdi + 30h];
	jbe		JMP_A;
	mov		rcx, [rcx];
	
JMP_A:
	movsxd	rax, dword ptr [rdi + 54h];
	inc		rsi;
	cmp		rax, 3;
	jb		JMP_C;
	cmp		byte ptr [rcx + rax - 2], 80h;
	jb		JMP_C;
	inc		rsi;
	cmp		byte ptr [rcx + rax - 3], 0E0h;
	jb		JMP_C;
	inc		rsi;

JMP_C:
	mov		deleteProcFlag, 1;
	mov		rax, qword ptr [rdi];
	mov		rcx, rdi;
	test	ebx, ebx;
	jz		JMP_D;
	call	qword ptr [rax+140h];
	jmp		JMP_E;

JMP_D:
	call	qword ptr [rax+138h];

JMP_E:
	dec		rsi;
	jnz		JMP_C;

JMP_F:
	mov		rsi,inputProc2Tmp;

	push	inputProc2ReturnAddress;
	ret;
inputProc2 ENDP

;-------------------------------------------;

; this proc is using by deleteproc
KeyPadLeftProc PROC
	push 	rdi;
	sub 	rsp, 40h
	movzx	rax, word ptr [rcx + 54h]
	mov 	rdi, rcx
	test 	ax, ax
	jz		JMP_A;
	
	dec		ax;
	jz		JMP_B; prevent ax below 0
	cmp		deleteProcFlag, 1;tmp fix working well smt
	jz		JMP_C;
	cmp		byte ptr[rax + rcx + 30h - 1], 80h;
	jb		JMP_B;
	dec		ax;
	jz		JMP_B;
	cmp		byte ptr[rax + rcx + 30h - 1], 0E0h;
	jb		JMP_B;
	dec		ax;

JMP_B:
	push	KeyPadLeftReturnAddress;
	ret;

JMP_C:
	mov		deleteProcFlag, 0;
	jmp 	JMP_B

JMP_A:
	push	CursorAtZeroReturnAddress;
	ret;

KeyPadLeftProc ENDP

;-------------------------------------------;

KeyPadRightProc PROC
	mov		rcx, rdi;
	lea		rdx,[rax + 1];
	cmp		byte ptr[rdi + 30h], 0C0h
	jb		JMP_A;
	inc		rdx;
	cmp		byte ptr[rdi + 30h], 0E0h
	jb		JMP_A;
	inc		rdx;

JMP_A:
	call	KeyPadRightProcCallAddress
	movzx	eax, word ptr[rdi + 54h]
	push	KeyPadRightReturnAddress
	ret

KeyPadRightProc ENDP
END