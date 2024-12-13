        PUBLIC DrawBar
        PUBLIC MoveBar
        public barstart_x
        public barwidth
.286
.MODEL SMALL          ; Define the memory model
.STACK 100h           ; Define stack size

.DATA           
;bar
    barstart_x Dw 125
    barstart_y DB 180 
    barHeight db 4
    barwidth db 70
    barcolor db 15 ;(white) 
    
.CODE

eraseBar PROC far
  mov barcolor ,0
  call drawbar
  mov barcolor , 15

    RET
eraseBar ENDP

drawbar proc near  
   pusha

   
    MOV AX, 0A000h          ; Video memory segment for Mode 13h
    MOV ES, AX              ; Load segment into ES
 
    mov ax ,0
    MOV SI, barstart_x      
    MOV DH, barstart_y      
    MOV CL, barwidth        
    MOV CH, barheight       

       
       FinishRow:
mov ax,0
MOV bx, 320        
MOV AL, DH
push dx
MUL bx               
pop dx 
ADD Ax, SI
           
MOV DI, AX                  

    
  FinishCol:
    mov al , barcolor
    MOV ES:[DI], AL 
    INC DI  
    dec cl              
   jnz FinishCol          

    mov cl, barwidth
    INC DH                 
    DEC ch                
 JNZ FinishRow    
      
    popa
     ret 
drawbar ENDP



moveBar PROC Far
                              

    CMP AL, 61h              
    JE moveLeft
    CMP AL, 64h            
    JE moveRight
    RET                     

moveLeft:
    
    MOV AX, barstart_x
    CMP AX, 0
    JZ exitLeft 
    CALL eraseBar             
    sub  barstart_x  , 5    
    CALL drawbar           
    RET

moveRight:
    
    MOV AX, barstart_x
    mov bx , 320
    mov dl , barwidth
    mov dh ,0
    
    sub bX , dx
    CMP AX, bX
    JZ exitRight  
    CALL eraseBar         
    add barstart_x  ,5            
    CALL drawbar      

    mov ax , 0     
    RET

exitLeft:
    RET

exitRight:
    RET


moveBar ENDP

END