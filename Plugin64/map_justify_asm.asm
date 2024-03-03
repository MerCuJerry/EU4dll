; r13�͕����񃋁[�v�̃J�E���^�B�t�H���g�ɕ����������Ă��Ȃ��Ă��֌W�Ȃ�
; r10�͕������lenght
; edx�i[rbp+1D0h+var_138]�j�͕����|�W�V�����J�E���^

EXTERN	mapJustifyProc1ReturnAddress1	:	QWORD
EXTERN	mapJustifyProc1ReturnAddress2	:	QWORD
EXTERN	mapJustifyProc2ReturnAddress	:	QWORD
EXTERN	mapJustifyProc4ReturnAddress	:	QWORD

;temporary space for code point
.DATA
	mapJustifyProc1TmpFlag	DD	0
	debug	DQ	0

NO_FONT			=	98Fh
NOT_DEF			=	2026h
MAP_LIMIT		=	2Dh-3

.CODE
mapJustifyProc1 PROC
	movss   xmm9, dword ptr [rcx + 848h];

	mov		debug, rax;

	cmp     byte ptr[rax + r13], 7Eh;
	ja      JMP_A;
	movzx   esi, byte ptr[rax + r13];
	jmp 	JMP_K;

JMP_A:
	push	rdx;
	movzx   dx, byte ptr [rax + r13];
	and     dx, 1Fh;
	cmp     byte ptr [rax + r13], 0E0h;
	jb      JMP_B;
	and     dx, 0Fh;

	inc		rax;
	rcl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + r13];

JMP_B:
	inc		rax;
	rcl     dx, 6;
	xor     dl, 80h;
	xor     dl, byte ptr [rax + r13]

	movzx	esi, dx;	
	pop 	rdx;
	mov		rax, debug;
	; ������dec�������̂܂�𐧌䂵�Ă���
	dec		r10;
	cmp		r13,MAP_LIMIT;
	ja		JMP_H;

	movzx	esi, si;
	cmp		esi, NO_FONT;
	ja		JMP_G;
JMP_H:
	mov		esi, NOT_DEF;

JMP_G:
	mov		mapJustifyProc1TmpFlag, 1h;
	mov     rdi, qword ptr [rcx + rsi * 8];
	mov		sil, 10h; // ���̕���sil���r����'��.�Ɣ�r���Ă���̂ł���̂œK���ɖ��߂�

	test	rdi, rdi;
	jz		JMP_I;
	push	mapJustifyProc1ReturnAddress1;
	ret;

JMP_K:
	mov		mapJustifyProc1TmpFlag, 0h;
	mov     rdi, qword ptr [rcx + rsi * 8];
	test	rdi, rdi;
	jz		JMP_I;
	push	mapJustifyProc1ReturnAddress1;
	ret;

JMP_I:
	push	mapJustifyProc1ReturnAddress2;
	ret;
mapJustifyProc1 ENDP

;-------------------------------------------;

mapJustifyProc2 PROC
	cmp		mapJustifyProc1TmpFlag, 1h;
	jnz		JMP_A;

	; 3byte = 1�������ǂ���
	cmp		r10, 2; 
	ja		JMP_A;
	inc		r10;
	inc		r10;
	mov		edx,1;

JMP_A:
	movd    xmm6, edx;

	; �G�X�P�[�v����
	cmp		mapJustifyProc1TmpFlag, 1h;
	jz		JMP_B;

	lea     eax, [r10 - 1]; ; -1���Ă���
	jmp		JMP_C;

JMP_B:
	lea     eax, [r10 - 2]; ; -2���Ă���

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
	
	add     edx,3;
	add     r13,3;

	jmp		JMP_C;

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