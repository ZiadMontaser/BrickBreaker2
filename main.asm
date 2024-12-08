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

; MAIN PROC
;     ; Call the external clear screen procedure
;     mov ax,@DATA
;     mov ds,ax
             
;    CALL clearScreen
;   MOV AX, 0013h      
;     INT 10h

;     call drawbar  
;     call drawball

;     theloop:
        
;         mov ah,1
;         int 16h
;         jz CHECK

;         mov ah, 0              ; Function 0: Read key from buffer
;          int 16h 

;        call moveBar

;        CHECK:

;      call moveBallY
;       mov ax,8600h        ; Function 86h of interrupt 15h
;      mov cx, 0             ; High word of the delay (in milliseconds)
;      mov dx, 20000         ; Low word of the delay (1000 ms = 1 second)
;      int 15h  
;      cmp game , 0
;      je closegame  
;      call moveBallx
    
   
; ;    call drawbar
;     jmp theloop
     
;      closegame:
;     MOV AX, 4C00h      ; DOS terminate function
;     INT 21h
; MAIN ENDP