# Digital-Clock
Digital Clock using assembly language in emu 8086

FEATURES:
1.	The clock shows the time of the computer system.
2.	It will show hours, minutes, and seconds.
3.	It will be using 24 hours format standard.
4.	It will be developed in the console of emu 8086 screen.
5.	It will be displayed using attractive, bold, and large fonts.
6.	The interface is simple with colored text on black background.

METHODOLOGY:
	The first part will include saving each digit in a variable in data part of code. By this I mean that the digits to be printed will be large so large digits will be created using multiple special characters. The time will be extracted from the system by using the interrupt of clock time. Each digit starting point will be pointed by a variable. Hours, minutes, and seconds will be extracted from the system time interrupt call. The time will be multidigit so each number will be splitted and divided to get the required value. As the time will change in every loop the the whole time prints in one iteration, the clock will need to clear whole screen and print the whole clock again. The loop will continue infinitely until escape button is pressed. The important aspect will be calculating the spacing and jumping to another line after each execution. 
