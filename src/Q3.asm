TITLE

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
buffer          BYTE 129 DUP(0)        ; Buffer input string and null terminator
reversedBuffer  BYTE 129 DUP(0)        ; Buffer reversed string and null terminator
prompt          BYTE "Enter a string of at most 128 characters: ", 0
msg1            BYTE "Here it is, with all lowercases and uppercases flipped, and in reverse order: ", 0
msg2            BYTE "There are ", 0
msg3            BYTE " upper-case letters after conversion.", 0
msg4            BYTE "There are ", 0
msg5            BYTE " characters in the string.", 0
inputLen     DWORD ?                    ; tracks input length
upperCaseCounter  DWORD 0               ; counts upper-case letters after conversion

.code
main PROC
    ; Display question prompt
    mov edx, OFFSET prompt
    call WriteString

    ; Read string from the keyboard
    mov edx, OFFSET buffer          ; EDX points to the buffer
    mov ecx, SIZEOF buffer - 1      ; Maximum number of characters to read
    call ReadString
    mov inputLen, eax            ; Length of the input is saved

    ; Getting ready to reverse the string
    mov ecx, inputLen            ;  loop counter: characters in the string
    mov esi, ecx                    ; ESI points to the end of the string
    dec esi                         ; ESI to the last character 
    add esi, OFFSET buffer          ; ESI to the memory address
    mov edi, OFFSET reversedBuffer  ; EDI points to the start of the reversed buffer
    xor eax, eax                    ; Clears EAX to use later

reverseStringOrder:
    ; Check if ECX is 0, indicating we are done reversing 
    jecxz overReverse

    ; Load ESI byte into AL, decrement ESI
    mov al, [esi]
    dec esi

    ; switch case if needed and count uppercase letters
    cmp al, 'a'
    jb possibleUppercase
    cmp al, 'z'
    ja possibleUppercase

    ; Convert to uppercase and count
    sub al, 32
    inc upperCaseCounter
    jmp storeChar

possibleUppercase:
    cmp al, 'A'
    jb storeChar
    cmp al, 'Z'
    ja storeChar

    ; Convert to lowercase 
    add al, 32

storeChar:
    mov [edi], al
    inc edi

    ; Decrement loop counter 
    loop reverseStringOrder

overReverse:
    ; The reversed string is Null-terminated 
    mov byte ptr [edi], 0

    ; Display reversed message 
    mov edx, OFFSET msg1
    call WriteString
    mov edx, OFFSET reversedBuffer
    call WriteString
    call Crlf                    ; New line

    ; Display number of uppercase letters after conversion
    mov edx, OFFSET msg2
    call WriteString
    mov eax, upperCaseCounter
    call WriteDec
    mov edx, OFFSET msg3
    call WriteString
    call Crlf                    

    ; Display total number of characters in string 
    mov edx, OFFSET msg4
    call WriteString
    mov eax, inputLen
    call WriteDec
    mov edx, OFFSET msg5
    call WriteString
    call Crlf                    ; New line

    exit
main ENDP

END main
