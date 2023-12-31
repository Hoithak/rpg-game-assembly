OUTDEC PROC
;prints AX as a signed decimal integer
;input: AX
;output : none
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	OR   AX,AX
	JGE  @END_IF1

	PUSH AX
	MOV  DL,'-'
	MOV  AH,2
	INT  21H
	POP  AX
	NEG  AX

	@END_IF1:
	XOR  CX,CX
	MOV  BX,10D

	@REPEAT1:
	XOR  DX,DX
	DIV  BX
	PUSH DX
	INC  CX
	OR   AX,AX
	JNE  @REPEAT1

	MOV  AH,2

	@PRINT_LOOP:
	POP  DX
	OR   DL,30H
	INT  21H
	LOOP @PRINT_LOOP

	POP  DX
	POP  CX
	POP  BX
	POP  AX
	RET
OUTDEC ENDP

HUE_OUTDEC PROC
;bl contain color of char
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	OR   AX,AX
	JGE  @HEND_IF1

	PUSH AX
	MOV  AL,'-'
	MOV  AH,0EH
	MOV  BL,COLOR   ; set color
	INT  10H
	POP  AX
	NEG  AX

@HEND_IF1:
	XOR  CX,CX
	MOV  BX,10D

@HREPEAT1:
	XOR  DX,DX
	DIV  BX
	PUSH DX
	INC  CX
	OR   AX,AX
	JNE  @HREPEAT1
	
	MOV  AH,0EH
	MOV BL,COLOR
@HPRINT_LOOP:
	POP  DX
	OR   DL,30H
	MOV AL,DL
	INT  10H
	LOOP @HPRINT_LOOP

	POP  DX
	POP  CX
	POP  BX
	POP  AX
	RET
HUE_OUTDEC ENDP

	