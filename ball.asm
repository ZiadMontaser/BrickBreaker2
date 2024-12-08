        EXTRN BallX:BYTE
        EXTRN BallY:BYTE
        public DrawBall

.MODEL SMALL
.286
.DATA
;ball 
 ballstart_x dw 157
 ballwidth db 6 
 ballstart_y db 140
 ballheight db 6
 ballcolor db 13
 ball_dy db 1    ; (1 neagtive) (2 positive)
 ball_dx db 1   ; (1 right) (2 left)
 
 ;loophelper
 helpheight db ?
 helpwidth db ?

 ;gameStatus
 game db 1  ; (1 still working , 0 gameover)

.code 

drawball proc far

    pusha

    ; Set up video memory segment
    MOV AX, 0A000h          ; Video memory segment for Mode 13h
    MOV ES, AX              ; Load segment into ES
 
    mov ax ,0
    MOV SI, ballstart_x     
    MOV DH, ballstart_y     
    MOV CL, ballwidth        
    MOV CH, ballheight 

    call drawcomp
    ; Restore registers
    popa

    RET

    drawball endp

eraseball proc far
PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    ; Set up video memory segment
    MOV AX, 0A000h          ; Video memory segment for Mode 13h
    MOV ES, AX              ; Load segment into ES

    MOV SI, ballstart_x   
    MOV DH, ballstart_y      
    MOV CL, ballwidth        
    MOV CH, ballheight       
   
FinishEraseRow:
    MOV AX, 0               ; Black color for background
    MOV BX, 320             
    MOV AL, DH              
    PUSH DX
    MUL BX                  ; Calculate offset in video memory
    POP DX
    ADD AX, SI
    MOV DI, AX              ; Store offset in DI           

    ; Erase one row
  FinishEraseCol:
        MOV AL, 0           ; Set black pixel
        MOV ES:[DI], AL
        INC DI  
        DEC CL               
        JNZ FinishEraseCol          

    MOV CL, ballwidth
    INC DH                 
    DEC CH                 
    JNZ FinishEraseRow          
    ; Restore registers
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
ret
eraseball ENDP

drawcomp proc near   
mov helpheight , ch  
mov helpwidth , cl 

FinishRow:
mov ax,0
MOV bx, 320        
MOV AL, DH
push dx
MUL bx               
pop dx 
ADD Ax, SI
           ; Add X-coordinate to the result
MOV DI, AX           ; Store the offset in DI           

    ; Draw one row

  FinishCol:
    mov al , barcolor
    MOV ES:[DI], AL 
    INC DI  
    dec cl              
   jnz FinishCol          

    mov cl, helpwidth
    INC DH                 
    DEC helpheight                  
 JNZ FinishRow    
 ret       
drawcomp endp

moveBallx proc far
 ;mov the ball left and right
    push dx
    


    mov dx , ballstart_x
    mov cl , ballwidth
    mov ch , 0
    add dx,cx

    cmp ballstart_x ,8
    jb changeright

    cmp dx , 314
    ja changeleft

     jmp bounceX

    changeright:
    mov ball_dx , 1
    jmp bounceX

    changeleft:
    mov ball_dx , 2
    jmp bounceX

    bounceX:
    cmp ball_dX , 1
    je goright

    cmp ball_dx , 2
    je goleft

    goright:
    call eraseball 
    add ballstart_x , 2
    jmp moveX

    goleft:
    call eraseball
    sub ballstart_x ,2
    jmp moveX


    moveX:
    call drawball
   

    


pop dx
ret
   moveBallx endp

  moveBally proc far
 push dx
 push ax
    


    mov dl , ballstart_y
    add dl , ballheight

    cmp ballstart_y ,0 
    je changedown

    cmp dl , 192
    ja endgame

    cmp dl , 176
    ja checkColide

     jmp bounceY

    changedown:
    mov ball_dy , 1
    jmp bounceY

   checkColide:
   mov ax , barstart_x
   cmp ax, ballstart_x
   ja bounceY
   
   
   mov dl , barwidth
   mov dh , 0 
   add ax , dx
   cmp ballstart_x, ax
   ja bounceY
   

    changeup:
    mov ball_dy , 2
    jmp bounceY

    bounceY:
    cmp ball_dy , 1
    je godown

    cmp ball_dy , 2
    je goup

    godown:
    call eraseball 
    add ballstart_y , 2
    jmp moveY

    goup:
    call eraseball
    sub ballstart_y ,2
    jmp moveY


    moveY:
    call drawball
    jmp continuegame
   
endgame:
mov game , 0

continuegame:

pop ax
pop dx
ret
  moveBally endp

    PUSHA

    POPA
MAIN ENDP