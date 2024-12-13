
        public DrawBall
        public moveBallx
        public moveBally
        public game


.MODEL SMALL
.286

.DATA

;ball 
 ballstart_x dw 156
 ballwidth db 8
 ballstart_y db 140
 ballheight db 8
 ballcolor db 13

 ;drawing a real ball
 ;todraw db ?
 ;toleave db ?
 ;transitionState db 0

 ball_dy db 1    ; (1 neagtive) (2 positive)
 ball_dx db 1   ; (1 right) (2 left)

 
            
 ;loophelper
 rowcount db 1

 ;gameStatus
 game db 1  ; (1 still working , 0 gameover)

.code 
EXTRN barstart_x:word , barwidth:BYTE 
; drawballreal proc far

;     pusha

;     ; Set up video memory segment
;     MOV AX, 0A000h          ; Video memory segment for Mode 13h
;     MOV ES, AX              ; Load segment into ES

 
;     mov ax ,0
;     MOV SI, ballstart_x     
;     MOV DH, ballstart_y     
;     MOV CL, ballwidth        
;     MOV CH, ballheight 

;     mov ah , 0
;     mov al , cl
;     div 2

;     mov toleave  ,al
;     dec toleave
;     mov todraw ,2
    
       
;   FinishRow:
; mov ax,0
; MOV bx, 320        
; MOV AL, DH
; push dx
; MUL bx               
; pop dx 
; ADD Ax, SI
;            ; Add X-coordinate to the result
; MOV DI, AX           ; Store the offset in DI           
; add DI ,toleave
; mov bl , todraw
    

;   FinishCol:
;     mov al , ballcolor
;     MOV ES:[DI], AL 
;     INC DI  

;     dec bl         
;    jnz FinishCol         

; cmp transitionState , 1
; je drawlower

;    mov al , ballwidth
;    cmp todraw , al
;    je transition


;   add todraw ,2
;   sub toleave,1
;   jmp endrow

;   transition:
;   mov transition ,1 
;   jmp endrow


;    drawlower:
;    sub todraw ,2
;    inc toleave
;    jmp endrow



; endrow:
;     INC DH                
;     dec ch    
;  JNZ FinishRow    
;  ret       

;     popa

;     RET

;     drawballreal endp

drawball proc far
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
    MOV AX, 0               
    MOV BX, 320             
    MOV AL, DH              
    PUSH DX
    MUL BX                  ; Calculate offset in video memory
    POP DX
    ADD AX, SI
    MOV DI, AX              ; Store offset in DI           

    ; Erase one row
  FinishEraseCol:
        MOV AL, ballcolor           
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
drawball ENDP

eraseball proc near
mov ballcolor , 0
call drawball
mov ballcolor , 15
ret
eraseball endp



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

end
