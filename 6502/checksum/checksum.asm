; Part 1: where we create checksum and append it to data. 
; Checksum algorithm for 6502 assembly: 
; - add all bytes of the given data record together, 
;   retaining only the lowest 8 bits of the sum
; - checksum is the two's complement of the 8-bit sum
; - append the checksum to the data record  


; Part 2: where processor validates checksum   
; data memory location $10-$11
; the number of bytes (incl checksum byte) is in X 
; set A if checksum is valid, else clear A 

; init pointer to byte array, store base address 
; where we will begin our array -> it will begin at $0200
LDA #$00    ; load lower-order bytes of $02->(00)<-
STA $10     ; store A into lower memory address    
LDA #$02    ; load higher-order bytes into A 
STA $11     ; store A into higher memore address

; add all bytes together, using X as offset = data record length
; use inderect indexed addressing mode!   
; LDX         ; we assume X has already been loaded    
LDA ($10), X  ; look at ($10 & $11) and load value of $0200 + X into A  
DEX           ; decrement X to point to the next value 
CLC           ; clear carry flag before loop starts 
ADD_LOOP:     ; start the loop
ADC ($10), X  ; add next value
DEX           ; decrement X
BPL ADD_LOOP ; break from loop when N=1, X < 0
 
; now A should contain 00 if checksum is valid 
CMP #$00  ; sets Z=1 if A == 0 ie checksum is valid 
BEQ VALID ; goes to VALID if Z=1 
  
LDA #$00  ; indicate invalid checksum
JMP DONE  ; exit from subroutine

VALID: 
LDA #$01  ; indicate valid checksum 

DONE:  
RTS       ; return from subroutine 
  
  

