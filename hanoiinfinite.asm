.data
.text
	#<init>
	addi $t7, $zero, 1
	addi $s0,$zero,8	#number of discs
	add $a0, $zero, $s0	#copy to a0
	lui $s1,0x1001		#Upper address
	
	lui $a1,0x1001		#upper address
	lui $a2,0x1001		#upper address
	lui $a3,0x1001		#upper address
	
	addi $a1,$a1, 0x00	#FROM tower
	addi $a2, $a2,0x20	#TO tower
	addi $a3, $a3, 0x40	#AUX tower	
fill: 
	sw $a0,0($s1)		#store in address
	addi $s1, $s1, 4	#move address
	addi $s2, $s2, 4
	addi $a0, $a0, -1	#sub 1 to disc tower	
	bne $a0, $zero, fill	#loop
	
	add $a0, $zero, $s0
	add $s1, $zero, $s2
	add $s2, $zero, $zero
	
	jal hanoi
	j exit			#ra will return here after the last pop


#----------------------------MAIN--------------------------------------------------
hanoi:
	addi $sp, $sp, -20	#PUSH
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)	
	sw $ra, 16($sp)
	
	beq $a0, $t7, base	#if !1 goes to first recursive func
	j first
	
#----------------------------/MAIN--------------------------------------------------
base:
#------------------------------BASE-------------------------------------------------
	addi $s1, $s1, -4
	add $s3, $a1, $s1
	add $s4, $a2, $s2
	lw $t0, 0($s3)		#load what is in org
	sw $zero, 0($s3)	#replace with 0
	sw $t0, 0($s4)		#place disc in dest
	addi $s2, $s2, 4
	
	
	#lw $ra, 16($sp)
	jr $ra			#RET BASE
		
#------------------------------/BASE------------------------------------------------
first:
	addi $a0, $a0, -1	#FIRST RECURSIVE
	add $t0, $zero, $a2	#switch dest with aux
	add $a2, $zero, $a3	
	add $a3, $zero, $t0
	
	add $t0, $zero, $s2	#switch dest with aux
	add $s2, $zero, $s5	
	add $s5, $zero, $t0
	
	jal hanoi
	
	addi $sp, $sp, 20	#func ended
	lw $a0, 0($sp)		#POP height
	lw $a1, 4($sp)		#POP org
	lw $a2, 8($sp)		#POP dest
	lw $a3, 12($sp)		#POP aux
	
	add $t0, $zero, $s2	#switch dest with aux
	add $s2, $zero, $s5	
	add $s5, $zero, $t0
	
	#add $t0, $zero, $s1	#switch dest with aux
	#add $s1, $zero, $s5	
	#add $s5, $zero, $t0
#-----------------------------MOVE---------------------------------------------------

	addi $s1, $s1, -4
	add $s3, $a1, $s1
	add $s4, $a2, $s2
	lw $t0, 0($s3)		#load what is in org
	sw $zero, 0($s3)	#replace with 0
	sw $t0, 0($s4)		#place disc in dest
	addi $s2, $s2, 4

#-----------------------------/MOVE---------------------------------------------------
second:

	addi $a0, $a0, -1	#FALL TO SECOND RECURSIVE
	add $t0, $zero, $a1	#swith org with aux
	add $a1, $zero, $a3
	add $a3, $zero, $t0
	
	add $t0, $zero, $s1	#switch dest with aux
	add $s1, $zero, $s5	
	add $s5, $zero, $t0
	
	jal hanoi
	
	add $t0, $zero, $s1	#switch dest with aux
	add $s1, $zero, $s5	
	add $s5, $zero, $t0
	
	addi $sp, $sp, 20	#func ended
	lw $ra, 16($sp)
	jr $ra
exit:
