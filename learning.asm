
.data

invalidNum: .asciiz "Invalid number entered"
frameBuffer: .space 0x80000	#512 wide x 256 high pixels

explain:    .asciiz     "Options:\tColours:\n1 - cls\t\t1 - red\n2 - stave\t2 - orange\n3 - note\t3 - yellow\n4 - exit\t4 - green\n\t\t5 - blue\n"

colors: 	.word 0xFFA500, 0xFFFF00, 0x008000, 0x0000FF, 0xFF0000	

orange:  .asciiz "background colour set to Orange!\n"
yellow:  .asciiz "background colour set to Yellow!\n"
green:   .asciiz "background colour set to Green!\n"
blue:    .asciiz "background colour set to Blue!\n"
red:     .asciiz "background colour set to Red!\n"

colorNames:
         .word   orange, yellow, green, blue, red

.text
main:
	jal options
    while: 
        #put user input in $t0
        li $v0, 5 
        syscall
        move $t0, $v0 
        
        # subtract 1 from the user input to match the index in the colors array
	addi $t0, $t0, -1
        
        #error handling numbers beyond 1-5
        li $t1, 0
        li $t2, 5
        
        blt $t0, $t1, invalid # If the number is less than the minimum, branch to the invalid label
        bgt $t0, $t2, invalid # If the number is greater than the maximum, branch to the invalid label  
                
        # check if number is between bounds
        ble $t0, $t2 inside_bounds  # branch if number is less than or equal to lower bound
        bge $t0, $t1 inside_bounds  # branch if number is greater than or equal to upper bound

        #jump to outside_bounds if number is outside the bounds
        j outside_bounds             

inside_bounds:
    # load the address of the colors array
    la $t3, colors
    # multiply the index by 4 to get the correct offset in the array
    sll $t0, $t0, 2
    # add the offset to the array address to get the address of the desired color
    add $t3, $t3, $t0
    # load the color value into $a0
    lw $a0, ($t3)


    # load the address of the color names array
    la $t4, colorNames
    # add the index multiplied by the size of each element to the address to get the address of the desired color name
    add $t4, $t4, $t0
    # load the address of the color name into $a1
    lw $a1, 0($t4)

            # call the backgroundColour function with the selected color
            jal backgroundColour

            outside_bounds:
            #this will handle the other commands such as stove ect
        
        j while
    
    exit:
        li $v0, 10             # Set system call code for exiting the program
        syscall                # Call the system call to exit the program

invalid:
    li $v0, 4 # Print the invalid number message and exit
    la $a0, invalidNum
    syscall
    j while

backgroundColour:
    # initialize the memory address for the bitmap
    addi $s0, $zero, 0       # set $s0 to zero
    lui $s0, 0x1001          # load upper register with 0x1001
    addi $s0, $s0, 0x0000   # add lower 16 bits of 0x0000 to $s0

    # set the color value for the entire bitmap
    lw $t0, ($t3) # set $t0 to the desired color value

    # loop through each pixel in the bitmap and store the color value
    addi $t1, $zero, 0       # set $t1 to 0 (loop counter)
    LoopR:
        sw $t0, 0($s0)       # store the color value at the memory location pointed to by $s0
        addi $t1, $t1, 1     # increment the loop counter
        addi $s0, $s0, 4     # increment the memory address pointer by 1 byte (the size of a pixel)
        bne $t1, 131072, LoopR # loop until the counter reaches 25600 (the number of pixels in the bitmap)
        
        #print colour
        addi $v0,$zero,4		#put syscall service into v0
        la $a0,	($a1)		#put address of string (input) into a0
        syscall				#actually print string! (this works!)
        jr $ra 
	
options:
	#print string
	addi $v0,$zero,4		#put syscall service into v0
	la  $a0, explain			#put address of string (input) into a0
	syscall				#actually print string! (this works!)
	jr $ra 



