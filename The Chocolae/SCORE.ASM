SCORE PROC	
	LEA SI,SH_SCORE
	MOV BMP_X,0
	MOV BMP_Y,0
	CALL LOADBMP
	MOV AX,HERO_EXP
	MOV INPUT_SCORE,AX		
	CALL CHECK_FILE
	CALL GET_FILE	
	NEW_LINE	
	CALL SORT_DATA
	CALL WRITE_FILE
	RET
SCORE ENDP