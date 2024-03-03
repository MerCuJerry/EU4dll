EXTERN	mapNudgeViewProc1ReturnAddress	:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h
MAP_LIMIT		=	2Dh-1

.CODE
mapNudgeViewProc1 PROC
	push	mapNudgeViewProc1ReturnAddress;
	ret;
mapNudgeViewProc1 ENDP

;----------------------------------------;

mapNudgeViewProc1V130 PROC
	push	mapNudgeViewProc1ReturnAddress;
	ret;
mapNudgeViewProc1V130 ENDP


mapNudgeViewProc1V136 PROC
	cmp     byte ptr[rax + rcx], 7Eh;
	ja      JMP_A;
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
