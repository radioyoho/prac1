.data

.text
	#<init>
	addi $s0,$zero,3	#number of discs
	add $a0, $zero, $s0	#copy to a0
	lui $s1,0x1001		#Upper adress
	
	lui $a1,0x1001
	lui $a2,0x1001
	lui $a3,0x1001
	
	addi $a1,$a1, 0x00	#FROM tower
	addi $a2, $a2,0x20	#TO tower
	addi $a3, $a3, 0x40	#AUX tower	
fill: 
	sw $a0,0($s1)		#store in adress
	addi $s1, $s1, 4	#move adress
	addi $a0, $a0, -1	#sub 1 to disc tower	
	bne $a0, $zero, fill	#loop
	addi $a0, $s0, 1	#reinitialize a0
	jal hanoi
	j exit

	#</init>
hanoi: 
	#<base>
	bne $a0, $zero, first
	addi $a0, $a0, 1
	#POP
	addi $sp, $sp, 20
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)		
	lw $ra, 16($sp)
	
	jr $ra 			#go to move 
	#</base>
first: 
	
	addi $a0, $a0, -1	#SWITCH MEMORY ADRESSES AUX AND TO
	add $t0, $zero, $a2
	add $a2, $zero, $a3	
	add $a3, $zero, $t0
	
	#PUSH
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)	
	sw $ra, 16($sp)
	
	jal hanoi
	#RETURNS TO HERE AFTER FIRST GETS TO A0 = 0
	add $t2, $zero, $zero
movet: 
	#<MOVE>
	addi $t2, $t2, 1
	lw $t0, 0($a1)
	addi $a1, $a1, 4
	bne $t0, $zero, movet
	#found a 0 
	addi $a1, $a1, -8
	lw $t0, 0($a1)
	sw $zero, 0($a1)
	#return adress to original value
	addi $t2, $t2, -1
retvalue1:
	addi $t2, $t2, -1
	beq $t2, $zero, continue
	addi $a1, $a1, -4
	j retvalue1
continue:
	add $t2, $zero, $zero
place: 
	addi $t2, $t2, 1
	lw $t1, 0($a2)
	addi $a2, $a2, 4
	bne $t1, $zero, place
	#found a 0
	addi $a2, $a2, -4
	sw $t0, 0($a2)
	
retvalue2:
	addi $t2, $t2, -1
	beq $t2, $zero, second
	addi $a2, $a2, -4
	j retvalue2


	#</MOVE>
	#GOES TO SECOND RIGHT AFTER
second: 
	#SWITCH AUX -> FROM, FROM -> AUX
	addi $a0, $a0, -1
	add $t0, $zero, $a1
	add $a1, $zero, $a3
	add $a3, $zero, $t0
	
	#stack save
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)	
	sw $ra, 16($sp)
	
	
	jal hanoi
	
	#addi $sp, $sp, 20
	#lw $a0, 0($sp)
	#lw $a1, 4($sp)
	#lw $a2, 8($sp)
	#lw $a3, 12($sp)		
	#lw $ra, 16($sp)
	
	jr $ra
exit: 
	#POP AND RETURN TO FIRST
