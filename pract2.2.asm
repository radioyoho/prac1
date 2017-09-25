.data
.text
	addi $t7, $zero, 1	#temporary to store 1
	addi $s0,$zero, 5	#number of discs
	add $a0, $zero, $s0	#copy to a0
	lui $s1,0x1001		#Upper adress
	lui $a1,0x1001		#upper adress
	lui $a2,0x1001		#upper adress
	lui $a3,0x1001		#upper adress
		addi $a1, $a1,0x00	#ORIGIN tower
		addi $a2, $a2,0x20	#AUX tower
		addi $a3, $a3,0x40	#DESTINY tower	
fill: 		#initialize all towers in memory, according to N discs
	sw $a0,0($s1)		#store in adress
	addi $s1, $s1, 4	#move adress
	addi $a0, $a0, -1	#sub 1 to disc tower	
	bne $a0, $zero, fill	#loop
	add $a0, $s0, $zero 	#reinitialize a0
	jal hanoi					#call hanoi, (N,ORIGIN, DESTINY, AUX)
	j exit			
	#</init>
hanoi:	addi $sp,$sp,-4
	sw $ra,0($sp)		#back up Register Address
		beq $a0, $t7, base	#if n>1 goes to recursion
		jal recursion1		#calls to switch aux and destiny
		jal move1		#makes the move
		jal recursion2		#calls to switch aux and origin
	bret: lw $ra,0($sp)
	addi $sp,$sp,4		#returns to RA
	jr $ra			#from where it was called

base:	lui $s1,0x1001		#base case: n=1
	add $s1,$a3,$s1
	addi $t0,$zero,1	#initialize t0 with 1	
b2:	bne $t0,$s0,baseMul	#calculates memory spaces based on N discs
	sw $t7,0($s1)		#loads the last disc in the top of the destiny tower
	lui $s1,0x1001		#loads origin address
	add $s1,$s1,$a3		
	sw $zero,0($s1)		#errases disk from origin (to "move")
	j bret			#returns to call
baseMul: addi, $s1,$s1,4	#counts 4 n times
	addi $t0,$t0,1		#j++
	j b2
	
recursion1:	addi $a0, $a0, -1	#height param -1
		add $t0, $zero, $a2	#switch dest with aux
		add $a2, $zero, $a3	
		add $a3, $zero, $t0
		addi $sp, $sp, -20	#backup temporaries
			sw $a1, 0($sp)
			sw $a2, 4($sp)
			sw $a3, 8($sp)	
			sw $ra, 12($sp)
		jal hanoi		#call hanoi,(N-1,ORIGIN, AUX, DESTINY)
			lw $a1, 0($sp)
			lw $a2, 4($sp)
			lw $a3, 8($sp)	
			lw $ra, 12($sp)
		addi $sp, $sp, 20
		jr $ra

move1:	addi $sp,$sp,-4
	sw $ra,0($sp)		#back up Register Address
		add $t6,$zero,$a1
		lui $t5,0x1001	
		jal addtopdisk
		add $t6,$zero,$a2
		lui $t5,0x1001
		jal removetopdisk
	lw $ra,0($sp)
	addi $sp,$sp,4		#returns to RA	
	jr $ra	
addtopdisk:	lw $t4,0($t6)
		beq $t4,$t5,retadd 
		j addtopdisk
retadd:		sw $t7,0($t6)
		jr $ra	
removetopdisk:	lw $t4,0($t6)
		beq $t4,$t5,retremove 
		j addtopdisk
retremove:	sw $zero,0($t6)
		jr $ra
		
recursion2:	addi $a0, $a0, -1	#height param -1
		add $t0, $zero, $a1	#switch dest with aux
		add $a1, $zero, $a2	
		add $a2, $zero, $t0
		addi $sp, $sp, -16	#backup temporaries
			sw $a1, 0($sp)
			sw $a2, 4($sp)
			sw $a3, 8($sp)	
			sw $ra, 12($sp)
		jal hanoi		#call hanoi,(N-1,AUX, DESTINY, ORIGIN)
			lw $a1, 0($sp)
			lw $a2, 4($sp)
			lw $a3, 8($sp)	
			lw $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra	
exit:	#end of program
