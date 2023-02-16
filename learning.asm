
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
    # initialize the memory address for the bitmap
    addi $s0, $zero, 0       # set $s0 to zero
    lui $s0, 0x1001          # load upper register with 0x1001
    addi $s0, $s0, 0x0000   # add lower 16 bits of 0x0000 to $s0

    # set the color value for the entire bitmap
    addi $t0, $zero, 0xff0000 # set $t0 to the desired color value

    # loop through each pixel in the bitmap and store the color value
    addi $t1, $zero, 0       # set $t1 to 0 (loop counter)
    LoopR:
        sw $t0, 0($s0)       # store the color value at the memory location pointed to by $s0
        addi $t1, $t1, 1     # increment the loop counter
        addi $s0, $s0, 4     # increment the memory address pointer by 1 byte (the size of a pixel)
        bne $t1, 131072, LoopR # loop until the counter reaches 25600 (the number of pixels in the bitmap)



        #print string
        addi $v0,$zero,4		#put syscall service into v0
        la $a0,	red		#put address of string (input) into a0
        syscall				#actually print string! (this works!)
        jr $ra 
	
backgroundOrange:
    # initialize the memory address for the bitmap
    addi $s0, $zero, 0       # set $s0 to zero
    lui $s0, 0x1001          # load upper register with 0x1001
    addi $s0, $s0, 0x0000   # add lower 16 bits of 0x0000 to $s0

    # set the color value for the entire bitmap
    addi $t0, $zero, 0xffa500  # set $t0 to the desired color value

    # loop through each pixel in the bitmap and store the color value
    addi $t1, $zero, 0       # set $t1 to 0 (loop counter)
    LoopO:
        sw $t0, 0($s0)       # store the color value at the memory location pointed to by $s0
        addi $t1, $t1, 1     # increment the loop counter
        addi $s0, $s0, 4     # increment the memory address pointer by 1 byte (the size of a pixel)
        bne $t1, 131072, LoopO # loop until the counter reaches 25600 (the number of pixels in the bitmap)
        #print string
        addi $v0,$zero,4		#put syscall service into v0
        la $a0,	orange		#put address of string (input) into a0
        syscall				#actually print string! (this works!)
        jr $ra 





backgroundYellow:
    # initialize the memory address for the bitmap
    addi $s0, $zero, 0       # set $s0 to zero
    lui $s0, 0x1001          # load upper register with 0x1001
    addi $s0, $s0, 0x0000   # add lower 16 bits of 0x0000 to $s0

    # set the color value for the entire bitmap
    addi $t0, $zero, 0xffff00  # set $t0 to the desired color value

    # loop through each pixel in the bitmap and store the color value
    addi $t1, $zero, 0       # set $t1 to 0 (loop counter)
    LoopY:
        sw $t0, 0($s0)       # store the color value at the memory location pointed to by $s0
        addi $t1, $t1, 1     # increment the loop counter
        addi $s0, $s0, 4     # increment the memory address pointer by 1 byte (the size of a pixel)
        bne $t1, 131072, LoopY # loop until the counter reaches 25600 (the number of pixels in the bitmap)
        #print string
        addi $v0,$zero,4		#put syscall service into v0
        la $a0,	yellow		#put address of string (input) into a0
        syscall				#actually print string! (this works!)
        jr $ra 
	
	
	
	
	
backgroundGreen:
    # initialize the memory address for the bitmap
    addi $s0, $zero, 0       # set $s0 to zero
    lui $s0, 0x1001          # load upper register with 0x1001
    addi $s0, $s0, 0x0000   # add lower 16 bits of 0x0000 to $s0

    # set the color value for the entire bitmap
    addi $t0, $zero, 0x008000  # set $t0 to the desired color value

    # loop through each pixel in the bitmap and store the color value
    addi $t1, $zero, 0       # set $t1 to 0 (loop counter)
    LoopG:
        sw $t0, 0($s0)       # store the color value at the memory location pointed to by $s0
        addi $t1, $t1, 1     # increment the loop counter
        addi $s0, $s0, 4     # increment the memory address pointer by 1 byte (the size of a pixel)
        bne $t1, 131072, LoopG # loop until the counter reaches 25600 (the number of pixels in the bitmap)
        #print string
        addi $v0,$zero,4		#put syscall service into v0
        la $a0,	green		#put address of string (input) into a0
        syscall				#actually print string! (this works!)
        jr $ra 

backgroundBlue:
    # initialize the memory address for the bitmap
    addi $s0, $zero, 0       # set $s0 to zero
    lui $s0, 0x1001          # load upper register with 0x1001
    addi $s0, $s0, 0x0000   # add lower 16 bits of 0x0000 to $s0

    # set the color value for the entire bitmap
    addi $t0, $zero, 0x0000ff  # set $t0 to the desired color value

    # loop through each pixel in the bitmap and store the color value
    addi $t1, $zero, 0       # set $t1 to 0 (loop counter)
    LoopB:
        sw $t0, 0($s0)       # store the color value at the memory location pointed to by $s0
        addi $t1, $t1, 1     # increment the loop counter
        addi $s0, $s0, 4     # increment the memory address pointer by 1 byte (the size of a pixel)
        bne $t1, 131072, LoopB # loop until the counter reaches 25600 (the number of pixels in the bitmap)
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



