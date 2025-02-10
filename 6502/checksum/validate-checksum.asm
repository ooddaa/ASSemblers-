START:  
  ; store bytes to validate 
  LDA #$06
  STA $00

  LDA #$05
  STA $01

  LDA #$00
  STA $02

  LDA #$02
  STA $03

  LDA #$F3 ; checksum
  STA $04

  ; storing the address of the data array in $10-11
  LDA #$00
  STA $10
  STA $11  ; $1011 now points to $0000

  LDX #$05 ; array length

  JSR VALIDATE_CHECKSUM  
  BRK

VALIDATE_CHECKSUM:  
  ; copy array length to decrement
  TXA
  TAY

  ; set up the loop
  LDA #$00
  DEY

  ; start looping
  LOOP:
    CLC
    ADC ($10), Y
    DEY
    BPL LOOP

  ; A now holds the data + checksum. If checksum was 
  ; valid, A holds #$00
  CMP #$00
  BNE ERROR

  ; here sum is 0, Z=1 and checksum is valid 

  LDA #$01
  JMP DONE

  ERROR:
    LDA #$00

  DONE:
    RTS

