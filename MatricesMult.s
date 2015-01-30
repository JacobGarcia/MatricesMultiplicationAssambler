########################################################
#  THIS PROGRAM WILL MULTIPLY 2 MATRICES AND STORE IT  #
#  IN A THRID ONE. THE VALUES OF THE MATRICES ARE  	   #
#  DYNAMIC, THEY WILL BE DEFINED BY THE USER. THE	   #
#  DIMENSION IT IS STILL STATIC. IN THIS CASE, THE	   #
#  DIMENSION WILL BE 3 X 3.	 	  					   #
#  NOTE: IT IS CONSIDERED THAT THE MATRICES ARE  	   #
#  VECTORS, BECAUSE THAT IS HOW THE MEMORY STORES      #
#  A MATRIX. 						     	   		   #
# 											     	   #
#  C SCRIPT 								     	   #
#  main(){ 											   #
#	 int sum = 0;									   #
#    int dim = 9; 									   #
#  	 int matA[dim], matB[dim], matC[dim]; 	    	   #
#  	 for(int i = 0; i<3; i++) 					       #
#		for(int j = 0; j<3; j++){ 					   #
#			sum = 0;								   #
#			for(int k = 0; k<3; k++){	     		   #
# 	 			sum = sum + matA[i*3+k] * matB[k*3+j];}#
#  			matC[i*3+j]	= sum;}}					   #
########################################################

######################################################## 
#  REGISTERS RELATION 								   #
#  $t0 - MULTI-COUNTER/ COUNTER FOR LOOP K			   #
#  $t1 - ADDRESS OF DIM/ADDRESS OF MATBT			   #
#  $t2 - ADDRESS OF MATA 							   #
#  $t3 - SCANNED NUMBER/ADDRESS OF SPACE			   #
#  $t4 - DIMENSION 									   #
#  $t5 - A[i]/DOUBLED DIMENSION 					   #
#  $t6 - BT[i]/ADDRESS OF MESSAGE 2	 			       #
#  $t7 - MULT = A[i] * B[i]							   #
#  $s0 - ADDRESS OF MESG1/ADDRESS OF TWOPTS/COUNTER FOR#
#        LOOP J; COMPARISON PURPOSES				   #
#  $s1 - TEMPORAL COUNTER							   #
#  $s2 - COUNTER FOR LOOPI 							   #
#  $s3 - END OF LINE 								   #
#  $s4 - (C[i]) SUM = SUM + MULT					   #
########################################################

		.data
mesg1:  .asciiz "The dimension of the matrices will be: 3 x 3.\nNow, you must define the numbers for the Matrix A (9 numbers), then immediately the numbers for the Matrix B will be asked: \n"
twopts: .asciiz ": "
cr 	  : .asciiz "\n"
spce  : .asciiz "    "
mesg2 : .asciiz "Matrix C"

MATA :  .byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00

MATB:   .byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00

MATC:   .byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00

MATBT:  .byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00
		.byte 00

DIM: 	.byte 9

		.text
main:	xor $t0, $t0, $t0 # Counter Initialization
		la  $t1, DIM 	  # Load the address of DIM into $t1
		la  $t2, MATA     # Load the address of MATA into $t2
		la  $s0, mesg1 	  # Load the address of Message 1 into $s0
		la  $s3, cr 	  # Load the address of the End of Line into $s3
		lbu $t4, 0($t1)   # Load the value of DIM
		add $t5, $t4, $t4 # Temporal Variable for the condition in "ragain"
		
		li  $v0, 4 		  # Print Message 1
		la  $a0, 0($s0)
		syscall

		la  $s0, twopts   # Load the address of 2Points into $s0

read:	li  $v0, 1 		  # Print the index of the matrix
		move $a0, $t0
		syscall

		li  $v0, 4 		  # Print 2Points
		la  $a0, 0($s0)
		syscall

		li  $v0, 5		  # Read the Integer
		syscall
		add $t3, $0, $v0  # Store the number given by the user into $t3

		sb $t3, 0($t2)	  # Store the number in the Matrix 
		addi $t2, 1 	  # Increase by 1 the Index, the Counter and the Temporal Counter ($s1)
		addi $t0, 1 
		addi $s1, 1 	  
		bne $t4, $t0, read	# If the counter it is not equal to the dimension, keep reading

