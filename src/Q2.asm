TITLE Fibonacci sequence 

; Name: Nadine
; Date: 02-26-24
; ID: 110069648
; Description: 

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    userInput SDWORD 0 ; user input initialized to 0
    msg0 BYTE "Enter an integer number: "
    currentNum SDWORD 0
    spaces BYTE " ", 0

.code
main PROC
    mov edx, OFFSET msg0
    call WriteString
    call ReadInt
    mov userInput, eax ; move user input to userInput

    ; Generate and display Fibonacci sequence
    mov eax, 0          ; First Fibonacci number
    mov ebx, 1          ; Second Fibonacci number
    mov ecx, userInput  ; Number of Fibonacci numbers to generate

    inc ecx 

mov edx, OFFSET spaces
    generate_loop:
        ; Display current Fibonacci number
        mov currentNum, eax
        call WriteInt
        call WriteString

   

        ; Calculate next Fibonacci number
        add eax, ebx
        mov ebx, currentNum
       
        loop generate_loop ; Continue loop if counter is not zero

    ret                 ; Return from main

main ENDP
END main
