.data

invalidNum: .asciiz "Invalid number entered"
frameBuffer: .space 0x80000	#512 wide x 256 high pixels
explain:    .asciiz     "Options:\tColours:\n1 - cls\t\t1 - red\n2 - stave\t2 - orange\n3 - note\t3 - yellow\n4 - exit\t4 - green\n\t\t5 - blue\n"
red: .asciiz "Background coloured red!\n"
orange: .asciiz "Background coloured orange!\n"
yellow: .asciiz "Background coloured yellow!\n"
green: .asciiz "Background coloured green!\n"
blue: .asciiz "Background coloured blue!\n"
colour:     .word		
# 			                 red	        orange      yellow	    green       blue        

.text

main:
	jal options
    while: 
        
        #put user input in $t0
        li $v0, 5 
        syscall
        move $t0, $v0 
        
        #error handling numbers beyond 1-5
        li $t1, 1
        li $t2, 6 
        blt $t0, $t1, invalid # If the number is less than the minimum, branch to the invalid label
        bgt $t0, $t2, invalid # If the number is greater than the maximum, branch to the invalid label

        beq $t0, 1, backgroundRed
        beq $t0, 2, backgroundOrange
        beq $t0, 3, backgroundYellow
        beq $t0, 4, backgroundGreen
        beq $t0, 5, backgroundBlue

        beq $t0, 6, exit
        
        j while
    
    exit:
        li $v0, 10             # Set system call code for exiting the program
        syscall                # Call the system call to exit the program


invalid:
    li $v0, 4 # Print the invalid number message and exit
    la $a0, invalidNum
    syscall

backgroundRed:
	#print string
	addi $v0,$zero,4		#put syscall service into v0
	la $a0,	red		#put address of string (input) into a0
	syscall				#actually print string! (this works!)
	jr $ra 
	
backgroundOrange:
	#print string
	addi $v0,$zero,4		#put syscall service into v0
	la $a0,	orange		#put address of string (input) into a0
	syscall				#actually print string! (this works!)
	jr $ra 

backgroundYellow:
	#print string
	addi $v0,$zero,4		#put syscall service into v0
	la $a0,	yellow		#put address of string (input) into a0
	syscall				#actually print string! (this works!)
	jr $ra 
	
backgroundGreen:
	#print string
	addi $v0,$zero,4		#put syscall service into v0
	la $a0,	green		#put address of string (input) into a0
	syscall				#actually print string! (this works!)
	jr $ra 

backgroundBlue:
	#print string
	addi $v0,$zero,4		#put syscall service into v0
	la $a0,	blue		#put address of string (input) into a0
	syscall				#actually print string! (this works!)
	jr $ra 



options:
	#print string
	addi $v0,$zero,4		#put syscall service into v0
	la $a0, explain			#put address of string (input) into a0
	syscall				#actually print string! (this works!)
	jr $ra 












	


	
