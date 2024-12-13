
.MODEL SMALL
.STACK 100h
.DATA

; for the drawImg
height dw ?
width_draw dw ?
todraw db ?

startX dw ?
startY dw ?

test_draw db 3, 0, 3, 0,1, 1, 1, 1, 1, 1,0, 0, 0, 2, 0, 3,1, 3, 1, 3, 1, 3
lastIP dw  ?
.CODE
EXTRN drawbar:FAR , moveBar:FAR , DrawBall:FAR , moveBallx:FAR , moveBally:FAR , game:BYTE
drawImage PROC
    
    MOV AX, 0A000h          
    MOV ES, AX              

   
    POP SI 
    mov lastIP , SI
    pop SI                
    MOV AX, word ptr [SI]            
    MOV width_draw, AX
    MOV AX, word ptr [SI+2]          
    MOV height, AX
    ADD SI, 4               

    POP AX                  
    MOV startX, AX
    POP AX                  
    MOV startY, AX

    MOV CX, width_draw      
    MOV DX, startY          

drawrow:
    MOV AX, 0
    MOV BX, 320             
    MOV AL, DL           
    PUSH DX
    MUL BX                
    POP DX
    ADD AX, startX          
    MOV DI, AX             

draw_col:
    MOV DH, [SI]            
    CMP DH, 0              
    JE skip                 
    MOV DH, [SI+1]          
    MOV ES:[DI], DH         

skip:
    INC DI                
    ADD SI, 2               
    DEC CX                  
    JNZ draw_col            

    INC DL                 
    MOV CX, width_draw      
    DEC height              
    JNZ drawrow             
    
    mov ax , lastIP
    push ax

    RET
drawImage ENDP

clearScreen proc near
MOV AX, 0A000h    
mov ax,0600h
mov bh,07 
mov cx,0 
mov dx,184FH
 int 10h

mov ah,2
mov dx,0
mov bx,0
int 10h   
 ret
clearScreen ENDP

; MAIN PROC
;     ; Initialize data segment
;     MOV AX, @DATA
;     MOV DS, AX

    
;     CALL clearScreen
;     MOV AX, 0013h
;     INT 10h


;     MOV AX, 140
;     PUSH AX                 
;     MOV AX, 210
;     PUSH AX                 
;     MOV AX, OFFSET test_draw
;     PUSH AX                 

;     CALL drawImage

   
;     MOV AX, 4C00h           
;     INT 21h
; MAIN ENDP

; END MAIN

MAIN PROC
    ; Call the external clear screen procedure
    mov ax,@DATA
    mov ds,ax
             
   CALL clearScreen
    MOV AX, 0013h      
    INT 10h

    call drawbar  
    call drawball

    theloop:
        
        mov ah,1
        int 16h
        jz CHECK

        mov ah, 0              ; Function 0: Read key from buffer
         int 16h 

       call moveBar

       CHECK:

     call moveBally
      mov ax,8600h        ; Function 86h of interrupt 15h
     mov cx, 0             ; High word of the delay (in milliseconds)
     mov dx, 20000         ; Low word of the delay (1000 ms = 1 second)
     int 15h  
     cmp game , 0
     je closegame  
     call moveBallx
    
   
;    call drawbar
    jmp theloop
     
     closegame:
    MOV AX, 4C00h      ; DOS terminate function
    INT 21h
MAIN ENDP

 END MAIN