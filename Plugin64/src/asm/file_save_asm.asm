EXTERN	fileSaveProc1ReturnAddress		:	QWORD
EXTERN	fileSaveProc2CallAddress		:	QWORD
EXTERN	fileSaveProc2ReturnAddress		:	QWORD
EXTERN	fileSaveProc3ReturnAddress		:	QWORD
EXTERN	fileSaveProc3CallAddress		:	QWORD
EXTERN  fileSaveProc3CallAddress2       :   QWORD
EXTERN	fileSaveProc4CallAddress		:	QWORD
EXTERN	fileSaveProc4MarkerAddress		:	QWORD
EXTERN	fileSaveProc4ReturnAddress		:	QWORD
EXTERN	fileSaveProc5CallAddress		:	QWORD
EXTERN	fileSaveProc5MarkerAddress		:	QWORD
EXTERN	fileSaveProc5ReturnAddress		:	QWORD
EXTERN	fileSaveProc6CallAddress		:	QWORD
EXTERN	fileSaveProc6MarkerAddress		:	QWORD
EXTERN	fileSaveProc6ReturnAddress		:	QWORD
EXTERN	fileSaveProc7CallAddress		:	QWORD
EXTERN	fileSaveProc7ReturnAddress		:	QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

; temporary space
.DATA
	fileSaveProc3Tmp	DQ	0
	fileSaveProc3Message	DB	'save_game_title',0

.CODE
fileSaveProc1 PROC
	mov		eax, dword ptr [rcx + 10h];
	test	eax, eax;

	push	fileSaveProc1ReturnAddress;
	ret;
fileSaveProc1 ENDP

;-------------------------------------------;

fileSaveProc2 PROC
	mov		rcx, rax;
	call	fileSaveProc2CallAddress;

	cmp		qword ptr [rax+18h], 10h;
	jb		JMP_A;
	mov		rax, [rax];

JMP_A:

	mov     qword ptr [rbp + 57h - 50h], 0Fh;
	mov     qword ptr [rbp + 57h - 58h], rbx;
	mov     byte ptr [rbp + 57h - 68h], bl;
	cmp     byte ptr [rax], bl;

	push	fileSaveProc2ReturnAddress;
	ret;
fileSaveProc2 ENDP


;-------------------------------------------;

fileSaveProc3V1316 PROC
	lea		rcx, dword ptr [rbx +580h];
	call	fileSaveProc3CallAddress;
	mov		rdx, rax;

	xor		r8d, r8d;
	mov		rcx, r14
	call	fileSaveProc3CallAddress2;

	push	fileSaveProc3ReturnAddress;
	ret;
fileSaveProc3V1316 ENDP

;-------------------------------------------;

fileSaveProc4 PROC
	lea		rcx, [rsp + 1A8h -138h];
	call	fileSaveProc4CallAddress;
	mov		rcx, rax;

	mov		rdx, fileSaveProc4MarkerAddress;
	lea		r8, [rbp + 0];

	push	fileSaveProc4ReturnAddress;
	ret;
fileSaveProc4 ENDP

;-------------------------------------------;

fileSaveProc5V1316 PROC
	lea		rcx, [r14 + 5C0h];
	call	fileSaveProc5CallAddress;
	mov		r8, rax;

	mov		rdx, fileSaveProc5MarkerAddress;
	lea		rcx, [rsp + 288h - 228h];

	push	fileSaveProc5ReturnAddress;
	ret;
fileSaveProc5V1316 ENDP

;-------------------------------------------;

fileSaveProc6V130 PROC
	lea		rcx, [rbp +730h - 3A0h];
	call	fileSaveProc6CallAddress;
	mov		r8, rax;

	mov		rdx, fileSaveProc6MarkerAddress;
	lea		rcx, [rsp + 830h - 800h];

	push	fileSaveProc6ReturnAddress;
	ret;
fileSaveProc6V130 ENDP

;-------------------------------------------;

fileSaveProc7 PROC

	lea		rcx, [rsp + 58h - 30h];
	call	fileSaveProc7CallAddress;
	mov		rdx, rax;

	lea		rcx, [rbx+0C8h];
	mov		rax, qword ptr [rcx];

	push	fileSaveProc7ReturnAddress;
	ret;
fileSaveProc7 ENDP

END