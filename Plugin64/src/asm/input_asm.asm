EXTERN	inputProc1ReturnAddress1	:	QWORD
EXTERN	inputProc1ReturnAddress2	:	QWORD
EXTERN	inputProc2ReturnAddress		:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

.DATA
	inputProc1Var1	DB		03,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
	inputProc2Tmp	DQ		0
	inputProc2Tmp2	DQ		0

.CODE

inputProc1V130 PROC
	; eaxにはIMEからutf8の文字が渡されてくる
	mov		eax, dword ptr [rbp + 120h - 18Ch];
	; ahが0であればa-zなどの1byteで収まる文字なので、変換処理は必要ない
	cmp		ah, 0;
	jnp		JMP_A;
	xor		bl, bl;

	; JMP_X,Yについての説明。MakeJMPでコードが破壊されてしまうため、処理を丸ごとコピーしてきている。
	; ここで80hと比較しているのはUTF8でU+0000 … U+007Fかどうか確認するため
	; https://ja.wikipedia.org/wiki/UTF-8
	cmp		al, 80h;
	jnb		JMP_X;
	mov		ebx, eax;
	jmp     JMP_Y;

JMP_X:
	cmp		al, 0E0h;
	jnb		JMP_Y;
	movzx	ebx, byte ptr [rbp + 120h - 18Ch + 1];
	and		bl, 3Fh;
	shl		al, 6;
	or		bl, al;

JMP_Y:
	push	inputProc1ReturnAddress1;
	ret;

JMP_A:	; Change here can support
	lea		rax,[rbp + 120h - 18Ch];
	mov		inputProc2Tmp, rax;
	;カウンタとして使うのでもともとあったものは保存
	push	rdi;
	xor		rdi,rdi;

JMP_B:
	; そのままコピーした
	mov		rax, [r13 + 0];
	xor		r9d,r9d;
	mov		r8d, [rbp + 120h - 184h];
	mov		edx,303h;
	mov		rcx,r13;
	call	qword ptr [rax + 20h];

	; １byte取り出す Change here
	mov		rbx, inputProc2Tmp;
	mov		bl, byte ptr [rbx + rdi];

	; null文字チェック
	test	bl,bl;
	je		JMP_C;

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
	inc		rdi;
	jmp		JMP_B;

JMP_C:
	;戻す
	pop		rdi;
	push	inputProc1ReturnAddress2;
	ret;
inputProc1V130 ENDP

;-------------------------------------------;

; 下記はqword ptr [rax+138h];の関数（40 57 48 83 EC 20 48 8B 01 48 8B F9 48 8B 90 68 01 00 00）から割り出した
; rdi+54h : キャレット位置
; rdi+40h : 文字列長さ
; rdi+30h : 文字列アドレス

inputProc2 PROC
	mov		inputProc2Tmp2,rsi; // カウンタとして使う
	xor		rsi,rsi; 

	mov		rcx, qword ptr [rdi + 40h];
	cmp		rcx, 10h;
	lea		rcx, [rdi + 30h];
	jbe		JMP_A;
	mov		rcx, [rcx];
	
JMP_A:
	movsxd	rax, dword ptr [rdi + 54h];
	sub		rax, 3;
	js		JMP_C;
	mov		al, byte ptr [rcx + rax];
	cmp		al, 0Ch;
	jb		JMP_C;
	cmp		al, 0Eh;
	jb		JMP_B;

	inc		rsi;

JMP_B:
	inc		rsi;

JMP_C:
	mov		rax, qword ptr [rdi];
	mov		rcx, rdi;
	test	ebx, ebx;
	jz		JMP_D;
	call	qword ptr [rax+140h];
	jmp		JMP_E;

JMP_D:
	call	qword ptr [rax+138h];

JMP_E:
	cmp		rsi, 0;
	jz      JMP_F;
	dec		rsi;
	jmp		JMP_C;

JMP_F:
	mov		rsi,inputProc2Tmp2;

	push	inputProc2ReturnAddress;
	ret;
inputProc2 ENDP
END