# 6510-temperature-converter
This is a temperature converter (Fahrenheit to Celsius, Celsius to Fahrenheit) written in 6510 assembly for the C64. I made this so I can get some 6510 assembly practice.

I wrote this using the Turbo Macro Pro assembler for the C64 in the VICE emulator. You'll find both the assembled executable file here and a text version of the code exported from a C64 sequential file using DirMaster. Despite the .asm extension, the file is not ACME compatible. It might be TMPx compatible, but I haven't tested it yet.

In order to run the executable, you will need a C64 emulator. Load the program in memory through disk (LOAD"ASMTEMP",8,1) and then type the command SYS 4096 to execute. 

┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│NOTE: the current conversion results are incorrect, most likely due to the fact that I didn't bother to use floating point numbers in the divisions that are part │  │of the celsius to fahrenheit/fahrenheit to celsius formula. This is not a reliable celsius to fahrenheit or fahrenheit to celsius converter! This isn't a major   │ │concern for me, though, this program's purpose was to familiarise myself with 6502/6510 assembly first and foremost.                                              │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘


### To Do

-Use floating point numbers in conversion formula

-Ask user if they wish to quit or keep converting

-Accept 4-character numbers instead of 2

