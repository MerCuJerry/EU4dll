EXTERN localizationProc1CallAddress1: QWORD
EXTERN localizationProc1CallAddress2: QWORD
EXTERN localizationProc2ReturnAddress: QWORD
EXTERN localizationProc3ReturnAddress: QWORD
EXTERN localizationProc4ReturnAddress: QWORD
EXTERN localizationProc5ReturnAddress: QWORD
EXTERN localizationProc6ReturnAddress: QWORD
EXTERN localizationProc7ReturnAddress: QWORD
EXTERN localizationProc7CallAddress1: QWORD
EXTERN localizationProc7CallAddress2: QWORD
EXTERN localizationProc8ReturnAddress: QWORD

EXTERN year: QWORD
EXTERN month: QWORD
EXTERN day: QWORD

EXTERN generateCString: QWORD
EXTERN concatCString: QWORD
EXTERN concat2CString: QWORD

NO_FONT			=	98Fh
NOT_DEF			=	2026h

;temporary space for code point
.DATA
	mainTextProc2TmpCharacter	DD	0
	dayA	DB	"DD", 0
	monthA	DB	"MONTH", 0
	yearA	DB	"YYYY", 0

.CODE
localizationProc2 PROC
	nop;

	mov		qword ptr [rsp+58h-38h], 0FFFFFFFFFFFFFFFFh;
	mov		r9,	1;	 // start
	mov		r8, rax; // text
	xor		rdx,rdx;  // pos1
	mov		rcx, rbx; // this
	call	localizationProc1CallAddress1;

	push	localizationProc2ReturnAddress;
	ret;
localizationProc2 ENDP

;-----------------------------------;

localizationProc3V130 PROC
	nop;

	;�t�^�╄(0xBF)���ŏ��ɗ��Ă���Δ��]������
	cmp		byte ptr[rax+1], 0BFh; // [0]��0x20(white space)
	jnz		JMP_A;

	mov		qword ptr [rsp+20h], 0FFFFFFFFFFFFFFFFh;
	xor		r9,	r9;	 // start
	mov		r8, rax; // text
	xor		rdx,rdx;  // pos1
	mov		rcx, r15; // this
	call	localizationProc1CallAddress1;
	jmp		JMP_B;

JMP_A:
	or		r9, 0FFFFFFFFFFFFFFFFh;
	xor		r8d, r8d;
	mov		rdx, rax;
	mov		rcx, r15;
	call    localizationProc1CallAddress2;

JMP_B:
	push	localizationProc3ReturnAddress;
	ret;
localizationProc3V130 ENDP

;-----------------------------------;

localizationProc4V130 PROC
	nop;

	;�t�^�╄(0xBF)���ŏ��ɗ��Ă���Δ��]������
	cmp		byte ptr[rax+1], 0BFh; // [0]��0x20(white space)
	jnz		JMP_A;

	mov		qword ptr [rsp+20h], 0FFFFFFFFFFFFFFFFh;
	xor		r9,	r9;	 // start
	mov		r8, rax; // text
	xor		rdx,rdx;  // pos1
	mov		rcx, r15; // this
	call	localizationProc1CallAddress1;
	jmp		JMP_B;

JMP_A:
	or		r9, 0FFFFFFFFFFFFFFFFh;
	xor		r8d, r8d;
	mov		rdx, rax;
	mov		rcx, r15;
	call    localizationProc1CallAddress2;

JMP_B:
	push	localizationProc4ReturnAddress;
	ret;
localizationProc4V130 ENDP

;-----------------------------------;

localizationProc5V131 PROC

	;�t�^�╄(0xBF)���ŏ��ɗ��Ă���Δ��]������
	cmp		byte ptr[rax+1], 0BFh; // [0]��0x20(white space)
	jnz		JMP_A;

	mov		qword ptr [rsp+20h], 0FFFFFFFFFFFFFFFFh; end (stack�n��
	mov		r9, 1;	 // start
	mov		r8, rax; // text
	xor		rdx,rdx;  // pos1
	mov		rcx, rbx; // this
	call	localizationProc1CallAddress1;
	jmp		JMP_B;

JMP_A:
	or		r9, 0FFFFFFFFFFFFFFFFh;
	xor     r8d, r8d;
	mov     rdx, rax;
	mov     rcx, rbx;
	call    localizationProc1CallAddress2;

JMP_B:
	push	localizationProc5ReturnAddress;
	ret;
localizationProc5V131 ENDP

;-----------------------------------;

localizationProc6V131 PROC
	nop;

	; 1450
	or		r9, 0FFFFFFFFFFFFFFFFh;
	xor		r8d, r8d;
	lea		rdx, [rsp+0D0h-0A8h];
	mov		rcx, rsi;
	call	localizationProc1CallAddress2;

	; 1450�N
	or		r9, 0FFFFFFFFFFFFFFFFh;
	xor		r8d, r8d;
	mov		rdx, year;
	mov		rcx, rsi;
	call	localizationProc1CallAddress2;
	
	; 1450�N1��
	or		r9, 0FFFFFFFFFFFFFFFFh;
	xor		r8d, r8d;
	lea		rdx, [rbp+57h - 78h];
	mov		rcx, rsi;
	call	localizationProc1CallAddress2;


	push	localizationProc6ReturnAddress;
	ret;
localizationProc6V131 ENDP

;-----------------------------------;

localizationProc7V131 PROC
	mov     rax, [rsp + 1A8h + 40h]; // arg_38 =+40h
	mov     qword ptr [rsp + 1A8h - 160h], rax;
	lea     rax, dayA;
	mov     qword ptr [rsp + 1A8h - 168h ], rax;
	mov     rax, qword ptr [rsp + 1A8h + 30h]; //  arg_28=+30h
	mov     qword ptr [rsp + 1A8h - 170h], rax;
	lea     rax, monthA;
	mov     qword ptr [rsp + 1A8h - 178h], rax;
	mov     qword ptr [rsp + 1A8h - 180h], rbx;
	lea     rax, yearA;
	mov     qword ptr [rsp + 1A8h - 188h], rax
	lea     r8, qword ptr [rsp + 1A8h - 148h];
	mov     rcx, rdi;

	push	localizationProc7ReturnAddress;
	ret;

localizationProc7V131 ENDP

;-----------------------------------;

localizationProc8 PROC

	; �N
	mov		r8d, 1;
	mov		rdx, year;
	lea		rcx, [rbp-59h];
	call    generateCString;
	nop;

	; 1450�N
	lea		r8, [rbp-59h];
	lea		rdx, [rbp-31h];
	lea		rcx, [rbp-11h];
	call	concatCString;
	nop;

	; 1450�N1��
	lea		r8, [rbp+0Fh];
	mov		rdx, rax;
	mov		rcx, rdi;
	call	concat2CString;

	push	localizationProc8ReturnAddress;
	ret;
localizationProc8 ENDP
END