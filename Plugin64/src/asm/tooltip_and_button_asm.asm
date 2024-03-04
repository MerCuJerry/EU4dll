EXTERN	tooltipAndButtonProc1ReturnAddress	:	QWORD
EXTERN	tooltipAndButtonProc1CallAddress	:	QWORD
EXTERN	tooltipAndButtonProc2ReturnAddress	:	QWORD
EXTERN	tooltipAndButtonProc3ReturnAddress	:	QWORD
EXTERN	tooltipAndButtonProc4ReturnAddress1	:	QWORD
EXTERN	tooltipAndButtonProc4ReturnAddress2	:	QWORD
EXTERN	tooltipAndButtonProc5ReturnAddress1	:	QWORD
EXTERN	tooltipAndButtonProc5ReturnAddress2	:	QWORD
EXTERN	tooltipAndButtonProc7ReturnAddress1	:	QWORD
EXTERN	tooltipAndButtonProc7ReturnAddress2	:	QWORD
EXTERN	tooltipAndButtonProc8ReturnAddress1	:	QWORD
EXTERN	tooltipAndButtonProc9ReturnAddress1	:	QWORD
EXTERN	tooltipAndButtonProc9ReturnAddress2	:	QWORD
EXTERN	tooltipAndButtonProc10ReturnAddress1	:	QWORD
EXTERN	tooltipAndButtonProc10BufferWidth	:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

; temporary space for code point
.DATA
	tooltipAndButtonProc2TmpCharacter			DD	0
	tooltipAndButtonProc2TmpCharacterAddress	DQ	0
	tooltipAndButtonProc2TmpFlag				DD	0

.CODE
tooltipAndButtonProc1V133 PROC
	cmp		byte ptr [rax + rcx], 0C2h
	ja		JMP_A;
	
	movzx	r8d, byte ptr[rax + rcx];
	mov     edx, 1;
	lea     rcx, qword ptr [rsp + 22D0h - 2258h];
	mov		tooltipAndButtonProc2TmpFlag, 0h;
	call	tooltipAndButtonProc1CallAddress;

	jmp		JMP_B;
JMP_A:
	mov		tooltipAndButtonProc2TmpFlag, 1h;

	; debug
	mov		r8, qword ptr [rbp + 21D0h - 2220h];

	lea		r8, qword ptr [rax + rcx];
	mov		tooltipAndButtonProc2TmpCharacterAddress, r8;
	movzx	r8d, byte ptr[rax + rcx];
	mov     edx, 3; The memory is allocated 3 byte, but the first byte is copied 3 times.
	lea     rcx, qword ptr [rsp + 22D0h - 2258h];
	call	tooltipAndButtonProc1CallAddress;

	; overwrite
	mov		rcx, tooltipAndButtonProc2TmpCharacterAddress;
	mov		cx, word ptr [rcx+1];
	mov		word ptr [rax+1], cx; 
JMP_B:
	push	tooltipAndButtonProc1ReturnAddress;
	ret;
tooltipAndButtonProc1V133 ENDP

;-------------------------------------------;

tooltipAndButtonProc2V133 PROC
	mov		edx, ebx;

	cmp     byte ptr[rax + rdx], 0C2h;
	ja      JMP_A;
	movzx   eax, byte ptr[rax + rdx];
	jmp 	JMP_G;

JMP_A:
	push	rdi;
	mov 	rdi, rdx;
	movzx   dx, byte ptr [rax + rdi];
	and     dx, 1Fh;
	cmp     byte ptr [rax + rdi], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rax;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi];

JMP_B:
	inc		rax;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi]

	movzx	eax, dx;
	mov		rdx, rdi;
	pop 	rdi;
	add		edx,2;
	;mov		dword ptr [rbp+6E0h- 6C0h], ebx;

	cmp		eax, NO_FONT;
	ja		JMP_G;
	mov		eax, NOT_DEF;

JMP_G:
	mov		rcx, qword ptr [r15 + rax * 8];
	mov		qword ptr [rbp + 21D0h - 21F0h], rcx; 

	mov		tooltipAndButtonProc2TmpCharacter, eax;

	push	tooltipAndButtonProc2ReturnAddress;
	ret;
tooltipAndButtonProc2V133 ENDP

;-------------------------------------------;

tooltipAndButtonProc3 PROC
	mov     ecx, ebx;
	movss   xmm10, dword ptr [r15 + 848h];

	cmp     byte ptr[rax + rcx], 0C2h;
	ja      JMP_A;
	movzx   eax, byte ptr[rax + rcx];
	jmp 	JMP_G;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [rax + rcx];
	and     dx, 1Fh;
	cmp     byte ptr [rax + rcx], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rax;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rcx];

