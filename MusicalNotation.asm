.data

frameBuffer: .space 0x80000	
orange:  .asciiz "background colour set to Orange!\n"
yellow:  .asciiz "background colour set to Yellow!\n"
green:   .asciiz "background colour set to Green!\n"
blue:    .asciiz "background colour set to Blue!\n"
red:     .asciiz "background colour set to Red!\n"
colors: .word 0xFFA500, 0xFFFF00, 0x008000, 0x0000FF, 0xFF0000
colorNames: .word   orange, yellow, green, blue, red

explain: .asciiz "Options:\tColours:\n6 - cls\t\t1 - orange\n7 - stave\t2 - yellow\n8 - note\t3 - green\n9 - exit\t4 - blue\n\t\t5 - red\n"

invalidNum: .asciiz "Invalid option\n"

stavePrompt: .asciiz "select the row the top of the stave should start(20 - 210 inclusive)\n"
notePrompt: .asciiz "select a note to be placed and played(F, G, A, B, C, D, E)\n"

noteMessage: .asciiz "A note has been created!\n"
staveMessage: .asciiz "The stave has been drawn\n"
clsMessage: .asciiz "the screen has been cleared!\n"

staveError: .asciiz "Choose a background colour before drawing a stave!\n"
clsError: .asciiz "You need atleast a background colour to clear the screen!\n"
noteError: .asciiz "A stove must exist for to create a note!\n"


.text
main:
	jal options
    while: 
        # The user will select an option with user input being a number
        li $v0, 5  
        syscall
        move $t0, $v0 
       
	# if the number provided is outside the options availible 1-9 inclusive 
	# It will inform the user and loop again
        blt $t0, 1, invalid 
        bgt $t0, 9, invalid  
                
        # if the number is in bounds the option selected goes to its correct label
	# 1 - 5 chooses a colour
	ble  $t0, 5, backgroundColourSelector

	# 6 Clears the screen 
        beq  $t0, 6, clsVerify #clear screen

	# 7 Draws the stave 	
        beq $t0, 7, staveVerify	

        # 8 Draws the note
        beq $t0, 8, noteVerify	

	# 8 Draws the note
        beq $t0, 9, programExit

        j while

programExit:
	li $v0, 10             
	syscall  


# Empty important program registers and return
clsFinish:
    addi $t9, $zero, 0
    addi $t8, $zero, 0
    sw $t9, 0($sp)

    li $v0, 4 
    la $a0, clsMessage
    syscall
    jr $ra

# there must be a background to clear screen 
clsVerify:
    bne $t3, $zero, backgroundColour
    li $v0, 4 
    la $a0, clsError
    syscall
    jr $ra

# print correct colour printed and return
backgroundColourFinish:
    li $v0, 4 
    la $a0, ($s1)
    syscall
    jr $ra

# background must exist for stave. print error and return else continue 
staveVerify:
    bne $t3, $zero, backgroundColour
    li $v0, 4 
    la $a0, staveError
    syscall
    jr $ra

# print completion message and return
staveFinish:
    li $v0, 4 
    la $a0, staveMessage
    syscall
    jr $ra

# print error else continue to main program
noteVerify:
    lw $t9, 0($sp)   
    bne $t9, $zero, backgroundColour
    li $v0, 4 
    la $a0, noteError
    syscall
    jr $ra

# print compeltion message and return
noteFinish:
    li $v0, 4 
    la $a0, noteMessage
    syscall
    jr $ra



# initial colour selector 

backgroundColourSelector:
    # subtract 1 from user input to match the correct index in colors array
    addi $t7, $t0, -1

    # load the address of the colors array
    la $t3, colors

    # multiply the index by 4 to get correct offset in the array
    sll $t7, $t7, 2

    # add offset to array address to get correct colour address
    add $t3, $t3, $t7

    # load the color value into $a0
    lw $a0, ($t3)

    # load the address of the color names array
    la $t4, colorNames

    # add the index multiplied by the size of each element to the address to get the address of the desired color name
    add $t4, $t4, $t7

    # load the address of the color name into $s1
    lw $s1, 0($t4)







backgroundColour:
    # initialize the memory address for the bitmap
    addi $s0, $zero, 0       
    lui $s0, 0x1001          
    addi $s0, $s0, 0x0000   

    # load user selected colour
    lw  $t2, ($t3) 

    # loop counter
    addi $t1, $zero, 0  

        # loop through each pixel in the bitmap and store the color value
        loopBc:
            # put colour in memory location
            sw $t2, 0($s0)   
            
            # increment the loop counter   
            addi $t1, $t1, 1  
            
            # go to next pixel  
            addi $s0, $s0, 4  
            
            # loop until the counter reaches 131072 (the number of pixels in the bitmap) 
            bne $t1, 131072, loopBc  

	# create stave if selected or end cls option 
    beq $t0, 7, staveLocation
    beq $t0, 6, clsFinish

    # continue if stave exists 
    bge $t9, 20 stave

    # exit if stave doesnt exit
    j backgroundColourFinish

