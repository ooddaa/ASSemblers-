START:
  ; store the address of the data array in $10-11
  LDA #$00
  STA $10
  STA $11

  ; Test1
  ; 1 byte, checksum passes
  LDA #$00
  STA $00

  LDX #$01 
  JSR VALIDATE_CHECKSUM

  ; test
  CMP #$01 ; A register is 1, checksum is valid
  BEQ TEST2
  JMP TEST_ERROR

TEST2:
  ; 1 bytes, checksum fails
  LDA #$01
  STA $00

  LDX #$01
  JSR VALIDATE_CHECKSUM

  ; test
  CMP #$00 ; A register is 0, checksum is invalid
  BEQ TEST3
  JMP TEST_ERROR

TEST3:
  ; checksum passes
  LDA #$01
  STA $00
  LDA #$FF
  STA $01

  LDX #$02
  JSR VALIDATE_CHECKSUM

  ; test
  CMP #$01
  BEQ TEST4
  JMP TEST_ERROR

TEST4:
  ; checksum fails
  LDA #$01
  STA $00
  LDA #$00
  STA $01

  LDX #$02
  JSR VALIDATE_CHECKSUM

  ; test
  CMP #$00
  BEQ TEST5
  JMP TEST_ERROR
 
TEST5:
  ; checksum passes
  LDA #$01
  STA $00
  LDA #$01
  STA $01
  LDA #$FE
  STA $02

  LDX #$03
  JSR VALIDATE_CHECKSUM

  ; test
  CMP #$01
  BEQ PASSED
  JMP TEST_ERROR

TEST_ERROR:
  LDA #$EE
  BRK

PASSED:
  LDA #$AA
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
