.text
	addi $t7, $zero, 1	#temporary to store 1
	addi $s0,$zero, 8	#number of discs
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
hanoi:	addi $sp,$sp,-8
	sw $ra,0($sp)		#back up Register Address
		beq $a0, $t7, base	#if n>1 goes to recursion
		jal recursion1		#calls to switch aux and destiny
		jal move1		#makes the move
		jal recursion2		#calls to switch aux and origin
	lw $ra,0($sp)
	addi $sp,$sp,8		#returns to RA
	jr $ra	
		
base:	jal move1
	lw $ra,0($sp)
	lw $a0,4($sp)
	addi $sp,$sp,8		#returns to RA
	jr $ra			#from where it was called
	
recursion1:	addi $sp, $sp, -20	#backup temporaries
			sw $a1, 0($sp)
			sw $a2, 4($sp)
			sw $a3, 8($sp)	
			sw $ra, 12($sp)
			sw $a0, 16($sp)
		addi $a0, $a0, -1	#height param -1
		add $t0, $zero, $a2	#switch dest with aux
		add $a2, $zero, $a3	
		add $a3, $zero, $t0
		jal hanoi		#call hanoi,(N-1,ORIGIN, AUX, DESTINY)
			lw $a1, 0($sp)
			lw $a2, 4($sp)
			lw $a3, 8($sp)	
			lw $ra, 12($sp)
			lw $a0, 16($sp)
		addi $sp, $sp, 20
		jr $ra

move1:	addi $sp,$sp,-4		#move disks in memory function
	sw $ra,0($sp)		#back up Register Address
		add $t6,$zero,$a1	#load as temporary the origin tower address
		add $t5,$zero,$zero	#initialize a counter	
		jal removetopdisk	#remove the top disk
		add $t6,$zero,$a3	#load as temporary the destiny tower address
		add $t5,$zero,$zero	#Re-initialize a counter
		jal addtopdisk		#add a disk on top of destiny
	lw $ra,0($sp)
	addi $sp,$sp,4		#returns to RA	
	jr $ra	
addtopdisk:	lw $t4,0($t6)		#loads in t4 pos 0 of origin tower
		beq $t4,$t5,retadd	#compares pos 0 with zero
		addi $t6,$t6,4		#jumps to next position in tower
		j addtopdisk		#goes to loop
retadd:		sw $t2,0($t6)
		jr $ra	
removetopdisk:	lw $t4,0($t6)		#loads in t4 pos 0 of origin tower
		beq $t4,$t5,retremove 
		addi $t6,$t6,4		#jumps to next position in tower
		j removetopdisk
retremove:	addi $t6,$t6,-4		#returns to pos-1 (top disk)
		lw $t2,0($t6)		#stores top disk in t2
		sw $zero,0($t6)		#removes top disk from origin
		jr $ra
	
recursion2:	addi $sp, $sp, -20	#backup temporaries
			sw $a1, 0($sp)
			sw $a2, 4($sp)
			sw $a3, 8($sp)	
			sw $ra, 12($sp)
			sw $a0, 16($sp)
		addi $a0, $a0, -1	#height param -1
		add $t0, $zero, $a1	#switch dest with aux
		add $a1, $zero, $a2	
		add $a2, $zero, $t0
		jal hanoi		#call hanoi,(N-1,AUX, DESTINY, ORIGIN)
			lw $a1, 0($sp)
			lw $a2, 4($sp)
			lw $a3, 8($sp)	
			lw $ra, 12($sp)
			lw $a0, 16($sp)
		addi $sp, $sp, 20
		jr $ra	
exit:	#end of program