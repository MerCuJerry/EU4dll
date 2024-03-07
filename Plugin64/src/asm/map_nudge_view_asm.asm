EXTERN	mapNudgeViewProc1ReturnAddress	:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h
MAP_LIMIT		=	2Dh-1

.CODE
mapNudgeViewProc1V136 PROC
	cmp     byte ptr[rax + rcx], 0C2h;
	jbe		JMP_NOTUTF8;
	cmp		byte ptr [rax + rcx + 1], 80h
	jb		JMP_NOTUTF8;
	cmp		byte ptr [rax + rcx + 1], 0BFh
	ja		JMP_NOTUTF8;
	jmp		JMP_A

JMP_NOTUTF8:
	movzx   eax, byte ptr[rax + rcx];
	jmp 	JMP_F;

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
	test	ah, ah;
	jz		JMP_F
	cmp		eax, NO_FONT;
	ja		JMP_F;
	mov		eax, NOT_DEF;

JMP_F:
	mov		rdx, qword ptr [r15 + rax * 8 + 120h];
	test	rdx, rdx;

	push	mapNudgeViewProc1ReturnAddress;
	ret;
mapNudgeViewProc1V136 ENDP
END
