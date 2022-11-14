                                               org 100h
Subbytes MACRO
Local loba
mov si,0
loba:mov bl,txt[si]
mov bh,0
mov bh,sbox[bx]
mov txt[si],bh
inc si
cmp si,10h
jnz loba
endm
shiftOne MACRO txt, n
 
Mov Al,txt[n]
 
Mov si,n+1H
local l1
l1:mov bl,txt[si]
mov txt[si-1],bl
inc si
cmp si,n+4
jnz l1
mov txt[n+3],al
 
ENDM
 
shiftRows MACRO
 
shiftOne txt,4
 
 
shiftOne txt,8
shiftOne txt,8
 
 
shiftOne txt,0cH
shiftOne txt,0cH
shiftOne txt,0cH
endm
 
multiply MACRO y,x ; the result is in al
local overflow
local after_over_flow
local f
mov bl,x
and bl,1b ; bl contains low bit
mov bh,x ; bh contains high bit
and bh,10b
 
mov al,bl
mul y    ;al either zero or one so we don't need to check the overflow after multiplication
mov cx,ax
 
mov al,bh
mul y
cmp ah,0
jnz overflow
jmp after_over_flow
overflow: xor ax,const
after_over_flow: xor ax,cx
endm
 
rowColMul MACRO
mov dx,si
add si,si
add si,si
multiply txt[di],cbox[si]
mov tmp3,al
multiply txt[di+4],cbox[si+1]
mov tmp,al
 
multiply txt[di+8],cbox[si+2]
mov tmp2,al
 
 
multiply txt[di+0CH],cbox[si+3]
xor al,tmp
xor al,tmp2
xor al,tmp3
add si,di
 
mov tmptxt[si],al
mov si,dx
endm
 
 
 
mixCol Macro
 
local l1
mov si,0
mov di,0
 
l1:rowColMul
 
