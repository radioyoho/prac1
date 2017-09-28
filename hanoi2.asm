.data
.text
	#<init>
	addi $t7, $zero, 1
	addi $s0,$zero,8	#number of discs
	add $a0, $zero, $s0	#copy to a0
	lui $s1,0x1001		#Upper adress
	
	lui $a1,0x1001		#upper adress
	lui $a2,0x1001		#upper adress
	lui $a3,0x1001		#upper adress
	
	addi $a1,$a1, 0x00	#FROM tower
	addi $a2, $a2,0x20	#TO tower
	addi $a3, $a3, 0x40	#AUX tower	
fill: 
	sw $a0,0($s1)		#store in adress
	addi $s1, $s1, 4	#move adress
	addi $a0, $a0, -1	#sub 1 to disc tower	
	bne $a0, $zero, fill	#loop
	add $a0, $zero, $s0	#reinitialize a0 plus one so hanoi calls for the first time in the function
	
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
movet: 
	lw $t0, 0($a1)		#load what is in org
	addi $a1, $a1, 4	#adress + 4
	bne $t0, $zero, movet	#if org !0 repeat
	#found a 0 
	addi $a1, $a1, -8	#return to last !0 adress
	lw $t0, 0($a1)		#load number to t0
	sw $zero, 0($a1)	#replace with 0
	
place: 
	lw $t1, 0($a2)		#load what is in dest tower
	addi $a2, $a2, 4	#adress + 4
	bne $t1, $zero, place	#if !zero, repeat
	
	addi $a2, $a2, -4	#found a 0, dec adress to 0
	sw $t0, 0($a2)		#place disc in dest

	#lw $ra, 16($sp)
	jr $ra			#RET BASE
		
#------------------------------/BASE------------------------------------------------
first:
	addi $a0, $a0, -1	#FIRST RECURSIVE
	add $t0, $zero, $a2	#switch dest with aux
	add $a2, $zero, $a3	
	add $a3, $zero, $t0
	
	jal hanoi
	
	addi $sp, $sp, 20	#func ended
	lw $a0, 0($sp)		#POP height
	lw $a1, 4($sp)		#POP org
	lw $a2, 8($sp)		#POP dest
	lw $a3, 12($sp)		#POP aux
#-----------------------------MOVE---------------------------------------------------
movet2: 
	lw $t0, 0($a1)		#load what is in org
	addi $a1, $a1, 4	#adress + 4
	bne $t0, $zero, movet2	#if org !0 repeat
	#found a 0 
	addi $a1, $a1, -8	#return to last !0 adress
	lw $t0, 0($a1)		#load number to t0
	sw $zero, 0($a1)	#replace with 0
place2: 
	lw $t1, 0($a2)		#load what is in dest tower
	addi $a2, $a2, 4	#adress + 4
	bne $t1, $zero, place2	#if !zero, repeat
	
	addi $a2, $a2, -4	#found a 0, dec adress to 0
	sw $t0, 0($a2)		#place disc in dest
#-----------------------------/MOVE---------------------------------------------------
second:
	addi $a0, $a0, -1	#FALL TO SECOND RECURSIVE
	add $t0, $zero, $a1	#swith org with aux
	add $a1, $zero, $a3
	add $a3, $zero, $t0
	
	jal hanoi

	addi $sp, $sp, 20	#func ended
	lw $ra, 16($sp)
	jr $ra
exit:
