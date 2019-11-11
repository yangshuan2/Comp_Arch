.data
	str1: .asciiz "The highest score is: "
	str2: .asciiz "Traceback result:\n"
	nextline: .asciiz "\n"
	
#####################################################

# This part may change on different testing data

	seq1: .asciiz "CAAGAATGTCACAGGTCCAT"
	seq2: .asciiz "CAGCATCACACTTA"
	score: .word 0:315	#(len1 + 1) * (len2 + 1)
	dir: .word 0:315


.text
	main:	
		li $s0, 20		#seq 1 length
		li $s1, 14		#seq 2 length
		
#####################################################		
		
# Todo
		# use load byte instead of load word for reading the sequences
		la $s2, seq1
		la $s3, seq2
		la $s4, score
		la $s5, dir
		move $s6, $zero		# maxi
		move $s7, $zero		# maxj
		addi $s0, $s0, 1
		addi $s1, $s1, 1

		move $t0, $zero 	# i
	for1:
		slt $t2, $t0, $s1
		beq $t2, $zero, exit1
		move $t1, $zero 	# j
	for2:
		slt $t3, $t1, $s0
		beq $t3, $zero, exit2
		beq $t0, $zero, if1
		beq $t1, $zero, if1	# if(i == 0 || j == 0)
		addi $t8, $t0, -1	# i-1
		addi $t9, $t1, -1	# j-1
		mul $t7, $t8, $s0	# (i - 1) * len1
		add $t7, $t7, $t9
		sll $t7, $t7, 2
		add $t7, $s4, $t7	# score[i-1][j-1]
		lw $t2, 0($t7)		# a
		add $t7, $t9, $s2
		lb $t5, 0($t7)
		add $t7, $t8, $s3
		lb $t6, 0($t7)
		beq $t5, $t6, if2
		addi $t2, $t2, -1
		j endif2
	if2:
		addi $t2, $t2, 3
	endif2:
		mul $t7, $t8, $s0
		add $t7, $t7, $t1
		sll $t7, $t7, 2
		add $t7, $t7, $s4
		lw $t3, 0($t7)
		addi $t3, $t3, -2 	# b
		mul $t7, $t0, $s0
		add $t7, $t7, $t9
		sll $t7, $t7, 2
		add $t7, $t7, $s4
		lw $t4, 0($t7)
		addi $t4, $t4, -2 	# c
		move $t5, $zero		# max
		#move $t6, $zero		# dir[i][j]
		slt $t7, $t5, $t2
		beq $t7, $zero, endif3
		move $t5, $t2
		li $t6, 3
	endif3:
		slt $t7, $t5, $t3
		beq $t7, $zero, endif4
		move $t5, $t3
		li $t6, 2
	endif4:
		slt $t7, $t5, $t4
		beq $t7, $zero, endif5
		move $t5, $t4
		li $t6, 1
	endif5:
		
		mul $t7, $t0, $s0
		add $t7, $t7, $t1
		sll $t7, $t7, 2
		add $t2, $s4, $t7
		sw $t5, 0($t2)		# score[i][j] = max
		add $t3, $s5, $t7
		sw $t6, 0($t3)		# dir[i][j]
		mul $t4, $s6, $s0
		add $t4, $t4, $s7
		sll $t4, $t4, 2
		add $t4, $s4, $t4
		lw $t7, 0($t4)		# score[maxi][maxj]
		slt $t2, $t5, $t7
		bne $t2, $zero, endif6
		move $s6, $t0
		move $s7, $t1
	endif6:
		j endif1
	if1:
		mul $t4, $t0, $s0
		add $t4, $t4, $t1
		sll $t4, $t4, 2
		add $t5, $s4, $t4
		sw $zero, 0($t5)	# score[i][j] = 0
		add $t6, $s5, $t4
		sw $zero, 0($t6)	# dir[i][j] = 0
	endif1:
		addi $t1, $t1, 1	# j++
		j for2
	exit2:
		addi $t0, $t0, 1	# i++
		j for1
	exit1:
		li $v0, 4
		la $a0, str1
		syscall
		mul $t0, $s6, $s0
		add $t0, $t0, $s7
		sll $t0, $t0, 2		# 2 * (i * len1 + j)
		add $t1, $t0, $s4
		li $v0, 1
		lw $a0, 0($t1)
		syscall

		li $v0, 4
		la $a0, nextline
		syscall
		syscall
		la $a0, str2
		syscall

		li $v0, 1
		addi $t0, $s4, 276
		lw $a0, 0($t0)
		#syscall
	while1:
		mul $t0, $s6, $s0
		add $t0, $t0, $s7
		sll $t0, $t0, 2
		add $t0, $s5, $t0
		lw $t1, 0($t0)
		move $t2, $t1
		beq $t2, $zero, exitwhile1
		addi $t1, $t1, -1
		bne $t1, $zero, not1
		addi $s7, $s7, -1
		j printno
	not1:
		addi $t1, $t1, -1
		bne $t1, $zero, not2
		addi $s6, $s6, -1
		j printno
	not2:
		addi $s7, $s7, -1
		addi $s6, $s6, -1
	printno:
		move $a0, $t2
		syscall
		j while1
	exitwhile1:


		li $v0, 10
		syscall

