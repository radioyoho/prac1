.data
.text
	#<init>
	addi $t7, $zero, 1	#Number to compare for base case
	addi $s0,$zero,8	#number of discs
	add $a0, $zero, $s0	#copy to a0
	lui $s1,0x1001		#Upper address to fill origin tower
	
	lui $a1,0x1001		#Origin tower
	lui $a2,0x1001		#Destination tower
	lui $a3,0x1001		#Auxiliar tower
	
	addi $a1,$a1, 0x00	#adding last digits of tower addresses
	addi $a2, $a2,0x20	
	addi $a3, $a3, 0x40		
fill: 
	sw $a0,0($s1)		#store in address
	addi $s1, $s1, 4	#move address
	addi $s2, $s2, 4	#counter for origin tower position
	addi $a0, $a0, -1	#sub 1 to disc counter
	bne $a0, $zero, fill	#loop
	
	add $a0, $zero, $s0	#return the number of discs to a0
	add $s1, $zero, $s2	#s1 turns into the origin tower level
	add $s2, $zero, $zero	#reinitialize s2 so it becomes the destination tower level
	
	jal hanoi		#start function
	j exit			#jump to exit

#----------------------------MAIN--------------------------------------------------
hanoi:
	addi $sp, $sp, -20	#PUSH = saving height, org,dest,aux towers and ra
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)	
	sw $ra, 16($sp)
	
	beq $a0, $t7, base	#If height = 1, jumps to base case
	j first
	
#----------------------------/MAIN--------------------------------------------------
base:
#------------------------------BASE-------------------------------------------------
	addi $s1, $s1, -4	#Subtract from origin level
	add $s3, $a1, $s1	#add levels to addresses
	add $s4, $a2, $s2
	lw $t0, 0($s3)		#load what is in org
	sw $zero, 0($s3)	#replace with 0
	sw $t0, 0($s4)		#place disc in dest
	addi $s2, $s2, 4	#add a level to destination
	
	jr $ra			#RET BASE
		
#------------------------------/BASE------------------------------------------------
first:
	addi $a0, $a0, -1	#FIRST RECURSIVE FUNCTION	
	add $t0, $zero, $a2	#switch dest with aux
	add $a2, $zero, $a3	
	add $a3, $zero, $t0
	
	add $t0, $zero, $s2	#switch levels dest with aux
	add $s2, $zero, $s5	
	add $s5, $zero, $t0
	
	jal hanoi		#calls recursive function
	
	addi $sp, $sp, 20	#POP (out of recursive function, no need to load ra)
	lw $a0, 0($sp)		
	lw $a1, 4($sp)		
	lw $a2, 8($sp)		
	lw $a3, 12($sp)		
	
	add $t0, $zero, $s2	#switch levels dest with aux
	add $s2, $zero, $s5	
	add $s5, $zero, $t0
#-----------------------------MOVE---------------------------------------------------

	addi $s1, $s1, -4	#subtract a level from org tower
	add $s3, $a1, $s1	#add tower levels to addresses
	add $s4, $a2, $s2
	lw $t0, 0($s3)		#load what is in org
	sw $zero, 0($s3)	#replace with 0
	sw $t0, 0($s4)		#place disc in dest
	addi $s2, $s2, 4	#add a level to destination tower

#-----------------------------/MOVE---------------------------------------------------
second:

	addi $a0, $a0, -1	#SECOND RECURSIVE FUNCTION
	add $t0, $zero, $a1	#swith org with aux
	add $a1, $zero, $a3
	add $a3, $zero, $t0
	
	add $t0, $zero, $s1	#switch levels dest with aux
	add $s1, $zero, $s5	
	add $s5, $zero, $t0
	
	jal hanoi		#call recursive function
	
	add $t0, $zero, $s1	#switch levels dest with aux
	add $s1, $zero, $s5	
	add $s5, $zero, $t0
	
	addi $sp, $sp, 20	#POP, only ra is needed
	lw $ra, 16($sp)
	jr $ra
exit:
