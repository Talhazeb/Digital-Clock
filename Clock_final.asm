include emu8086.inc
.model small
.stack 100h

.data

zero	db "  ___  ", 10
		db " / _ \ ", 10
		db "| | | |", 10
		db "| | | |", 10
		db "| |_| |", 10
		db " \___/ ", 10, "$"

one		db "  __  ", 10
		db " /_ | ", 10
		db "  | | ", 10
		db "  | | ", 10
		db "  | | ", 10
		db "  |_| ", 10, "$"

two		db " ___  ", 10
    	db "|__ \ ", 10
    	db "   ) |", 10
    	db "  / / ", 10
    	db " / /_ ", 10
    	db "|____|", 10, "$"

three	db " ____  ", 10
	 	db "|___ \ ", 10
	 	db "  __) |", 10
	 	db " |__ < ", 10
	 	db " ___) |", 10
	 	db "|____/ ", 10, "$"

four	db " _  _   ", 10
		db "| || |  ", 10
		db "| || |_ ", 10
		db "|__   _|", 10
		db "   | |  ", 10
		db "   |_|  ", 10, "$"

five	db " _____ ", 10
		db "| ____|", 10
		db "| |__  ", 10
		db "|___ \ ", 10
		db " ___) |", 10
		db "|____/ ", 10, "$"

six		db "   __  ", 10
		db "  / /  ", 10
		db " / /_  ", 10
		db "|  _ \ ", 10
		db "| (_) |", 10
		db " \___/ ", 10, "$"

seven	db " ______ ", 10
		db "|____  |", 10
		db "    / / ", 10
		db "   / /  ", 10
		db "  / /   ", 10
		db " /_/    ", 10, "$"

eight	db "  ___  ", 10
		db " / _ \ ", 10
		db "| (_) |", 10
		db " > _ < ", 10
		db "| (_) |", 10
		db " \___/ ", 10, "$"


nine 	db "  ___  ", 10
		db " / _ \ ", 10
		db "| (_) |", 10
		db " \__, |", 10
		db "   / / ", 10
		db "  /_/  ", 10, "$"

colon   db "     ", 10
		db "   _ ", 10
		db "  |_|", 10
		db "     ", 10
		db "   _ ", 10
		db "  |_|", 10, "$"


    line db 0
    column db 6
    page_number db 0
    digit_unit db 0
    digit_ten db 0
    time db 0
    hour db 0
    minute db 0
    second db 0
    current_hour db 0
    current_minute db 0
    current_second db 0
    digit_pointer dw 11 dup(?)
    time_set db 0

.code

    mov ax, @data
    mov ds, ax

;******************Storing location of all digits by pointers**********************
    
    mov digit_pointer[0], offset zero
    mov digit_pointer[2], offset one
    mov digit_pointer[4], offset two
    mov digit_pointer[6], offset three
    mov digit_pointer[8], offset four
    mov digit_pointer[10], offset five
    mov digit_pointer[12], offset six
    mov digit_pointer[14], offset seven
    mov digit_pointer[16], offset eight
    mov digit_pointer[18], offset nine
    mov digit_pointer[20], offset colon
      
repeat: 

;***************Clearing screen and Keyboard buffer if User press Escape*************
    call clear_screen 
    
    ;Clear Keyboard Buffer
    mov ah, 0Ch
	mov al, 0
	int 21h

;***********************MAIN MENU**************************
			
    printn
    printn
    printn
    print "             ............::::::: WORLD CLOCK ::::::::............."
    printn
    printn
    print "Select Time Zone (24 Hour Clock):"  
    printn 
    printn
    print "1. Pakistan Time Zone"
    printn
    print "2. United Kingdom Time Zone"
    printn
    print "3. USA Time Zone"
    printn
    print "4. Australia Time Zone" 
    printn
    print "5. Germany Time Zone"
    printn
    print "6. China Time Zone" 
    printn
    print "7. Japan Time Zone"
    printn
    print "8. Brazil Time Zone" 
    printn 
    printn 
    print "9. Exit"
    printn
    printn
    print "Input Option: "  
    
    mov ah,01
    int 21h

;Input is in Asci so converting it to Decimal    
    sub al,48

;Input Comparisons    
    cmp al, 1
        je TS_Pak 
    cmp al, 2
        je TS_UK 
    cmp al, 3
        je TS_USA
    cmp al, 4
        je TS_Aus 
    cmp al, 5
        je TS_Ger 
    cmp al, 6
        je TS_China 
    cmp al, 7
        je TS_Japan 
    cmp al, 8
        je TS_Brazil
    cmp al, 9
        je exit_all 
     
            
