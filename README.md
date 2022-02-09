# 6510-temperature-converter
This is a temperature converter (Fahrenheit to Celsius, Celsius to Fahrenheit) written in 6510 assembly for the C64.

I wrote this using the Turbo Macro Pro assembler for the C64 in the VICE emulator. You'll find both the assembled executable file here and a text version of the code exported from a Sequential file using DirMaster.

In order to run the executable, you will need a C64 emulator. Load the program in memory through disk (LOAD"ASMTEMP",8,1) and then type the command SYS 4096 to execute. A .d64 disk image is provided containing the program for convenience, although is not necessary.

### To Do
-Input for multiple characters to enter degrees

-Calculate using conversion formula

-Print Result

-Ask user if they wish to quit
