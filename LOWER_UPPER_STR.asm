.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter a String: $'
MSG2 DB 0AH, 'In upper-case it is: $'
MSG3 DB 0AH, 'In lower-case it is: $'
INPUT_ARR db 50 DUP(0)
LEN_ARR equ $-INPUT_ARR

.CODE
MAIN PROC
    ;INITALIZE DS
    MOV AX, @DATA       
    MOV DS,AX           

    ;print msg
    LEA DX,MSG1         
    MOV AH,9            
    INT 21H            

    ; print the og array
    MOV SI, OFFSET INPUT_ARR
    MOV CX, LEN_ARR
    GET_DATA:
        MOV AH, 1
        INT 21H
        MOV [SI], AL
        CMP AL, 0DH
        JZ DISPLAY_DATA
        INC SI
        LOOP GET_DATA

    DISPLAY_DATA:
        ; LOWER CASE TO UPPER CASE
        ;print msg
        LEA DX,MSG2       
        MOV AH,9          
        INT 21H           

        ; print the modified array
        MOV SI, OFFSET INPUT_ARR
        MOV CX, LEN_ARR
        CONVERT_STR_UPPER:
        MOV DL, [SI]
        CMP DL, 0
        JZ UPPER_TO_LOWER
        CMP DL, 61H
        JB NEXT_CYC_UPPER
        CMP DL, 7AH
        JA NEXT_CYC_UPPER
        SUB DL, 32
        NEXT_CYC_UPPER:
            MOV AH, 2
            INT 21H
            INC SI
            LOOP CONVERT_STR_UPPER

        ; UPPER CASE TO LOWER CASE
        UPPER_TO_LOWER:
            ;print msg
            LEA DX,MSG3       
            MOV AH,9          
            INT 21H           

            ; print the modified array
            MOV SI, OFFSET INPUT_ARR
            MOV CX, LEN_ARR
            CONVERT_STR_LOWER:
            MOV DL, [SI]
            CMP DL, 0
            JZ EXIT
            CMP DL, 41H
            JB NEXT_CYC_LOWER
            CMP DL, 5AH
            JA NEXT_CYC_LOWER
            ADD DL, 32
            NEXT_CYC_LOWER:
                MOV AH, 2
                INT 21H
                INC SI
                LOOP CONVERT_STR_LOWER
        
    EXIT:
    ;DOS EXIT
    MOV AH,4CH
    INT 21H            
    
MAIN ENDP
END MAIN