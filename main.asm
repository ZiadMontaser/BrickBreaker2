EXTRN DrawBar:FAR
EXTRN MoveBar:FAR
; EXTRN DrawBall:FAR
.MODEL SMALL
.286
.code 
MAIN PROC
    ; Call the external clear screen procedure
    mov ax,@DATA
    mov ds,ax

    MOV AX, 0013h      
    INT 10h

    main_game_loop:
    
    
        CALL clearScreen
        CALL DrawBar 

        CALL moveBar


    JMP main_game_loop
     
    MOV AX, 4Ch       ; DOS terminate function
    INT 21h
MAIN ENDP

clearScreen proc near
    MOV AX, 0A000h    ; Point to video memory segment
    MOV ES, AX        ; Load ES with video segment
    XOR DI, DI        ; Start at offset 0
    MOV CX, 32000     ; 320*200 = 64000 / 2 (word-sized chunks)
    MOV AX, 0         ; Black color
    REP STOSW         ; Clear screen
    RET
clearScreen ENDP

END MAIN