JMP_B:
	inc		rax;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rcx]

	movzx	eax, dx; 	
	pop 	rdx;

JMP_F:
	add		ebx, 2;
	cmp		eax, NO_FONT;
	ja		JMP_G;
	mov		eax, NOT_DEF;

JMP_G:
	mov     r11, qword ptr [r15 + rax * 8];

	push	tooltipAndButtonProc3ReturnAddress;
	ret;
tooltipAndButtonProc3 ENDP

;-------------------------------------------;

tooltipAndButtonProc4V133 PROC
	cmp		word ptr [rcx + 6], 0
	jz		JMP_A;

	cmp		tooltipAndButtonProc2TmpCharacter, 00FFh;
	ja		JMP_X;

	push	tooltipAndButtonProc4ReturnAddress1;
	ret;

JMP_X:
	nop;

JMP_A:
	cmp     dword ptr [rbp + 21D0h - 2210h], 0;
	push	tooltipAndButtonProc4ReturnAddress2;
	ret;
tooltipAndButtonProc4V133 ENDP
;-------------------------------------------;

tooltipAndButtonProc5V130 PROC
	lea     rcx, qword ptr [r12 + 120h];

	cmp     byte ptr[rbx + r14], 0C2h;
	ja      JMP_A;
	movzx   edx, byte ptr[rbx + r14];
	jmp 	JMP_G;

JMP_A:
	movzx   dx, byte ptr [rbx + r14];
	and     dx, 1Fh;
	cmp     byte ptr [rbx + r14], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rbx;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rbx + r14];

JMP_B:
	inc		rbx;
	rol     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rbx + r14]

JMP_F:
	movzx	edx, dx;
	cmp		edx, NO_FONT;
	ja		JMP_H;
	mov		edx, NOT_DEF;

JMP_H:
	inc		rbx;
	add		edi, 3;
	cmp		rbx, r13;
	ja		JMP_J;
	dec		rbx;
	dec		edi;

JMP_G:
	mov     rsi, qword ptr [rcx + rdx * 8];
	test    rsi, rsi;

	push	tooltipAndButtonProc5ReturnAddress1;
	ret;

JMP_J:
	movd    xmm0, eax
	push	tooltipAndButtonProc5ReturnAddress2;
	ret;
tooltipAndButtonProc5V130 ENDP

;-------------------------------------------;

tooltipAndButtonProc7V133 PROC
	cmp		tooltipAndButtonProc2TmpFlag, 1;
	jnz		JMP_A;

	add		ebx,2;

JMP_A:
	inc		ebx;
	cmp     ebx, dword ptr [rbp + 21D0h - 2228h];
	jge		JMP_B;
	push	tooltipAndButtonProc7ReturnAddress1;
	ret;

JMP_B:
	; debug
	mov		rdi, qword ptr [rbp + 21D0h - 2220h];

	push	tooltipAndButtonProc7ReturnAddress2;
	ret;
tooltipAndButtonProc7V133 ENDP


;-------------------------------------------;

tooltipAndButtonProc8 PROC
	mov     eax, [rbp + 22A0h - 2294h]
	xorps   xmm0, xmm0
	cvtsi2ss xmm0, rax
	comiss  xmm1, xmm0

	push	tooltipAndButtonProc8ReturnAddress1;
	ret;
tooltipAndButtonProc8 ENDP

;-------------------------------------------;

tooltipAndButtonProc9 PROC
	lea     rax, [rsp + 22D0h - 2280h]
	cmp     rdi, 10h
	cmovnb  rax, rsi
	cmp     byte ptr [rax+rdx], 0Ah
	jz      JMP_A;

	lea     rax, [rsp + 22D0h - 2280h]
	cmp     rdi, 10h
	cmovnb  rax, rsi
	cmp     byte ptr [rax + rdx], 0Dh
	jnz     JMP_B;

JMP_A:
	push	tooltipAndButtonProc9ReturnAddress1;
	ret;

JMP_B:
	push	tooltipAndButtonProc9ReturnAddress2;
	ret;

tooltipAndButtonProc9 ENDP

;-------------------------------------------;

tooltipAndButtonProc10 PROC
	movaps  xmm6, [rsp + 0F8h - 38h]
	mov		r15, tooltipAndButtonProc10BufferWidth;
	add		rax, r15
	add     rsp, 0F0h
	pop     r15

	push	tooltipAndButtonProc10ReturnAddress1;
	ret;
tooltipAndButtonProc10 ENDP

END