inc di
cmp di,4
jnz l1
inc si
mov di,0
cmp si,4
jnz l1
mov si,0
local lobaz
mov dl , tmptxt[si]
lobaz:mov txt[si],dl
inc si
cmp si,10h
mov dl , tmptxt[si]
jnz lobaz
endm
addRoundKey Macro
mov si,0
mov bx,0
mov bl,counter
ROL bx,4
local loba
loba:mov dl,txt[si]
xor dl,roundkey[bx]
mov txt[si],dl
inc si
inc bx
cmp si,10h
jnz loba
endm
.data segment
txt DB 16 DUP (?)
tmptxt DB 16 DUP(?)
sbox    db 63h,7ch,77h,7bh,0f2h,6bh,6fh,0c5h,30h,01h,67h,2bh,0feh,0d7h,0abh,76h
db 0cah,82h,0c9h,7dh,0fah,59h,47h,0f0h,0adh,0d4h,0a2h,0afh,9ch,0a4h,72h,0c0h
db 0b7h,0fdh,93h,26h,36h,3fh,0f7h,0cch,34h,0a5h,0e5h,0f1h,71h,0d8h,31h,15h
db 04h,0c7h,23h,0c3h,18h,96h,05h,9ah,07h,12h,80h,0e2h,0ebh,27h,0b2h,75h
db 09h,83h,2ch,1ah,1bh,6eh,5ah,0a0h,52h,3bh,0d6h,0b3h,29h,0e3h,2fh,84h
db 53h,0d1h,00h,0edh,20h,0fch,0b1h,5bh,6ah,0cbh,0beh,39h,4ah,4ch,58h,0cfh
db 0d0h,0efh,0aah,0fbh,43h,4dh,33h,85h,45h,0f9h,02h,7fh,50h,3ch,9fh,0a8h
db 51h,0a3h,40h,8fh,92h,9dh,38h,0f5h,0bch,0b6h,0dah,21h,10h,0ffh,0f3h,0d2h
db 0cdh,0ch,13h,0ech,5fh,97h,44h,17h,0c4h,0a7h,7eh,3dh,64h,5dh,19h,73h
db 60h,81h,4fh,0dch,22h,2ah,90h,88h,46h,0eeh,0b8h,14h,0deh,5eh,0bh,0dbh
db 0e0h,32h,3ah,0ah,49h,06h,24h,5ch,0c2h,0d3h,0ach,62h,91h,95h,0e4h,79h
db 0e7h,0c8h,37h,6dh,8dh,0d5h,4eh,0a9h,6ch,56h,0f4h,0eah,65h,7ah,0aeh,08h
db 0bah,78h,25h,2eh,1ch,0a6h,0b4h,0c6h,0e8h,0ddh,74h,1fh,4bh,0bdh,8bh,8ah
db 70h,3eh,0b5h,66h,48h,03h,0f6h,0eh,61h,35h,57h,0b9h,86h,0c1h,1dh,9eh
db 0e1h,0f8h,98h,11h,69h,0d9h,8eh,94h,9bh,1eh,87h,0e9h,0ceh,55h,28h,0dfh
db 8ch,0a1h,89h,0dh,0bfh,0e6h,42h,68h,41h,99h,2dh,0fh,0b0h,54h,0bbh,16h
tmp DB ?
tmp2 DB ?
cbox DB 02h,03h,01,01,01,02,03,01,01,01,02,03,03,01,01,02
index dw 0000h
const Dw 1bh
tmp3 DB ?
key db 16 DUP(0ffh)
;key db 54h,73h,20h,67h,68h,20h,4Bh,20h,61h,6Dh,75h,46h,74h,79h,6Eh,75h
counter db 0h
roundindex dw 1
roundcol dw 0
roundcolindex dw 0
RCon db 00h,01h,02h,04h,08h,10h,20h,40h,80h,1bh,36h
;
roundKey db 160 DUP(0h>
rotwordtmp db 4 DUP<0h>
  


;gets the transpose of the input matrix to match the global standard 
rotateTXT MACRO  

Mov al,txt[1]
Mov bl,txt[4]
Mov txt[1],bl
Mov txt[4],al

 
Mov al,txt[2]
Mov bl,txt[8]
Mov txt[2],bl
Mov txt[8],al
                 


Mov al,txt[3]
Mov bl,txt[12]
Mov txt[3],bl
Mov txt[12],al
                 

Mov al,txt[6]
Mov bl,txt[9]
Mov txt[6],bl
Mov txt[9],al
         
Mov al,txt[7]
Mov bl,txt[13]
Mov txt[7],bl
Mov txt[13],al


Mov al,txt[11]
Mov bl,txt[14]
Mov txt[11],bl
Mov txt[14],al

endm

input Proc
MOV SI ,0H
MOV AH,1
takeagain: INT 21H
MOV txt[si],AL
INC SI
CMP SI,10H
JNZ takeagain
rotateTXT
ret
endp
output proc
rotateTXT
MOV SI ,0H
MOV AH,2
mov dl,0ah
int 21h
outputagain:MOV DL,txt[si]
INT 21H
INC SI
CMP SI,10H
JNZ outputagain

ret
endp
 
;bounus part
 
coppyKey MACRO ; copies key into roundkey array
mov si,0h
local loba
loba:
mov al,key[si]
mov roundKey[si],al
inc si
cmp si,10h
jnz loba
endm
RotWord MACRO n
mov si,n
ROL si,4 ; XX h => RoundkeyIndex elementIndex
mov bx,si
sub si,10h ; pointer to next roundkey
add si,3
 
 
mov al,roundKey[si+4]
mov roundKey[bx],al
 
mov al,roundKey[si+8]
mov roundKey[bx+4],al
 
mov al,roundKey[si+0Ch]
mov roundKey[bx+8],al
 
mov al,roundKey[si]
mov roundKey[bx+0Ch],al
 
 
endm
subBytescol Macro colbegin; diifers from subbytes above it substitutes only one col
mov si,colbegin
 
mov bl,roundKey[si]
mov bh,0
mov bh,sbox[bx]
mov roundKey[si],bh
 
add si,4
 
mov bl,roundKey[si]
mov bh,0
mov bh,sbox[bx]
mov roundKey[si],bh
 
add si,4
 
mov bl,roundKey[si]
mov bh,0
mov bh,sbox[bx]
mov roundKey[si],bh
 
add si,4
 
mov bl,roundKey[si]
mov bh,0
mov bh,sbox[bx]
mov roundKey[si],bh
endm
 
colXOR MACRO i
mov si,i
mov bx,si
sub bx,10h ; prev roundkey index
 
mov al,roundKey[si]
XOR al,roundKey[bx]
mov roundKey[si],al
 
add si,4
add bx,4
mov al,roundKey[si]
XOR al,roundKey[bx]
mov roundKey[si],al
 
add si,4
add bx,4
mov al,roundKey[si]
XOR al,roundKey[bx]
mov roundKey[si],al
 
add si,4
add bx,4
mov al,roundKey[si]
XOR al,roundKey[bx]
mov roundKey[si],al
 
endm
 
colXOR2 MACRO i
mov si,i
mov bx,si
sub bx,10h ; prev roundkey index
 
mov al,roundKey[si-1]
XOR al,roundKey[bx]
mov roundKey[si],al
 
add si,4
add bx,4
mov al,roundKey[si-1]
XOR al,roundKey[bx]
mov roundKey[si],al
 
add si,4
add bx,4
mov al,roundKey[si-1]
XOR al,roundKey[bx]
mov roundKey[si],al
 
add si,4
add bx,4
mov al,roundKey[si-1]
XOR al,roundKey[bx]
mov roundKey[si],al
endm
 
generateRoundKey MACRO
; copy cipher into roundKey array
 
coppyKey
; begin of every round
Local rounds
 
rounds:
RotWord roundindex
mov ax,roundindex
ROL ax,4
mov roundcol,ax
subBytescol roundcol
colXor roundcol
mov si,roundcol
mov al,roundKey[si]
mov bx,roundindex
XOR al,RCon[bx]
mov roundKey[si],al
mov ax,1
mov roundcolindex,ax
 
;
 
Local loba
loba:
mov ax,roundcol
add ax,1
mov roundcol,ax
 
mov ax,roundcolindex
add ax,1
mov roundcolindex,ax
colXor2 roundcol
 
mov ax,roundcolindex
cmp ax,4
jnz loba
 
mov ax,roundindex
add ax,1
mov roundindex,ax
cmp ax,11
jnz rounds
 
endm
 
 
 
 
.code segment
call input
generateRoundKey
addRoundKey
inc counter
again:
Subbytes
shiftRows
mixCol
addRoundKey
inc counter
cmp counter,0Ah
jnz again
Subbytes
shiftRows
addRoundKey
call output
 
 
ret
 
 