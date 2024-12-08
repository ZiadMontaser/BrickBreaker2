        PUBLIC DrawBar
        PUBLIC MoveBar
.286
.MODEL SMALL          ; Define the memory model
.STACK 100h           ; Define stack size

.DATA           
;bar
    barstart_x DB 125
    barstart_y DB 180 
    barHeight db 4
    barwidth db 70
    barcolor db 15 ;(white) 
    barcurrent db ?
    
.CODE

DrawBar proc FAR  
    PUSHA

    ; Set up video memory segment
    MOV AX, 0A000h          ; Video memory segment for Mode 13h
    MOV ES, AX              ; Load segment into ES
 
    mov ax ,0
    
    MOV DL, barstart_x      
    MOV DH, barstart_y      
    MOV CL, barwidth        
    MOV CH, barheight       
   

    FinishRow:
        mov ax ,0
        MOV BX, 320        
        MOV AL, DH     
        push dx
        MUL BX               
        pop dx 
        mov bl , dl
        mov bh , 0
        ADD Ax, bx
                ; Add X-coordinate to the result
        MOV DI, AX           ; Store the offset in DI           

        ; Draw one row

        FinishCol:
            mov al , barcolor
            MOV ES:[DI], AL 
            INC DI  
        dec cl               
        jnz FinishCol          

        mov cl , barwidth
        INC DH                 
    DEC CH                  
    JNZ FinishRow           

    ; Restore registers
    POPA

    RET
DrawBar ENDP

MoveBar PROC FAR
    MOV AH, 0          ; BIOS function to read key press
    INT 16h            ; Get key press
    CMP AL, 27             ; Check if ESC key (27) is pressed (to exit, optional)
    JE exit                ; Jump to exit if ESC is pressed

    CMP AL, 61h              
    JE moveLeft
    CMP AL, 64h            
    JE moveRight
    RET                     ; Return if no relevant key pressed

moveLeft:
    ; Check if the bar is not at the far left
    MOV AL, barstart_x
    CMP AL, 0
    JZ exitLeft            ; If at the far left, do nothing
    sub  barstart_x  , 5   

    RET

moveRight:
    ; Check if the bar is not at the far right
    MOV Al, barstart_x
    mov bx , 320
    mov dl , barwidth
    mov dh ,0
    
    sub bX , dx
    CMP Al, bl ; Check if the bar has reached the far right
    JZ exitRight           ; If at the far right, do nothing
    add barstart_x  ,5       ; Move the bar right by 1 unit

    RET

exitLeft:
    RET

exitRight:
    RET
exit:
ret

MoveBar ENDP

END