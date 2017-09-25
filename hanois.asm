.data
.text
	#<init>
	addi $t7, $zero, 1	#temporary to store 1

	addi $s0,$zero, 3	#number of discs
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
	j exit			#ra will return here after the last pop
	#</init>
hanoi:	
	addi $sp,$sp,-4
	sw $ra,0($sp)		#back up Register Address
		beq $a0, $t7, base	#if n>1 goes to recursion
		jal recursion1		#calls to switch aux and destiny
		jal move1		#makes the move
		jal recursion2		#calls to switch aux and origin
	lw $ra,0($sp)
	addi $sp,$sp,4		#returns to RA
	jr $ra			#from where it was called

base:	lui $s1,0x1001		#base case: n=1
	addi $t0,$zero,1	#initialize t0 with 1	
b2:	bne $t0,$s0,baseMul	#calculates memory spaces based on N discs
	sw $t7,0($s1)		#loads the last disc in the top of the destiny tower
	jr $ra			#returns to call
baseMul: addi, $s1,$s1,4	#counts 4 n times
	addi $t0,$t0,1		#j++
	j b2
	
recursion1:	
		addi $a0, $a0, -1	#height param -1
		add $t0, $zero, $a2	#switch dest with aux
		add $a2, $zero, $a3	
		add $a3, $zero, $t0
		addi $sp, $sp, -16	#backup temporaries
			sw $a1, 0($sp)
			sw $a2, 4($sp)
			sw $a3, 8($sp)	
			sw $ra, 12($sp)
		jal hanoi		#call hanoi,(N-1,ORIGIN, AUX, DESTINY)
			lw $a1, 0($sp)
			lw $a2, 4($sp)
			lw $a3, 8($sp)	
			lw $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra

move1:	addi $sp,$sp,-4
	sw $ra,0($sp)		#back up Register Address
		
#------------------------------MOVE-------------------------------------------------
	add $t2, $zero, $zero	#MOVE, adress+4 counter
movet: 
	#<MOVE>
	addi $t2, $t2, 1	#counter++
	lw $t0, 0($a1)		#load what is in org
	addi $a1, $a1, 4	#adress + 4
	bne $t0, $zero, movet	#if org !0 repeat
	#found a 0 
	addi $a1, $a1, -8	#return to last !0 adress
	lw $t0, 0($a1)		#load number to t0
	sw $zero, 0($a1)	#replace with 0
	#return adress to original value
	addi $t2, $t2, -1	#prepare counter
	
retvalue1:
	addi $t2, $t2, -1	#counter--
	beq $t2, $zero, continue#if zero, continue
	addi $a1, $a1, -4	#if !zero, adress - 4
	j retvalue1		#repeat
	
continue:
	add $t2, $zero, $zero	#reset adress+4 counter
	
place: 
	addi $t2, $t2, 1	#counter++
	lw $t1, 0($a2)		#load what is in dest tower
	addi $a2, $a2, 4	#adress + 4
	bne $t1, $zero, place	#if !zero, repeat
	
	addi $a2, $a2, -4	#found a 0, dec adress to 0
	sw $t0, 0($a2)		#place disc in dest
	
retvalue2:
	addi $t2, $t2, -1	#counter--
	beq $t2, $zero, return	#if counter  = zero, all good
	addi $a2, $a2, -4	#if !zero dec adress
	j retvalue2		#repeat
return:
		
	lw $ra,0($sp)
	addi $sp,$sp,4		#returns to RA	
	jr $ra
	
#----------------------------------/MOVE------------------------------------------------

recursion2:	
		addi $a0, $a0, -1	#height param -1
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

exit: #end of program