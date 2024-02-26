TITLE

; Name: Nadine Abdul-Hamid
; Date: 02-26-24
; ID: 110069648
; Description: 

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

data
    
    arrayStack SDWORD 50 DUP(?)
      arrayVector SDWORD 50 DUP(?) 
    valueI SDWORD ? 
    valueJ SDWORD ? 
    arraySize SDWORD ?  
    arrayNegSum SDWORD 0 
    arrayPosNum SDWORD 0 
    arrayMinValue SDWORD 0  

    spaces BYTE" ",0
    andPrompt BYTE" and ",0

      inputPromptSize BYTE"What is the size N of Vector? ",0
    vectorValuesPrompt BYTE"What are the ",0 
    vectorValuesPrompt2 BYTE" values in Vector? ",0

    vectorSizePrompt BYTE"Size of Vector is N = ",0
    invalidSize BYTE"Size must be positive or zero. ",0
    vectorEqualsPrompt BYTE"Vector = ",0
    negSumPrompt BYTE"The sum of all the negative values in Vector is: Sum = ",0
    posNumPrompt BYTE"The number of all the positive values in Vector is: Count = ",0

    inputPromptIJ BYTE"Please give me two values I and J such that 1 <= I <= J <= N: ",0
    invalidValue BYTE"Invalid I or J. ",0
    
    valueIPrompt BYTE"I = ",0
    valueJPrompt BYTE"J = ",0
    minValuePrompt BYTE"The minimum value between position ",0
    minValuePrompt2 BYTE" of Vector is: Minimum = ",0
    
    vectorPalindrome BYTE"Vector is a palindrome because it reads the same way in both directions. ",0
    vectorNotPalindrome BYTE"Vector is NOT a palindrome. ",0
    repeatPrompt BYTE"Repeat with a new Vector of different size and/or content? ",0 

.code
main PROC
start: 

      ;asks for the size of Vector and stores it
    call Crlf
      mov edx, OFFSET inputPromptSize
      call WriteString
    call ReadInt
    cmp eax, 0
    jg inputValid ;eax >= 0
    je endProgram
    mov edx, OFFSET invalidSize
      call WriteString
    call Crlf
    jmp start 
inputValid:
        mov arraySize, eax
    
    ;asks for 13 values in Vector and stores it in array
    mov edx, OFFSET vectorValuesPrompt
      call WriteString
    call WriteInt
    mov edx, OFFSET vectorValuesPrompt2
      call WriteString
    mov esi, OFFSET arrayVector
    mov ecx, arraySize
readLoop:
    call ReadInt
    mov [esi], eax 
    add esi, TYPE arrayVector
    loop readLoop

    ;prints size of arrayVector
    mov edx, OFFSET vectorSizePrompt
      call WriteString
    mov eax, arraySize
    call WriteInt
    call Crlf 

    ;displays arrayVector 
    mov edx, OFFSET vectorEqualsPrompt
      call WriteString
    mov esi, OFFSET arrayVector
    mov ecx, arraySize
displayLoop: 
    mov eax, [esi]
    call WriteInt
    mov edx, OFFSET spaces
      call WriteString
    add esi, TYPE arrayVector
    loop displayLoop

    call Crlf

    ;adds the sum of all the negative values and counts positive values
    mov edx, OFFSET negSumPrompt
      call WriteString
    mov esi, OFFSET arrayVector 
    mov ecx, arraySize 
    xor eax, eax  
    xor edx, edx 
negSumLoop:
    mov ebx, [esi] ;fetches the current value
    cmp ebx, 0 ;compares current value to 0
    jg posNum ;if 0 < ebx 
    add eax, ebx ;adds current value to sum
    jmp elseLabel
    posNum: 
        inc edx
    elseLabel:
        add esi, TYPE arrayVector
        loop negSumLoop 
    mov arrayNegSum, eax ;prints sum of negative values
    call WriteInt
    call Crlf 
    mov arrayPosNum, edx ;prints positive values count
    mov edx, OFFSET posNumPrompt
      call WriteString
    mov eax, arrayPosNum
    call WriteInt
    call Crlf

    ;gets value of I and J and prints it
getValueIAndJ:
    mov edx, OFFSET inputPromptIJ ;gets value of I and J
      call WriteString
    call ReadInt 
    mov edx, OFFSET invalidValue
    cmp eax, 1
    jge secondCond ;I >= 1
    call WriteString
    jmp getValueIAndJ
    secondCond: ;checks if I is greater than N
        cmp eax, arraySize
        jle thirdCond ;I <= arraySize
        call WriteString
        jmp getValueIAndJ
    thirdCond: ;checks if J is greater than 1
        mov valueI, eax
        call ReadInt 
        cmp eax, 1
        jge fourthCond ;J >= 1
        call WriteString
        jmp getValueIAndJ
    fourthCond: ;checks if J is greater than N
        cmp eax, arraySize
        jle fifthCond ;J <= arraySize
        call WriteString
        jmp getValueIAndJ
    fifthCond: ;compares I and J
        cmp eax, valueI 
        jge inputValid2 ;J >= I
        call WriteString
        jmp getValueIAndJ
    inputValid2: 
        mov valueJ, eax 
    mov edx, OFFSET valueIPrompt ;prints value of I and J
      call WriteString
    mov eax, valueI 
    call WriteInt
    mov edx, OFFSET andPrompt
      call WriteString
    mov edx, OFFSET valueJPrompt
      call WriteString
    mov eax, valueJ 
    call WriteInt
    call Crlf 

    ;gets minimum value between I and J
    mov edx, OFFSET minValuePrompt
      call WriteString
    mov eax, valueI
    call WriteInt
    mov edx, OFFSET andPrompt
      call WriteString
    mov eax, valueJ
    call WriteInt
    mov edx, OFFSET minValuePrompt2
      call WriteString
    mov esi, OFFSET arrayVector ;point to beginning of array 
    mov eax, valueI 
    sub eax, 1 ;reset for 0 indexing 
    shl eax, 2
    add esi, eax 
    mov eax, DWORD PTR [esi]
    mov ecx, valueJ

    cmp ecx, valueI ;checks to see if valueJ == valueI
    je printMin

    sub ecx, 1 ;new addition ;if not equal, then find min by iterating
    sub ecx, valueI
    inc ecx
minLoop: 
    cmp eax, [esi]
    jle elseLabel2 ;if eax <= esi
    mov eax, [esi] ;if eax > esi then move esi into eax 
    jmp elseLabel2
    elseLabel2:
    add esi, TYPE arrayVector
    loop minLoop
printMin: 
    mov arrayMinValue, eax
    call WriteInt
    call Crlf

    ;uses a stack to check if Vector is a palindrome
    mov esi, OFFSET arrayVector 
    mov ecx, arraySize
pushLoop: 
    mov eax, [esi]
    push eax 
    add esi, TYPE arrayVector 
    loop pushLoop 
    mov esi, OFFSET arrayVector 
    mov ecx, arraySize 
popLoop:
    pop edx 
    cmp edx, [esi]
    jne notPalindrome 
    add esi, TYPE arrayVector
    loop popLoop 
    mov edx, OFFSET vectorPalindrome
    call WriteString
    call Crlf
    jmp endProgram
notPalindrome:
    mov edx, OFFSET vectorNotPalindrome
    call WriteString

    call Crlf

endProgram: 
    ;Asks user if they want to repeat 
    mov edx, OFFSET repeatPrompt
      call WriteString
    call ReadChar
    cmp al, 'Y'
    je start
    cmp al, 'y'
    je start
    call Crlf
    call Crlf 

      exit

main ENDP
END main