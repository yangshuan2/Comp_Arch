.data
str1: .asciiz	"Before sorting: \n"
str2: .asciiz	"\nResult:\n"
str3: .asciiz	"\n"
num: .word -1 3 -5 7 -9 2 -4 6 -8 10

.text
main:
	#print initiate
	li $v0, 4
	la $a0, str1
	syscall
	la $a0, num	#a0=num
	la $a1, 10
	jal prints
	
	#TODO
	la $a0, num
	la $a1, 10
	move $s2, $a0
	move $s3, $a1
	move $s0, $zero
	for1:
	slt $t0, $s0, $s3
	beq $t0, $zero, exit1
	addi $s1, $s0, -1
	for2:
	slt $t0, $s1, $zero
	bne $t0, $zero, exit2
	sll $t1, $s1, 2
	add $t2, $s2, $t1
	lw $t3, 0($t2)
	lw $t4, 4($t2)
	slt $t0, $t4, $t3
	beq $t0, $zero, exit2
	sw $t4, 0($t2)
	sw $t3, 4($t2)
	addi $s1, $s1, -1
	j for2
	exit2:
	addi $s0, $s0, 1
	j for1
	exit1:
	
	#print result
	li $v0, 4
	la $a0, str2
	syscall
	la $a0, num	#a0=num
	la $a1, 10
	jal prints
	
# -----
#  Done, terminate program.
	li	$v0, 10				# terminate
	syscall					# system call

.end main

prints:
	addi $sp, $sp, -16
	sw $s3, 12($sp)
	sw $s2 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $zero
	move $s2, $a0
	move $s3, $a1
printloop:
	bge $s0, $s3, printexit
	sll $s1, $s0, 2
	add $t2, $s2, $s1
	lw $t3, 0($t2)
	li $v0, 1 # print_int
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, str3
	syscall 
	
	addi $s0, $s0, 1
	j printloop
printexit:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra