EXTERN	cBitmapFontProc1ReturnAddress	:	QWORD
EXTERN	cBitmapFontProc2ReturnAddress	:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

.CODE
cBitmapFontProc1 PROC
	;movzx   eax, byte ptr [rdi+rax]
	cmp     byte ptr[rax + rdi], 0C2h;
	jbe		JMP_NOTUTF8;
	cmp		byte ptr [rax + rdi + 1], 80h
	jb		JMP_NOTUTF8;
	cmp		byte ptr [rax + rdi + 1], 0BFh
	ja		JMP_NOTUTF8;
	jmp		JMP_A

JMP_NOTUTF8:
	movzx   eax, byte ptr[rax + rdi];
	jmp 	JMP_H;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [rax + rdi];
	and     dx, 1Fh;
	cmp     byte ptr [rax + rdi], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rdi;
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi];

JMP_B:
	inc		rdi;
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi]

	movzx	eax, dx; 	
	pop 	rdx;
	test	ah, ah;
	jz		JMP_G
	cmp		ax, NO_FONT;
	ja		JMP_G;
	mov		ax, NOT_DEF;

JMP_G:
	xorps   xmm6, xmm6

JMP_H:
	mov     rcx, qword ptr [r15 + rax * 8 + 120h];
	test    rcx, rcx

	push	cBitmapFontProc1ReturnAddress;
	ret;
cBitmapFontProc1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cBitmapFontProc2 PROC
	mov     r13d, edi;
	movss   xmm6, dword ptr [r12+848h];

	cmp     byte ptr[rax + r13], 0C2h;
	jbe		JMP_NOTUTF8;
	cmp		byte ptr [rax + r13 + 1], 80h
	jb		JMP_NOTUTF8;
	cmp		byte ptr [rax + r13 + 1], 0BFh
	ja		JMP_NOTUTF8;
	jmp		JMP_A

JMP_NOTUTF8:
	movzx   eax, byte ptr[rax + r13];
	jmp 	JMP_RET;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [rax + r13];
	and     dx, 1Fh;
	cmp     byte ptr [rax + r13], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rdi;
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi];

JMP_B:
	inc		rdi;
	shl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + rdi]

	movzx	eax, dx; 	
	pop 	rdx;
	test	ah, ah;
	jz		JMP_RET
	cmp		ax, NO_FONT;

	ja		JMP_RET;
	mov		ax, NOT_DEF;

JMP_RET:
	mov     r12, [r12+rax*8];
	test    r12, r12

	push	cBitmapFontProc2ReturnAddress;
	ret;
cBitmapFontProc2 ENDP

END