;***************Setting Time Difference According to Time Zone*******************     
TS_Pak:
    mov time_set, 0
    jmp main
    
TS_UK:
    mov time_set, -5
    jmp main

TS_USA:
    mov time_set, -11
    jmp main

TS_Aus:
    mov time_set, 3
    jmp main

TS_Ger:
    mov time_set, -4
    jmp main

TS_China:
    mov time_set, 3
    jmp main

TS_Japan:
    mov time_set, 4
    jmp main

TS_Brazil:
    mov time_set, -8
    jmp main

exit_all:
    mov ah, 4ch
    int 21h    
               

main: 
    
     
	call return

;*****************Loading/Updating System Time****************

	load_time:
		mov ah, 2Ch
		int 21h
        
		mov	current_hour, ch 
		mov bl, time_set
		add current_hour, bl
		mov	current_minute, cl
		mov	current_second, dh

	update_second:
		mov al, current_second
		cmp second, al
		jne print

	update_minute:
		mov al, current_minute
		cmp minute, al
		jne print

	update_hour:
		mov al, current_hour
		cmp hour, al
		jne print

jmp main

	print:
		load_hour:
			mov al, current_hour
			mov hour, al

		load_minute:
  		mov al, current_minute
  		mov minute, al

		load_second:
  		mov al, current_second
  		mov second, al
        
        ;Clearing after each iteration
  		call clear_screen
        
;****************Printing Hour*******************        
    print_hour:
		
		mov al, current_hour
  		mov time, al
  		call split_time
        
        ;Tenth digit set
  		call set_digit
  		mov column, 1
  		call print_digit
        
        ;Unit Digit set
  		mov al, digit_unit
  		call set_digit
  		mov column, 11
  		call print_digit

		print_first_colon: 
		    
			mov al, 0Ah
			call set_digit
			mov column, 21
			call print_digit

;****************Printing Minute******************
  	print_minute: 
  	           
  		mov al, current_minute
  		mov time, al
  		call split_time
        
        ;Tenth digit set
  		call set_digit
  		mov column, 31
  		call print_digit
        
        ;Unit Digit set
  		mov al, digit_unit
  		call set_digit
  		mov column, 41
  		call print_digit

		print_second_colon: 
		    
			mov al, 0Ah
			call set_digit
			mov column, 51
			call print_digit

;****************Printing Second******************
  	print_second:
  	    
  		mov al, current_second
		mov time, al
  		call split_time
        
        ;Tenth digit set
  		call set_digit
  		mov column, 61
  		call print_digit
        
        ;Unit Digit set
  		mov al, digit_unit
  		call set_digit
  		mov column, 71
  		call print_digit

  	jmp main
  	
;*****************Dividing time in Units and Odds Place*****************
  	
	proc split_time
	    
  	mov ah, 0
  	mov al, time
  	mov bl, 10
  	div bl
  	mov digit_ten, al
  	mov digit_unit, ah

  	ret
  	
  	split_time endp

;*********************Setting Digit Pointer*********************

	set_digit proc 
	    
  	mov bl, 2
  	mul bl
  	mov si, ax
  	mov si, digit_pointer[si]

  	ret
  	
  	set_digit endp

;**********************Printing Digit*************************

	print_digit proc
	    
		print_digit__reset:
  		mov line, 8
  		call set_position

		print_digit__digit:
		
		call return
		
  		mov dh, 0
  		mov dl, ds:[si]

  		cmp dx, "$"
  		je print_digit__end

  		cmp dx, 10
  		je print_digit__new_line

  		mov ah, 2
  		int 21h

  		inc si
  		jmp print_digit__digit

		print_digit__new_line:
  		inc line
  		call set_position
  		inc si
  		jmp print_digit__digit

		print_digit__end:
  		ret
  		
  	print_digit endp
	
;**************Setting Cursor Position***************	
	
	set_position proc
	    
    	mov ah, 2
      	mov bh, page_number
      	mov dh, line
      	mov dl, column
      	int 10h

		ret 
		
    set_position endp
    
;**************Clear Screen***************  

	clear_screen proc 
	    
    	mov ah, 0fh
      	int 10h
      	mov ah, 0
      	int 10h
    
        ret    
        
    clear_screen endp
	
	
;*************Escape Check****************
	
	return proc
		mov ah, 01h
		int 16h
		cmp al, 27d
		je repeat 
		
		ret
    return endp

end 
    