ragain: li $v0, 4 		   # Call service in order to print an "End of Line"
		la $a0, 0($s3)
		syscall

		xor $t0, $t0, $t0  # Reinitialize Counter 
		bne $s1, $t5, read # Read Again; Now for Matrix B

intlz1: la  $t2, MATA     # Reload the address of MATA into $t2
		la  $t3, spce 	  # Load the address of Spaces into $t3
		xor $s1, $s1, $s1 # Reinitialize Temporal Counter
		la  $t1, MATBT	  # Load the address of MATBT into $t1

trnpse: lbu $t6, 9($t2)   # Load B[i] 
		sb  $t6, 0($t1)   # Store B[i] into it's transpose (BT[i])
		addi $t2, 3	   	  # Offset for the Transpose
		addi $t0, 3 	  # Increase counter in 3 
		addi $t1, 1 	  # Increase by 1 the index of BT[i]
		bne $t0, $t4, trnpse # If the 3 numbers of a line are printed, go to the next one
		addi $s1, 1 	  # Next Line
		la  $t2, MATA     # Reload the address of MATA into $t2
		xor $t0, $t0, $t0 # Reinitialize Counter 
		add $t2, $t2, $s1 # Increase the offset for $t2
		bne $s1, 3, trnpse # If the 3 lines are not printed, repeat the process

intlz2:	la  $t6, mesg2	  # Load the address of Message 2 into $t6
		li  $s2, -3		  # MATA Offset Counter; Counter for Loop i
		xor $s1, $s1, $s1 # Reinitialize Temporal Counter

		li $v0, 4 		  # Print Message 2 
		la $a0, 0($t6)
		syscall

loopi:  xor $s0, $s0, $s0 # Initialize counter for loop j
	    la  $t1, MATBT    # Reload the address of MATBT into $t1
	    addi $s2, 3		  # Increase in 3 the counter for loop i

	    li $v0, 4 		  # Call service in order to print an "End of Line"
	    la $a0, 0($s3)
	    syscall

	   #############################################################

loopj:  beq $s0, $t4, loopi # If $s0 it's equal to $t4, go to loop i
	    la  $t2, MATA     # Reload the address of MATA into $t2
	    add $t2, $t2, $s2 # Increase the index of A[i] depending the current state of the process
	    xor $s4, $s4, $s4 # Reinitialize Sum for C[i] 
	    xor $t0, $t0, $t0 # Reinitialize Counter for loop k

	   #############################################################

loopk: lbu $t5, 0($t2)    # Load A[i]
	   lbu $t6, 0($t1)    # Load BT[i]
	   mul $t7, $t5, $t6  # $t7 = A[i] * B[i]
	   add $s4, $s4, $t7  # sum = sum + $t7

	   addi $t2, 1 		  # Increase by 1 the indices of A[i] & BT[i]; 
	   addi $t1, 1		  
	   addi $t0, 1		  # Increase by 1 the counter for loop k & the counter for loop j
	   addi $s0, 1
	   bne $t0, 3, loopk  # If $t0 it's not equals to 3, go to loop k

	   addi $s1, 1 		  # Increase by 1 the counter of the index of MATC
	   la  $t2, MATA      # Reload the address of MATA into $t2
	   add $t2, $t2, $s1  # Increase the index of C[i]
	   sb $s4, 17($t2)	  # Store the value of $s4 into MATC

	   	li $v0, 1 		  # Print number of C[i]
		add $a0, $0, $s4
		syscall

		li $v0, 4 		  # Print the spaces between numbers 
		la $a0, 0($t3)
		syscall

	    bne $s1, $t4, loopj # If all the numbers of the MATC haven't been printed, do all the same process

	   #############################################################
	    li $v0, 4 		  # Call service in order to print an "End of Line"
	    la $a0, 0($s3)
	    syscall

exit:   li $v0, 10 		  # Exit Program
		syscall