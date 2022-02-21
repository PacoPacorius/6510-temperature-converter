         *= $1000
;--------------------------------------;
; MEMORY USED FOR STORAGE:             ;
; $1400 FOR THE TEMP INPUT LOOP        ;
; $1401/2 FOR THE NUMBER RETRIEVE      ;
; $1403 IS 10*$1401+$1402              ;
; $1404 FINAL RESULT FROM CALCS        ;
; $1405-6 TEMP, USED IN CALCS          ;
;--------------------------------------;

         SEI
         LDA #<$8000
         STA $0318
         LDA #>$8000
         STA $0319   ; RESTORE TO TMP
         CLI

         ; NECESSARY FOR $BDCD

         LDA #$37
         STA $01

         ; CLEAR SCREEN

         LDA #147
         JSR $FFD2

         ; SETUP INPUT

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
         JMP CELSIUSTOFAHREN

SELECTIONF LDX #$00
PRINT3   LDA FAHREN,X
         JSR $FFD2
         INX
         CPX #23
         BNE PRINT3
         JMP FAHRENTOCELSIUS

;--------------------------------------;
;       ¥ACCEPT MULTI CHAR INPUTª      ;
;--------------------------------------;

INPUTSTART LDY #$00
         STY $1400 ; NECESSARY, BOTH
INPUTK   JSR $FF9F ; BOTH X AND Y
         JSR $FFE4 ; AFFECTED
         CMP #13 ; IS RETURN PRESSED?
         BEQ RETRIEVE
         CMP #48
         BCC INPUTK
         CMP #58
         BCS INPUTK ; ONLY NUMBERS
         JSR $FFD2  ; ACCEPTED
         STA $FE
         LDA $1400
         TAY        ; TEMP STORE
         LDA $FE
         STA $1401,Y
         INY        ; COUNTER IN
        ;STY $05A5  ; MEM BC KERNAL
         STY $1400  ; ROUTINES
         CPY #$02   ; 2 DIGITS MAX
         BEQ RETRIEVE
         JMP INPUTK

;--------------------------------------;
;           ¥RETRIEVE NUMBER§          ;
;--------------------------------------;
MULT10   ASL A
         ASL A
         ADC $043F
         ASL A
         RTS

RETRIEVE LDX #$00
         LDY #$00
         LDA $1401
         ;STA $0600
         SBC #$30
         JSR MULT10
         ADC $1402
         ;STA $0601
         SBC #$30  ; UNTIL HERE THIS IS
         STA $1403 ; CORRECT
         RTS

;--------------------------------------;
;         ´CALCULATE RESULT§           ;
;--------------------------------------;
DIVIDEBY5 STA $1405 ; DIVIDE THE VALUE
         LSR A      ; IN THE ACCUMULATOR
         ADC #13    ; BY 5
         ADC $1405
         ROR A
         LSR A
         LSR A
         ADC $1405
         ROR A
         ADC $1405
         ROR A
         LSR A
         LSR A
         RTS

MULTBY9  STA $1405 ; MULTIPLIES VALUE AT
         LDA #9    ; $1405 (INPUTTED VAL
         STA $1406 ; UE DIVED BY 5) BY 9
         LDA #$00
         BEQ MULT9LOOP
DO9ADD   CLC
         ADC $1405
LOOP9    ASL $1405
MULT9LOOP LSR $1406
         BCS DO9ADD
         BNE LOOP9
         RTS

CELSIUSTOFAHREN JSR INPUTSTART
         JSR RETRIEVE
         LDA $1403
         JSR DIVIDEBY5
         JSR MULTBY9
         ADC #$20
         STA CALCRESULT ; FINAL NUMBER
         JMP PRINTFINAL

DIVIDEBY9 STA $1405 ; DIVIDES VALUE
         LSR A      ; IN A BY 9
         LSR A
         LSR A
         ADC $1405
         ROR A
         ADC $1405
         ROR A
         ADC $1405
         ROR A
         LSR A
         LSR A
         LSR A
         RTS

MULTBY5  STA $1405 ; MULTS $1405 BY 5
         LDA #5    ; RESULT IN ACCUM
         STA $1406
         LDA #$00
         BEQ MULT5LOOP
DO5ADD   CLC
         ADC $1405
LOOP5    ASL $1405
MULT5LOOP LSR $1406
         BCS DO5ADD
         BNE LOOP5
         RTS

FAHRENTOCELSIUS JSR INPUTSTART
         JSR RETRIEVE
         LDA $1403
         SBC #$20
         JSR DIVIDEBY9
         JSR MULTBY5
         STA CALCRESULT

;--------------------------------------;
;         ´PRINT FINAL RESULT§         ;
;--------------------------------------;

PRINTFINAL LDX #$00
LOOPFINAL LDA PRINTRESULT,X
         INX
         JSR $FFD2
         CPX #$09
         BNE LOOPFINAL
         LDA CALCRESULT+1
         LDX CALCRESULT
         JSR $BDCD ; NO LONGER CRASHES
                   ; THE COMPUTER, GARBA
                   ; GE VALUES, THO
GAMELOOP LDA #$00
         ;STA $05A0
         JMP GAMELOOP


CONVERT  .BYTE 142 ; CHANGE CASE
         .TEXT "CONVERT DEGREES TO "
         .TEXT "FAHRENHEIT (F/C)"
         .BYTE 13,0

CELSIUS  .TEXT "DEGREES IN CELSIUS: "
         .BYTE 0

FAHREN   .TEXT "DEGREES IN FAHRENHEIT: "
         .BYTE 0

CALCRESULT .BYTE 0,0

PRINTRESULT .BYTE 13
         .TEXT "RESULT: "
         .BYTE 0

