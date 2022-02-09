         *= $1000

         sei
         lda #<$8000
         sta $0318
         lda #>$8000
         sta $0319   ; restore to tmp

         ; clear screen

         lda #147
         jsr $ffd2

         ; setup input

         jsr $ff84 ; ioinit
         lda #$00
         jsr $ffbd ; setname
         lda #$00
         ldx #$00
         ldy #$ff
         jsr $ffba ; setlfs

         ; print first prompt

         ldx #$00
print1   lda convert,x
         jsr $ffd2
         inx
         cpx #37
         bne print1

         ; accept input
input1   jsr $ff9f; scnkey
         jsr $ffe4 ; getin
         cmp #$00
         beq input1
        ; jsr $ffd2

         ; process input
         cmp #67
         beq selectionc
         cmp #70
         beq selectionf
         jmp input1

         ; print appropriate prompt

selectionc ldx #$00
print2   lda celsius,x
         jsr $ffd2
         inx
         cpx #20
         bne print2
         jmp gameloop

selectionf ldx #$00
print3   lda fahren,x
         jsr $ffd2
         inx
         cpx #23
         bne print3

         ; accept multi-number input
         ldx #$00
input2   jsr $ff9f
         jsr $ffe4
         cmp #13
         beq done
         pha
         inx
         jmp input2

done     dex
         pla
         jsr $ffd2
         cpx #$00
         bne done

gameloop lda #$00
         jmp gameloop


convert  .byte 142 ; change case
         .text "convert degrees to "
         .text "fahrenheit (f/c)"
         .byte 13,0

celsius  .text "degrees in celsius: "
         .byte 0

fahren   .text "degrees in fahrenheit: "
         .byte 0

