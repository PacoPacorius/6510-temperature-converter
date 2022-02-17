         *= $1000

         SEI
         LDA #<$8000
         STA $0318
         LDA #>$8000
         STA $0319   ; RESTORE TO TMP

         ; CLEAR SCREEN

         LDA #147
         JSR $FFD2

         ; SETUP INPUT

         JSR $FF84 ; IOINIT
         LDA #$00
         JSR $FFBD ; SETNAME
         LDA #$00
         LDX #$00
         LDY #$FF
         JSR $FFBA ; SETLFS

         LDA #127
         STA $028A ; DISABLE KEY REPEAT

         ; PRINT FIRST PROMPT

         LDX #$00
PRINT1   LDA CONVERT,X
         JSR $FFD2
         INX
         CPX #37
         BNE PRINT1

         ; ACCEPT INPUT
INPUT1   JSR $FF9F; SCNKEY
         JSR $FFE4 ; GETIN
         CMP #$00
         BEQ INPUT1
         ; JSR $FFD2

         ; PROCESS INPUT
         CMP #67
         BEQ SELECTIONC
         CMP #70
         BEQ SELECTIONF
         JMP INPUT1

         ; PRINT APPROPRIATE PROMPT

SELECTIONC LDX #$00
PRINT2   LDA CELSIUS,X
         JSR $FFD2
         INX
         CPX #20
         BNE PRINT2
         JMP INPUTK

SELECTIONF LDX #$00
PRINT3   LDA FAHREN,X
         JSR $FFD2
         INX
         CPX #23
         BNE PRINT3

;---------------------------------------
;       ¥ACCEPT MULTI CHAR INPUTª
;---------------------------------------

         LDX #$00
INPUTK   JSR $FF9F
         JSR $FFE4
         CMP #13 ; IS RETURN PRESSED?
         BEQ GAMELOOP
         CMP #48
         BCC INPUTK
         CMP #58
         BCS INPUTK
         JSR $FFD2
         INX
         JMP INPUTK

GAMELOOP LDA #$01
         STA $05A0
         JMP GAMELOOP


CONVERT  .BYTE 142 ; CHANGE CASE
         .TEXT "CONVERT DEGREES TO "
         .TEXT "FAHRENHEIT (F/C)"
         .BYTE 13,0

CELSIUS  .TEXT "DEGREES IN CELSIUS: "
         .BYTE 0

FAHREN   .TEXT "DEGREES IN FAHRENHEIT: "
         .BYTE 0