staveLocation:

	stovePrompt:
		# print the prompt for the stave
		addi $v0,$zero,4		
		la  $a0, stavePrompt			
		syscall	
	
		# request number
		li $v0, 5 
		syscall
		move $t9, $v0

		# if its not between 20 and 210 inclusive it will loop again
		blt $t9, 20, stovePrompt
		bgt $t9, 210, stovePrompt

		# Make space on the stack for 1 register
		addi $sp, $sp, -4      
		sw $t9, 0($sp)
		
stave:
        # Restore $t9
	lw $t9, 0($sp)          
        sll $t9, $t9, 11

	# initialize the memory address for the bitmap
	addi $s0, $zero, 0      
	lui $s0, 0x1001         
	addi $s0, $s0, 0x0000      

	# Loop counter
	addi $t1, $zero, 0      

	# skip a user defined number of pixels
	add  $s0, $s0, $t9     
	move $t7, $s0

	# number of lines for the stave
	li $t2, 5

rowSkipper:
	# Loop counter
	addi $t1, $zero, 0      

    rowSkiper:
	# store the color value at the memory location pointed to by $s0
	sw $t6, 0($s0)        
	# increment the loop counter 
        addi $t1, $t1, 1  
        
	# increment the memory address pointer by 1 byte (the size of a pixel)
        addi $s0, $s0, 4    
         
	# loop until the counter reaches 8 the length of square
        bne $t1, 512, rowSkiper
    
	# increment the memory address pointer by the number of bytes to move to the start of the next line
	addi $t7, $t7, 22528
	addi $s0, $t7, 0

	# decrement the outer loop counter
        addi $t2, $t2, -1    

	# loop until the outer loop counter reaches 0
        bne $t2, $zero, rowSkipper

	# Create the Note 
        beq $t0, 8, noteLocation

        # continue if note exists 
        bne $t8, $zero, note
    
	# exit if note doesnt exit
	ble  $t0, 5, backgroundColourFinish
	beq $t0, 7, staveFinish

noteLocation:
	# ask user for note 
	addi $v0,$zero,4		
	la $a0, notePrompt			
	syscall				
	
        #switch case block to keep asking for user input 
        # Read a character input from the user	
switch:           
	li $v0, 12        
	syscall          
	move $t8, $v0  

	# checks input against each letter 
	# assigns the correct properties for specified note  
	# F
		bne $t8, 70, Gcase
		addi $t5, $zero, 74752
		li $t4, 65     # set register $t4 to the value 60
		j note	
	Gcase: 
	# G
		bne $t8, 71,  Acase
		addi $t5, $zero, 64512
		li $t4, 67
		j note
	Acase:
	# A
		bne $t8, 65,  Bcase
		addi $t5, $zero, 52224
		li $t4, 69
		j note
	Bcase:
	# B
		bne $t8, 66,  Ccase
		addi $t5, $zero, 39936
		li $t4, 71
		j note
	Ccase:
	# C
		bne $t8, 67,  Dcase
		addi $t5, $zero, 29696
		li $t4, 72
		j note
	Dcase:
	# D
		bne $t8, 68,  Ecase
		addi $t5, $zero, 19480
		li $t4, 74
		j note
	Ecase:
	# E
		bne $t8, 69,  switch
		addi $t5, $zero, 7168
		li $t4, 76
		j note
	
note:
        # Restore $t9
	lw $t9, 0($sp)          
        sll $t9, $t9, 11

	# initialize the memory address for the bitmap
	addi $s0, $zero, 0      
	lui $s0, 0x1001         
	addi $s0, $s0, 0x0000      

	# Loop counter
	addi $t1, $zero, 0      

	# skip a user defined number of pixels
	add  $s0, $s0, $t9    
	add $s0, $s0,  $t5 
	move $t7, $s0
	
	#length of note
	li $t2, 6

rowSkipperr:
	# reset the loop counter to 0
    li $t1, 0       

    rowSkip:
    
	# store the color value at the memory location pointed to by $s0
	sw $t6, 0($s0)        
	# increment the loop counter 
        addi $t1, $t1, 1  
        
	# increment the memory address pointer by 1 byte (the size of a pixel)
        addi $s0, $s0, 4    
         
	# depth of note
        bne $t1, 8, rowSkip
    
	# increment the memory address pointer by the number of bytes to move to the start of the next line
	addi $t7, $t7, 2048
	addi $s0, $t7, 0

	# decrement the outer loop counter
        addi $t2, $t2, -1    

	# loop until the outer loop counter reaches 0
        bne $t2, $zero, rowSkipperr

	# stave creation and background dont play the note. only note creation does
	ble  $t0, 5, backgroundColourFinish
	beq $t0, 7, staveFinish
        
playNote:
	# setting correct properties for sound
	# pitch, duration, instrument, volume
	move $a0, $t4     
	li $a1, 500    
	li $a2, 2      
	li $a3, 90     
	li $v0, 33     
	syscall

	# return 		
	beq $t0, 8, noteFinish

options:
	#print menu
	addi $v0,$zero,4		
	la $a0, explain			
	syscall				
	jr $ra 

invalid:
	# Print the invalid number message and return
        li $v0, 4 
        la $a0, invalidNum
        syscall

    

          
