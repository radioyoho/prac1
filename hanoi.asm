.data

.text
	#<init>
	
	addi $s0,$zero,3	#number of discs
	add $a0, $zero, $s0	#copy to a0
	lui $s1,0x1001		#Upper adress
	
	
	
	lui $a1,0x1001
	lui $a2,0x1001
	lui $a3,0x1001
	
	addi $a1,$zero, 0x00	#FROM tower
	addi $a2, $zero,0x20	#TO tower
	addi $a3, $zero, 0x40	#AUX tower	
fill: 
	sw $a0,0($s1)		#store in adress
	addi $s1, $s1, 4	#move adress
	addi $a0, $a0, -1	#sub 1 to disc tower	
	bne $a0, $zero, fill	#loop
	add $a0, $zero, $s0	#reinitialize a0
	
	addi $sp, $sp, -20	#first stack save
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)		
	sw $ra, 16($sp)
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
	#SWITCH MEMORY ADRESSES AUX AND TO
	addi $a0, $a0, -1
	add $t0, $zero, $a2
	add $a2, $zero, $a3
	add $a3, $zero, $t0
	
	#stack save
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)	
	sw $ra, 16($sp)
	
	jal hanoi
	#RETURNS TO HERE AFTER FIRST GETS TO A0 = 0
	
movet: 
	#<MOVE>
	lw $t0, $a1(0)
	addi $a1, $a1, 4
	bne $t0, $zero, movet
	#found a 0 
	addi $a1, $a1, -8
	lw $t0, $a1(0)
	sw $zero, $a1(0)
place: 
	lw $t1, $a2(0)
	addi $a2, $a2, 4
	bne $t0, $zero, place
	#found a 0
	addi 
	
	
	#checar la ultima torre (ver cual es zero)
	#mover la torre a la ultima de la siguiente (ver cual es zero)
	
	
	
	
	
	
	
	
	
	
	#</MOVE>
	#GOES TO SECOND RIGHT AFTER
second: 
	#SWITCH AUX -> FROM, FROM -> AUX
	addi $a0, $a0, -1
	add $t0, $zero, $a1
	add $a1, $zero, $a3
	add $a3, $zero, $t0
	jal hanoi
	
	addi $sp, $sp, 20
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)		
	lw $ra, 16($sp)
	
	jr $ra
	
	#POP AND RETURN TO FIRST
