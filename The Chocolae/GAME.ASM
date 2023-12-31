;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ FUNCTION FOR SELECT MAIN MENU  [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
MAIN_MENU PROC	
NEW_KEY1:
        MOV		BMP_X,0
        MOV		BMP_Y,0
        LEA			SI,M_MENU1		; SHOW PICTURE MENU1
        CALL		LOADBMP
        MOV		M_CHOICE,1
NEW_KEY2:
        MOV		AH,0				; GET KEY
        INT			16H
	CMP		AH,28				; CHECH 'ENTER'
	JE			SELECT_ENTER
	CMP		AH,72				; CHECH 'UP'
	JE			MOV_UP
	CMP		AH,80				; CHECH 'DOWN'
	JE			MOV_DOWN		; NOT KEY RETURN ---> GET NEW KEY
	JMP			NEW_KEY2
MOV_UP:	 
	DEC			M_CHOICE		; SUB CHOICE WITH 1
	CMP		M_CHOICE,0
	JNE			CHECK_CHOICE
	MOV		M_CHOICE,4
	JMP			CHECK_CHOICE
MOV_DOWN:
	INC		M_CHOICE			; ADD CHOICE WITH 1
	CMP		M_CHOICE,5
	JNE		CHECK_CHOICE
	MOV		M_CHOICE,1
	JMP		CHECK_CHOICE
SELECT_ENTER:					; SELECT CHOICE
	CMP		M_CHOICE,1
	JE		NEW
	CMP		M_CHOICE,2
	JE		CONTINUE
	CMP		M_CHOICE,3
	JE		HI_SCORE
	JMP		EXIT_G
CHECK_CHOICE:					; CHECK CHOICE MENU
	CMP		M_CHOICE,1
	JE		CHOICE1
	CMP		M_CHOICE,2
	JE		CHOICE2
	CMP		M_CHOICE,3
	JE		CHOICE3
	JMP		CHOICE4
CHOICE1:					
	LEA		SI,M_MENU1		; SHOW PICTURE MENU1
	CALL		LOADBMP
	JMP		NEW_KEY2			; GET NEW KEY
CHOICE2:					
	LEA		SI,M_MENU2		; SHOW PICTURE MENU2
	CALL		LOADBMP
	JMP		NEW_KEY2			; GET NEW KEY
CHOICE3:					
	LEA		SI,M_MENU3		; SHOW PICTURE MENU3
	CALL		LOADBMP
	JMP		NEW_KEY2			; GET NEW KEY
CHOICE4:					
	LEA		SI,M_MENU4		; SHOW PICTURE MENU4
	CALL		LOADBMP
	JMP		NEW_KEY2			; GET NEW KEY
NEW:
	MOV		HERO_LEVEL,1		; SET ALL HERO STATUS
	MOV		HERO_MAX_HP,35
	MOV		HERO_HP,35
	MOV		HERO_ATK,3
	MOV		HERO_DEF,1
	MOV		HERO_AGI,1
	MOV		HERO_EXP,0
	MOV		HERO_LIMIT,8
	MOV		HERO_GAGE,1
	MOV		MON_GAGE,1
	MOV		ITEM,0
	CALL		MAIN_MAP			; GOTO MAP 	
	JMP			NEW_KEY1
CONTINUE:
	MOV		FLG,0
	MOV		HERO_GAGE,1
	MOV		MON_GAGE,1
	CALL		LOAD				; GOTO LOAD FILE
	CMP		FLG,0				; CHECK ERROR OPEN FILE
	JNE		NEW_KEY1			; IF ERROR JUMP TO MAIN MENU
	MOV		AX,HERO_MAX_HP
	MOV		HERO_HP,AX
	CALL		MAIN_MAP			; GOTO MAP 	
	JMP		NEW_KEY1
HI_SCORE:	
	LEA		SI,SH_SCORE		; SHOW PICTURE HI-SCORE
	CALL		LOADBMP
	MOV		FILE_ROUND,10		; SHOW 10 NAME OF MAXIMUM SCORE
	XOR		CX,CX
	XOR		AX,AX	
	CALL		GET_FILE		
	CALL		SHOW_FILE	
	MOV		AH,8				; WAIT KEY FOR NEXT
	INT		21H
	INT		21H
	MOV		FILE_ROUND,0
	JMP		NEW_KEY1
EXIT_G:
	RET
MAIN_MENU ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ CHECK KEY ON MAP [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
MAIN_MAP PROC 					; SET POSITION HERO
	MOV		BMP_X,0
	MOV		BMP_Y,0
	LEA			SI,HTP_BMP		;LOOK UP HOW TO PLAY
	CALL		LOADBMP
	DELAY		25000
	CALL		LOAD_MAP			; SHOW MAP
	MOV		BMP_X,25
	MOV		BMP_Y,175
	LEA		SI,UP_F_NAME1		; SHOW PICTURE HERO
	CALL		LOADBMP
	MOV		FLG,1				; SET STATUS OF MOVE
SET_NEW_COUNT:
	MOV		WALK_COUNT,0
GET_KEY_MAP:	
	MOV		AH,0	
	INT		16H				; GET KEY
	INC		WALK_COUNT	
	CMP		AH,77				; RIGHT	
	JE		right
	CMP		AH,75				; LEFT
	JE		left
	CMP		AH,72				; UP
	JE		up
	CMP		AH,80				; DOWN
	JE		down
	CMP		AH,23				; 'I'
	JE		SHOW_ITEM
	CMP		AH,31				; 'S'
	JE		SHOW_HERO_STATUS
	CMP		AH,35				; 'H'
	JE		SHOW_HOWTOPLAY
	CMP		AH,1				; ESC
	JE		QUIZ
	JMP		GET_KEY_MAP
OUT_DIE:						; CHECK DIE ?
	MOV		WALK_COUNT,0		; CLEER WALK COUNT
	MOV		HERO_GAGE,1
	MOV		MON_GAGE,1
	CMP		DIE_FLG	,0		; STATUS DIE FLAG
	JE		EXIT_WAIT			; 4 = WINNER FIGHT
	CMP		DIE_FLG	,3		; 3 = CLEER GAME
	JE		CLEER_GAMEA		; 2 = RUN FIGHT
	MOV		DIE_FLG	,1		; 1 = NOT DIE
	CALL		LOAD_MAP		; 0 = DIE
	LEA		SI,UP_F_NAME1		
	MOV		AX,TEMP_X
	MOV		BX,TEMP_Y
	MOV		BMP_X,AX
	MOV		BMP_Y,BX
	CALL		LOADBMP
	MOV		FLG,1
	JMP		GET_KEY_MAP		; RETURN GET KEY
CLEER_GAMEA:					
	CALL		CLEER_GAME		; SHOW STORY CLEER GAME
	CALL		LOAD_MAP
	CALL		SAVE_MENU		; SAVE GAME
	MOV		DIE_FLG	,1	
	JMP		EXIT_WAIT_MAP
EXIT_WAIT:						; GAME OVER	
	mov		BMP_X,0
	mov		BMP_Y,0
	LEA		SI,GAMEOVER		
	CALL		LOADBMP
	delay		20000
	delay		20000
	delay		20000
	MOV		AH,2
	MOV		DL,7
	INT		21H
	MOV		DIE_FLG	,1	
	CALL		LOAD_MAP
	CALL	SAVE_MENU			; SAVE GAME
	JMP		EXIT_WAIT_MAP
SHOW_ITEM:					; SHOW ITEM
	PUSH		BMP_X
	PUSH		BMP_Y
	MOV		BMP_X,5
	MOV		BMP_Y,5
	CMP		ITEM,0
	JNE		C_ITEM1
	LEA		SI,ITEM0
	JMP		OUT_ITEM
C_ITEM1:
	CMP		ITEM,1			; CHECK ITEM = 1 ?
	JNE		C_ITEM2
	LEA		SI,ITEM1			; SHOW ITEM 1
	JMP		OUT_ITEM
C_ITEM2:
	CMP		ITEM,2			; CHECK ITEM = 2 ?
	JNE		C_ITEM3
	LEA		SI,ITEM2			; SHOW ITEM 2
	JMP		OUT_ITEM
C_ITEM3:
	LEA		SI,ITEM3			; SHOW ITEM 3
OUT_ITEM:
	CALL		LOADBMP	
	POP		BMP_Y
	POP		BMP_X
	JMP		GET_KEY_MAP		; RETURN GET KEY

SHOW_HERO_STATUS:				; SHOW STATUS
	CALL		SHOW_STATUS
	JMP		GET_KEY_MAP		; RETURN GET KEY

SHOW_HOWTOPLAY:
	PUSH BMP_X	
	PUSH BMP_Y
	LEA SI,S_HTP
	MOV BMP_X,0
	MOV BMP_Y,0
	CALL LOADBMP
	POP BMP_Y
	POP BMP_X
	JMP		GET_KEY_MAP		; RETURN GET KEY
;if push left arrrow key
left:
	CMP		FLG,0				;check for actual walk,left and right lag
	JNE		left2
	MOV		FLG,1				;set alternate lag
	LEA		SI,LEFT_F_NAME1
	JMP		left3
left2:	
	LEA		SI,LEFT_F_NAME2
	MOV		FLG,0
left3:
	CMP		BMP_X,1			;check for left of screen
	JLE		GET_KEY_MAP		;yes, not move
	CALL		LOAD_MAP
	SUB		BMP_X,3			;move left 5 pixel
	CALL		LOADBMP			;and show character
	JMP		CHECK_POSITION
;if push right arrrow key
right:	
	CMP		FLG,0				;check for actual walk,left and right lag
	JNE		right2
	MOV		FLG,1				;set alternate lag
	LEA		SI,RIGHT_F_NAME1
	JMP		right3
right2:	
	LEA		SI,RIGHT_F_NAME2
	MOV		FLG,0
right3:
	CMP		BMP_X,305				;check for right of screen
	JGE		GET_KEY_MAP			;yes, not move
	CALL		LOAD_MAP
	ADD		BMP_X,3				;move right 5 pixel
	CALL		LOADBMP				;and show character
	JMP		CHECK_POSITION
;if push up arrrow key
up:
	CMP		FLG,0					;check for actual walk,left and right lag
	JNE		up2
	MOV		FLG,1					;set alternate lag
	LEA		SI,UP_F_NAME1
	JMP		up3
up2:
	LEA		SI,UP_F_NAME2
	MOV		FLG,0
up3:
	CMP		BMP_Y,1				;check for top of screen
	JLE		GET_KEY_MAP			;yes, not move
	CALL		LOAD_MAP
	SUB		BMP_Y,3				;move up 5 pixel
	CALL		LOADBMP				;and show character
	JMP		CHECK_POSITION
down:	
	CMP		FLG,0					;check for actual walk,left and right lag
	JNE		down2
	MOV		FLG,1					;set alternate lag
	LEA		SI,DOWN_F_NAME1
	JMP		down3
down2:
	LEA		SI,DOWN_F_NAME2
	MOV		FLG,0
down3:
	CMP		BMP_Y,180				;check for bottom of screen
	JGE		GET_KEY_MAP			;yes, not move
	CALL		LOAD_MAP
	ADD		BMP_Y,3				;move down 5 pixel
	CALL		LOADBMP				;and show character
CHECK_POSITION:	
	MOV		AX,BMP_X
	MOV		BX,BMP_Y
	MOV		TEMP_X,AX
	MOV		TEMP_Y,BX	
	CMP		BMP_X,20
	JG		CMP_1
	CMP		BMP_Y,170
	JL		CMP_1	
	CALL		LOAD_HOME
	CALL		MAIN_HOME
	MOV		BMP_X,25
	MOV		BMP_Y,160	
	JMP		GET_KEY_MAP
CMP_1:		
	CMP		BMP_X,90			;BOSS1
	JG		CMP_2
	CMP		BMP_Y,70
	JG		CMP_2
	CMP		ITEM,1
	JE		CMP_1A
	CMP		ITEM,3
	JE		CMP_1A
	CALL		BOSS1
	JMP		OUT_DIE
CMP_1A:
	CALL		LOAD_MAP
	LEA		SI,UP_F_NAME1
	mov		BMP_X,40
	mov		BMP_Y,85
	CALL		LOADBMP
	MOV		FLG,1
	JMP		GET_KEY_MAP	
CMP_2:
	CMP		BMP_X,222			;BOSS2
	JL		CMP_3
	CMP		BMP_Y,147
	JL		CMP_3
	CMP		ITEM,2
	JGE		CMP_2A
	CALL		BOSS2
	JMP		OUT_DIE
CMP_2A:
	CALL		LOAD_MAP
	LEA		SI,UP_F_NAME1
	mov		BMP_X,215
	mov		BMP_Y,160
	CALL		LOADBMP
	MOV		FLG,1
	JMP		GET_KEY_MAP	
CMP_3:
	CMP		BMP_X,160			;BOSS3
	JL		CMP_WORK
	CMP		BMP_Y,95
	JG		CMP_WORK
	CMP		ITEM,3
	JNE		CMP_3A
	CALL		BOSS3
	JMP		OUT_DIE
CMP_3A:
	CALL		LOAD_MAP
	LEA		SI,UP_F_NAME1
	mov		BMP_X,166
	mov		BMP_Y,103
	CALL		LOADBMP
	MOV		FLG,1
	JMP		GET_KEY_MAP	

CMP_WORK:	
	CMP		WALK_COUNT,10			; CHECK WALK COUNT = 10 ?
	JL		GET_KEY_MAP
	RANDOM 	1,10
	CMP		AL,5						; 50% MEET MONSTER
	JG		SET_NEW_COUNT
	CALL		NORMAL_MONSTER
	JMP		OUT_DIE
QUIZ:
	CALL SAVE_MENU
EXIT_WAIT_MAP:
	RET
MAIN_MAP ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[  MAIN_HOME [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
MAIN_HOME PROC 
;Initial position of character
	CALL	LOAD_HOME
	MOV		BMP_X,150
	MOV		BMP_Y,130
	LEA		SI,UP_F_NAME1
	CALL	LOADBMP
	MOV		FLG,1
	MOV		WALK_COUNT,0
GET_KEY_HOME:	
	MOV		AH,0	
	INT		16H		;waiting for key board	
	CMP		AH,77	; right	
	JE		rightH
	CMP		AH,75	; left
	JE		leftH
	CMP		AH,72	; up
	JE		upH
	CMP		AH,80	; down
	JE		downH
	JMP		GET_KEY_HOME
;if push left arrrow key
leftH:
	CMP		FLG,0	;check for actual walk,left and right lag
	JNE		left2H
	MOV		FLG,1	;set alternate lag
	LEA		SI,LEFT_F_NAME1
	JMP		left3H
left2H:	
	LEA		SI,LEFT_F_NAME2
	MOV		FLG,0
left3H:
	CMP		BMP_X,80	;check for left of screen
	JLE		GET_KEY_HOME			;yes, not move
	CALL	LOAD_HOME
	SUB		BMP_X,5	;move left 5 pixel
	CALL	LOADBMP	;and show character
	JMP		CHECK_POSITION_HOME
;if push right arrrow key
rightH:	
	CMP		FLG,0		;check for actual walk,left and right lag
	JNE		right2H
	MOV		FLG,1		;set alternate lag
	LEA		SI,RIGHT_F_NAME1
	JMP		right3H
right2H:	
	LEA		SI,RIGHT_F_NAME2
	MOV		FLG,0
right3H:
	CMP		BMP_X,200	;check for right of screen
	JGE		GET_KEY_HOME			;yes, not move
	CALL	LOAD_HOME
	ADD		BMP_X,5		;move right 5 pixel
	CALL	LOADBMP		;and show character
	JMP		CHECK_POSITION_HOME
;if push up arrrow key
upH:
	CMP		FLG,0	;check for actual walk,left and right lag
	JNE		up2H
	MOV		FLG,1	;set alternate lag
	LEA		SI,UP_F_NAME1
	JMP		up3H
up2H:
	LEA		SI,UP_F_NAME2
	MOV		FLG,0
up3H:
	CMP		BMP_Y,60	;check for top of screen
	JLE		GET_KEY_HOME		;yes, not move
	CALL	LOAD_HOME
	SUB		BMP_Y,5	;move up 5 pixel
	CALL	LOADBMP	;and show character
	JMP		CHECK_POSITION_HOME
downH:	
	CMP		FLG,0	;check for actual walk,left and right lag
	JNE		down2H
	MOV		FLG,1	;set alternate lag
	LEA		SI,DOWN_F_NAME1
	JMP		down3H
down2H:
	LEA		SI,DOWN_F_NAME2
	MOV		FLG,0
down3H:
	CMP		BMP_Y,150		;check for bottom of screen
	JGE		GET_KEY_HOME			;yes, not move
	CALL	LOAD_HOME
	ADD		BMP_Y,5			;move down 5 pixel
	CALL	LOADBMP		;and show character
CHECK_POSITION_HOME:	
	CMP		BMP_Y,150
	JL		GET_KEY_HOME
	CMP		BMP_X,130
	JL		GET_KEY_HOME
	CMP		BMP_X,165
	JG		GET_KEY_HOME
	
	RET
MAIN_HOME ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ FIGHT BOSS 1 [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
BOSS1 PROC		
	MOV		MON_NUMBER,7
	MOV		RAN_BG,5	
	CMP		ITEM,2
	JNE		FIGHT_BOSS1
	ADD		HERO_DEF,10
FIGHT_BOSS1:	
	CALL	FIGHT
	CMP		DIE_FLG,4
	JNE		EXIT_BOSS1
	CMP		ITEM,0
	JE		S_ITEM1
	MOV		ITEM,3
	JMP		EXIT_BOSS1
S_ITEM1:
	MOV		ITEM,1
EXIT_BOSS1:	
	SUB		HERO_DEF,10
	RET
BOSS1 ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ FIGHT BOSS 2 [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
BOSS2 PROC		
	MOV		MON_NUMBER,8
	MOV		RAN_BG,6	
	CMP		ITEM,1
	JNE		FIGHT_BOSS2
	ADD		HERO_ATK,10
FIGHT_BOSS2:	
	CALL	FIGHT
	CMP		DIE_FLG,4
	JNE		EXIT_BOSS2	
	CMP		ITEM,0
	JE		S_ITEM2
	MOV		ITEM,3
	JMP		EXIT_BOSS2
S_ITEM2:
	MOV		ITEM,2			
EXIT_BOSS2:	
	SUB		HERO_ATK,10
	RET
BOSS2 ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ FIGHT FINAL BOSS  [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
BOSS3 PROC	
	MOV		MON_NUMBER,9
	MOV		RAN_BG,7		
FIGHT_BOSS3:
	CALL	STORY_M_BOSS
	CALL	FIGHT
	CMP		DIE_FLG,4
	JNE		MOV_DIE	
	MOV		DIE_FLG,3
	JMP		EXIT_BOSS3
MOV_DIE:
	MOV		DIE_FLG,0
EXIT_BOSS3:		
	RET
BOSS3 ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ FIGHT NORMAL MONSTER [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
NORMAL_MONSTER PROC	
	RANDOM 	1,6					;RANDOM MONSTER
	MOV		MON_NUMBER,AL
	RANDOM 	1,4					;RANDOM BATTLE BACKGROUD
	MOV		RAN_BG,AL	
	CALL		FIGHT	
	RET
NORMAL_MONSTER ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ FUNCTION FOR SET MONSTER [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
SET_MONSTER PROC	
	XOR BX,BX
	XOR CX,CX	
	MOV CL,MON_NUMBER
seek:
	add bx,19
	loop seek

	xor si,si
	xor cx,cx
inname:
	mov ah,MONSTER[bx]
	mov ENEMY[si],ah		
	inc si
	inc bx
	inc cx
	cmp cx,19
	jne inname
	xor cx,cx
	xor bx,bx
	mov cl,MON_NUMBER
find:
	add bx,10
	loop find
	mov ax,MONSTER_DATA[bx]
	mov MON_HP,ax
	mov MON_MAX_HP,ax
	add bx,2
	mov ax,MONSTER_DATA[bx]
	mov MON_ATK,ax
	add bx,2
	mov ax,MONSTER_DATA[bx]
	mov MON_DEF,ax
	add bx,2
	mov ax,MONSTER_DATA[bx]
	mov MON_AGI,ax
	add bx,2	
	mov ax,MONSTER_DATA[bx]
	mov MON_EXP,ax	
	RET
SET_MONSTER ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ LOAD BATTLE BACKGROUD [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
BATTLE_BG PROC
	mov al,RAN_BG	
	cmp al,1
	je back1
	cmp al,2
	je back2
	cmp al,3
	je back3
	cmp al,4
	je back4
	cmp al,5
	je backA
	cmp al,6
	je backB
	cmp al,7
	je backC	
back1:
	LEA SI,BG1
	jmp bgshow
back2:
	LEA SI,BG2
	jmp bgshow
back3:
	LEA SI,BG3
	jmp bgshow
back4:
	LEA SI,BG4
	jmp bgshow

backA:
	LEA SI,BGA
	jmp bgshow
backB:
	LEA SI,BGB
	jmp bgshow
backC:
	LEA SI,BGC
	jmp bgshow
bgshow:
	MOV BMP_X,0
	MOV BMP_Y,0
	call LOADBMP
	RET
BATTLE_BG ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ FIGHT [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
FIGHT PROC	
	delay	5000
	CALL	SET_MONSTER
	CMP	HERO_AGI,20
	JLE	NEXT_FIGHT
	MOV	HERO_AGI,20
NEXT_FIGHT:
	call BATTLE_BG
	MOV BMP_X,0
	MOV BMP_Y,184
	lea si,CLR_HP
	call LOADBMP
	lea si,HERO
	mov BMP_X,50
	mov BMP_Y,150
	call LOADBMP	
	lea si,ENEMY
	mov BMP_X,230
	call LOADBMP
	xor ax,ax
	xor cx,cx
seang:
	delay 1000
	delay 1000
	cmp  DIE_FLG,1
	jne endoff
	call GAGE_CLEAR
	call SHOW_HP
	mov color,46
	mov ax,25
	sub ax,MON_AGI			;monster limit
	mov cx,25
	sub cx,HERO_AGI			;hero limit
pleasewait:	
	call GAGE_SHOW
	cmp MON_GAGE,ax
	je attacked
	cmp HERO_GAGE,cx
	je tubmun
	add MON_GAGE,1
	add HERO_GAGE,1
	jmp pleasewait
tubmun: 
	mov HERO_GAGE,1
	call SHOW_F_MENU
	jmp seang
attacked:
	mov MON_GAGE,1
	call MONSTER_ATTACK
	CMP DIE_FLG,2
	JE endoff
	jmp seang
endoff:	
	CMP		HERO_AGI,20
	JLE		END_FIGHT
	MOV		HERO_AGI,20
END_FIGHT:
	RET
FIGHT ENDP

MONSTER_ATTACK PROC
	lea si,BLANK_F_NAME
	mov BMP_X,230
	mov BMP_Y,150
	call LOADBMP	
	mov cx,3	
mrun:
	lea si,ENEMY
	sub BMP_X,50
	call LOADBMP
	delay 300
	lea si,BLANK_F_NAME
	call LOADBMP
	loop mrun	
	mov cx,3	
mfun:
	lea si,ENEMY
	mov BMP_X,80
	call LOADBMP
	delay 300
	mov BMP_X,50
	lea si,HIT
	call LOADBMP
	delay 300
	lea si,HERO
	call LOADBMP
	loop mfun
	call SHOW_HP	
	mov BMP_X,80
	lea si,BLANK_F_NAME
	call LOADBMP
	call MON_CALC_ATK
	mov ax,HERO_HP
	sub ax,DAMAGE
	mov HERO_HP,ax
	call SHOW_HP
	mov cx,3
mrunback:
	lea si,ENEMY
	add BMP_X,50
	call LOADBMP
	delay 500
	lea si,BLANK_F_NAME
	call LOADBMP
	loop mrunback
	mov BMP_X,230
	mov BMP_Y,150
	lea si,ENEMY
	call LOADBMP
	call SHOW_HP
	cmp HERO_HP,0
	jg mattend
	mov BMP_X,50
	lea si,DIE
	call LOADBMP	
	delay 6000
	mov DIE_FLG,0
	lea si,BLANK_F_NAME
	call LOADBMP
mattend:
	MOV		MON_GAGE,1
	RET

MONSTER_ATTACK ENDP

SHOW_F_MENU PROC
	lea si,F_MENU1
	mov F_CHOICE,1
x2:
	mov BMP_X,10
	mov BMP_Y,10
	call LOADBMP
	mov ah,0h	
	int 16h		;waiting for key board
	cmp ah,72	; up
	je movup
	cmp ah,80	; down
	je movdown	
	cmp ah,28	;Enter
	je select		
	cmp ah,01	; ESC
	je exit_m	
	jmp x2
movup:
	cmp F_CHOICE,1
	je x2
	sub F_CHOICE,1
	cmp F_CHOICE,2
	je mu
	lea si,F_MENU1
	call LOADBMP
	jmp x2
mu:
	lea si,F_MENU2
	call LOADBMP
	jmp x2
movdown:
	cmp F_CHOICE,3
	je x2
	add F_CHOICE,1
	cmp F_CHOICE,2
	je md
	lea si,F_MENU3
	call LOADBMP
	jmp x2
md:
	lea si,F_MENU2
	call LOADBMP
	jmp x2	
select:
	cmp F_CHOICE,1
	je strike
	cmp F_CHOICE,2
	je ATK_MAGIC
	cmp F_CHOICE,3
	je flee
strike:
	call ATTACK
	lea si,F_MENU1
	jmp exit_m
ATK_MAGIC:
	call MAGIC 
	lea si,F_MENU2
	jmp exit_m
flee:
	call RUN_AWAY
	mov DIE_FLG,2
exit_m:	
	RET
SHOW_F_MENU ENDP

ATTACK PROC	
	CALL BATTLE_BG
	lea si,BLANK_F_NAME
	mov BMP_X,50
	mov BMP_Y,150
	call LOADBMP	
	mov cx,3	
run:
	lea si,HERO
	add BMP_X,50
	call LOADBMP
	delay 500
	lea si,BLANK_F_NAME
	call LOADBMP
	loop run
	
	mov cx,3	
fun:
	lea si,HERO
	mov BMP_X,200
	call LOADBMP
	delay 500
	mov BMP_X,230
	lea si,HIT
	call LOADBMP
	delay 500
	lea si,ENEMY
	call LOADBMP
	loop fun
	lea si,BLANK_F_NAME
	call LOADBMP
	mov BMP_X,200
	lea si,BLANK_F_NAME
	call LOADBMP
	call HERO_CALC_ATK
	mov ax,MON_HP
	sub ax,DAMAGE
	mov MON_HP,ax
	call SHOW_HP
	lea si,ENEMY
	mov BMP_X,230
	call LOADBMP
	mov cx,3
runback:	
	lea si,HERO
	sub BMP_X,50
	call LOADBMP
	delay 1000
	lea si,BLANK_F_NAME
	call LOADBMP
	loop runback
	mov BMP_X,50
	mov BMP_Y,150
	lea si,HERO
	call LOADBMP
	call SHOW_HP
	cmp MON_HP,0
	jg attend		 
	mov ax,HERO_MAX_HP
	mov HERO_HP,ax
	mov BMP_X,230
	lea si,DIE
	call LOADBMP
	delay 6000
	mov ax,HERO_EXP
	add ax,MON_EXP
	mov	HERO_EXP,AX
CHECK_LVUP:
	mov	ax,HERO_EXP
	CMP	 AX,HERO_LIMIT
	JL	notup
	call LEVELUP
	jmp	CHECK_LVUP
notup:
	mov DIE_FLG,4
attend:
	MOV		HERO_GAGE,1	
	RET
ATTACK ENDP

MAGIC  PROC	
	CALL BATTLE_BG
	SUB	 HERO_HP,5
	lea si,HERO
	mov BMP_X,50
	mov BMP_Y,150
	call LOADBMP	
	mov cx,3	
BANG:
	call SHOW_HP
	add BMP_X,50
	CALL	SHOW_MAGIC	
	delay 150
	lea si,BLANK_F_NAME
	call LOADBMP
	loop BANG
	
	mov cx,3	
fun_m:
	
	mov BMP_X,200
	CALL	SHOW_MAGIC
	delay 200
	mov BMP_X,230
	lea si,HIT_MAGIC
	call LOADBMP
	delay 200
	lea si,ENEMY
	call LOADBMP
	loop fun_m	
	sub	BMP_X,38
	lea si,BLANK_F_NAME
	call LOADBMP

	PUSH	HERO_ATK
	MOV		AX,HERO_ATK
	ADD		HERO_ATK,AX
	call		HERO_CALC_ATK
	POP		HERO_ATK
	mov ax,MON_HP
	sub ax,DAMAGE
	mov MON_HP,ax
	call SHOW_HP
	
	mov BMP_X,50
	mov BMP_Y,150
	lea si,HERO
	call LOADBMP
	call SHOW_HP
	cmp MON_HP,0
	jg OUT_MAGIC	 
	mov ax,HERO_MAX_HP
	mov HERO_HP,ax
	mov BMP_X,230
	lea si,DIE
	call LOADBMP
	delay 1000
	delay 1000
	delay 1000
	delay 1000
	delay 1000
	delay 1000
	mov ax,HERO_EXP
	add ax,MON_EXP
	mov	HERO_EXP,AX
CHECK_UP2:
	mov ax,HERO_EXP
	CMP	 AX,HERO_LIMIT
	JL	notup2
	call LEVELUP 	
	JMP	 CHECK_UP2
notup2:
	mov DIE_FLG,4
	jmp	OUT_MAGIC2
OUT_MAGIC:
	cmp HERO_HP,0
	jg OUT_MAGIC2
	mov BMP_X,50
	lea si,DIE
	call LOADBMP	
	delay 6000
	mov DIE_FLG,0
	lea si,BLANK_F_NAME
	call LOADBMP
OUT_MAGIC2:
	RET
MAGIC ENDP

SHOW_MAGIC PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	PUSH BMP_X	
	PUSH BMP_Y

	XOR BX,BX
	XOR CX,CX	
	MOV CX,ITEM
	INC	CX
seek_magic:
	add bx,19
	loop seek_magic
	xor si,si
	xor cx,cx
NUM_MAGIC:
	mov ah,MAGIC_P[bx]
	mov MAGIC_S[si],ah		
	inc si
	inc bx
	inc cx
	cmp cx,19
	jne NUM_MAGIC
	LEA SI,MAGIC_S
	CALL	LOADBMP	
	POP BMP_Y	
	POP BMP_X
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
SHOW_MAGIC ENDP

RUN_AWAY PROC
	CALL BATTLE_BG
	mov BMP_X,50
	mov BMP_Y,150
away1:
	CMP FLG,0	;check for actual walk,left and right lag
	JNE away2
	MOV FLG,1	;set alternate lag
	lea si,LEFT_F_NAME1
	JMP away3
away2:	
	LEA SI,LEFT_F_NAME2
	MOV FLG,0
away3:
	CALL BATTLE_BG
	sub BMP_X,5	;move left 5 pixel
	call LOADBMP	;and show character
	delay 100
	cmp BMP_X,0
	jg away1
	mov HERO_GAGE,1
	mov MON_GAGE,1
	mov ax,HERO_MAX_HP
	mov HERO_HP,ax	
	RET
RUN_AWAY ENDP

HERO_CALC_ATK PROC
	mov ax,HERO_ATK
	add ax,HERO_LEVEL
	mov bx,MON_DEF
	cmp ax,bx
	jg	sudi
	mov ax,1
	mov DAMAGE,ax
	jmp encal
sudi:
	sub ax,bx
	mov DAMAGE,ax
encal:
	RET
HERO_CALC_ATK ENDP

MON_CALC_ATK PROC
	mov ax,MON_ATK
	mov bx,HERO_DEF
	cmp ax,bx
	jg msudi
	mov ax,1
	mov DAMAGE,ax
	jmp mencal
msudi:
	sub ax,bx
	mov DAMAGE,ax
mencal:
	RET
MON_CALC_ATK ENDP
	

SHOW_HP PROC
	mov ax,BMP_X
	mov bx,BMP_Y
	MOV BMP_X,0
	MOV BMP_Y,184
	lea si,CLR_HP
	call LOADBMP
	mov BMP_X,ax
	mov BMP_Y,bx
	mov ah,2			;MOV CURSOR
	xor bh,bh			;PAGE	
	mov dh,23		;ROW
	mov dl,6			;COLUM
	int 10h
	lea dx,MSG1
	mov ah,9
	int 21h
	mov color,46		;SELECT COLOR
	mov ax,HERO_LEVEL
	call HUE_OUTDEC
	mov ah,2			;MOV CURSOR
	xor bh,bh			;PAGE	
	mov dh,24		;ROW
	mov dl,6			;COLUM
	int 10h
	lea dx,MSG2
	mov ah,9
	int 21h
	cmp HERO_HP,0
	jle eqzero
	mov ax,HERO_HP
	jmp goalong
eqzero:
	mov ax,0
goalong:
	call hue_outdec	
	mov ah,0EH		;WRITE CHAR IN TELETYPE MODE
	mov al,'/'			;PAGE	
	xor bx,bx			
	mov bl,COLOR
	int 10h	
	mov ax,HERO_MAX_HP
	call hue_outdec
	mov ah,2
	xor bh,bh
	mov dh,24
	mov dl,29
	int 10h
	lea dx,MSG2
	mov ah,9
	int 21h
	mov color,46
	cmp MON_HP,0
	jle meqzero
	mov ax,MON_HP
	jmp mgoalong
meqzero:
	mov ax,0
mgoalong:
	call hue_outdec	
	mov ah,0EH
	mov al,'/'
	xor bx,bx
	mov bl,COLOR
	int 10h
	mov ax,MON_MAX_HP
	call hue_outdec	
	RET
SHOW_HP ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ LOAD HOME [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
LOAD_HOME PROC
	PUSH	BMP_X
	PUSH	BMP_Y
	PUSH	SI
	MOV		BMP_X,0
	MOV		BMP_Y,0
	LEA		SI,HOME1
	CALL	LOADBMP
	POP		SI
	POP		BMP_Y
	POP		BMP_X
	RET
LOAD_HOME ENDP





LOAD_MAP PROC
	PUSH	BMP_X
	PUSH	BMP_Y
	PUSH	SI
	MOV		BMP_X,0
	MOV		BMP_Y,0
	LEA		SI,BACK_GROUND
	CALL	LOADBMP
	POP		SI
	POP		BMP_Y
	POP		BMP_X
	RET
LOAD_MAP ENDP

SAVE_MENU PROC		
	lea si,Q_MENU1
	mov Q_CHOICE,1
sav:
	mov BMP_X,200
	mov BMP_Y,10
	call LOADBMP
	mov ah,0h	
	int 16h		;waiting for key board
	cmp ah,72	; up
	je smovup
	cmp ah,80	; down
	je smovdown	
	cmp ah,28	;Enter
	je sselect		
	cmp ah,01	; ESC
	je sexit_m	
	jmp sav
smovup:
	lea si,Q_MENU1
	mov Q_CHOICE,1
	jmp sav
smovdown:
	lea si,Q_MENU2
	mov Q_CHOICE,2
	jmp sav
sselect:
	cmp Q_CHOICE,1
	jne sexit_m
	mov BMP_X,50
	mov BMP_Y,50
	lea si,ENTER_F
	call LOADBMP
	mov ah,2
	xor bh,bh
	mov dh,11
	mov dl,12
	int 10h

	CLD
	LEA	SI,CLEER_NAME
	LEA	DI,INPUT_NAME	
	MOV	 CX,14
	REP	 MOVSB

	lea di,INPUT_NAME
	mov ah,1
read_name:
	int 21h
	cmp al,0DH
	je done
	mov [di],al
	inc di
	jmp read_name
done:
	mov al,0
	mov [di],al	
	call SAVE
	CALL	SCORE
sexit_m:			
	RET
SAVE_MENU ENDP

SAVE PROC
	mov ah,3Ch
	lea dx,INPUT_NAME
	xor cl,cl
	int 21h
	jc error
	mov HANDLE,ax	
	xor bx,bx
	mov ax,HERO_LEVEL
	mov F_BUFFER[bx],ax
	add bx,2
	mov ax,HERO_MAX_HP
	mov F_BUFFER[bx],ax
	add bx,2
	mov ax,HERO_ATK	
	mov F_BUFFER[bx],ax
	add bx,2
	mov ax,HERO_DEF
	mov F_BUFFER[bx],ax
	add bx,2
	mov ax,HERO_AGI	
	mov F_BUFFER[bx],ax
	add bx,2
	mov ax,HERO_EXP	
	mov F_BUFFER[bx],ax
	add bx,2
	mov ax,HERO_LIMIT
	mov F_BUFFER[bx],ax
	add bx,2
	mov ax,ITEM
	mov F_BUFFER[bx],ax
	add bx,2
	
	mov BX,HANDLE
	MOV	AH,40H			;write file
	MOV	CX,16			;byte to write
	LEA	DX,F_BUFFER		;get data to write
	INT	21H	
	mov ah,3EH
	int 21h
	jmp endopen
error:
	call outdec
endopen:
	RET
SAVE ENDP

LOAD PROC
	mov BMP_X,0
	mov BMP_Y,0
	lea si,CLRSCR
	call LOADBMP
	mov BMP_X,50
	mov BMP_Y,50
	lea si,ENTER_F
	call LOADBMP
	mov ah,2
	xor bh,bh
	mov dh,11
	mov dl,12
	int 10h	
	lea di,INPUT_NAME
	mov ah,1
lread_name:
	int 21h
	cmp al,0DH
	je ldone
	mov [di],al
	inc di
	jmp lread_name
ldone:
	mov al,0
	mov [di],al		
	mov ah,3Dh
	lea dx,INPUT_NAME
	mov al,0
	int 21h
	jc lerror
	mov HANDLE,ax	
	mov BX,HANDLE
	MOV	AH,3FH			;write file
	MOV	CX,16			;byte to write
	LEA	DX,F_BUFFER		;get data to write
	INT	21H

	xor bx,bx
	mov ax,F_BUFFER[bx]
	mov HERO_LEVEL,ax
	add bx,2
	mov ax,F_BUFFER[bx]
	mov HERO_MAX_HP,ax
	add bx,2
	mov ax,F_BUFFER[bx]
	mov HERO_ATK,ax
	add bx,2
	mov ax,F_BUFFER[bx]
	mov HERO_DEF	,ax
	add bx,2
	mov ax,F_BUFFER[bx]
	mov HERO_AGI,ax
	add bx,2
	mov ax,F_BUFFER[bx]
	mov HERO_EXP,ax
	add bx,2
	mov ax,F_BUFFER[bx]
	mov HERO_LIMIT,ax
	add bx,2
	mov ax,F_BUFFER[bx]
	mov ITEM,ax
	add bx,2
	mov ah,3EH
	int 21h
	jmp lendopen
lerror:
	MOV	 FLG,1
lendopen:		
	RET
LOAD ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
STORY_GAME PROC
	MOV		BMP_X,0
	MOV		BMP_Y,0			
	MOV		S_COUNT,1
NEXT_STORY:
	XOR		BX,BX
	XOR		CX,CX	
	MOV		CL,S_COUNT
SEEK_P:
	add		bx,20
	loop		SEEK_P
	XOR		CX,CX
	XOR		SI,SI	
INPIC:
	mov		ah,STORY_BMP[bx]
	mov		STORY[si],ah		
	inc		si
	inc		bx
	inc		cx
	cmp		cx,20
	JNE		INPIC
	XOR		SI,SI	
	LEA		SI,STORY
	CALL	LOADBMP
	delay		5000
	mov		ah,0
	int		16h
	CMP		S_COUNT,15
	JGE		OUT_STORYGAME
	INC		S_COUNT
	JMP		NEXT_STORY
OUT_STORYGAME	:
	RET
STORY_GAME ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
CLEER_GAME PROC
	MOV		BMP_X,0
	MOV		BMP_Y,0			
	MOV		S_COUNT,1
	
NEXT_CLEER:
	XOR		BX,BX
	XOR		CX,CX	
	MOV		CL,S_COUNT
SEEK_CLEER:
	add		bx,20
	loop		SEEK_CLEER
	XOR		CX,CX
	XOR		SI,SI	
INPIC_CLEER:
	mov		ah,CLEER_BMP[bx]
	mov		STORY[si],ah		
	inc		si
	inc		bx
	inc		cx
	cmp		cx,20
	JNE		INPIC_CLEER
	XOR		SI,SI	
	LEA		SI,STORY
	CALL	LOADBMP
	delay	5000
	mov		ah,0
	int		16h	
	CMP	S_COUNT,20
	JGE		OUT_CLEERGAME
	INC		S_COUNT
	JMP		NEXT_CLEER	
OUT_CLEERGAME	:
	RET
CLEER_GAME ENDP
;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
STORY_M_BOSS PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	MOV		BMP_X,0
	MOV		BMP_Y,0			
	LEA		SI,ME_BOSS1
	CALL	LOADBMP
	delay	20000
	delay	20000
	LEA		SI,ME_BOSS2
	CALL	LOADBMP
	delay	20000
	delay	20000
	LEA		SI,ME_BOSS3
	CALL	LOADBMP
	delay	20000
	delay	20000
OUT_STORY_MEET:
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
STORY_M_BOSS ENDP

SHOW_STATUS PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	PUSH BMP_X	
	PUSH BMP_Y

	LEA SI,SHOW_ST
	MOV BMP_X,0
	MOV BMP_Y,0
	CALL LOADBMP

	mov ah,2			;MOV CURSOR
	xor bh,bh			;PAGE	
	mov dh,1			;ROW
	mov dl,27			;COLUM
	int 10h
	DISP_STR 'ARENA STATUS'
	MOV		PY,2
	MOV		PX,27
	
	
	CALL	SET_POT
	DISP_STR 'LEVEL   '
	MOV AX,HERO_LEVEL
	CALL OUTDEC

	CALL	SET_POT
	DISP_STR 'HP      '
	MOV AX,HERO_MAX_HP
	CALL OUTDEC
	
	
	CALL	SET_POT
	DISP_STR 'ATTACK  '
	MOV AX,HERO_ATK
	CALL OUTDEC
	
	
	CALL	SET_POT
	DISP_STR 'DEFEND  '
	MOV AX,HERO_DEF
	CALL OUTDEC

	CALL	SET_POT
	DISP_STR 'AGI     '
	MOV AX,HERO_AGI
	CALL OUTDEC

	CALL	SET_POT
	DISP_STR 'EXP     '
	MOV AX,HERO_EXP
	CALL OUTDEC

	
EXIT_SHOW_STATUS:
	POP BMP_Y	
	POP BMP_X
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
SHOW_STATUS ENDP

GAGE_SHOW PROC
	push ax
	push cx
	mov ax,BMP_X
	mov bx,BMP_Y
	push ax
        push bx
	mov BMP_X,40
	mov BMP_Y,145	
	xor cx,cx
	mov cx,HERO_GAGE
	lea si,GAGE
gshow1:
	call LOADBMP
	add BMP_X,2
	loop gshow1
	mov BMP_X,230
	xor cx,cx
	mov cx,MON_GAGE	
gshow2:
	call LOADBMP
	add BMP_X,2
	loop gshow2	
	pop bx
	pop ax
	mov BMP_X,ax
	mov BMP_Y,bx
	pop cx
	pop ax
	ret
GAGE_SHOW ENDP

GAGE_CLEAR PROC
	push ax
	mov ax,BMP_X
	mov bx,BMP_X
	push ax
        push bx
	mov BMP_X,40
	mov BMP_Y,145	
	lea si,CLGAGE
	call LOADBMP
	mov BMP_X,230
	call LOADBMP
	pop bx
	pop ax
	mov BMP_X,ax
	mov BMP_Y,bx
	pop ax
	ret
GAGE_CLEAR ENDP
END
