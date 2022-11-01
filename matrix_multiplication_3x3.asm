.data
	A:	.word 1 2 3 0 1 4 0 0 1		# 1 2 3	  1 -2  5   1 0 0 
	B:	.word 1 -2 5 0 1 -4 0 0 1	# 0 1 4	x 0  1 -4 = 0 1 0
	C:	.space 9			# 0 0 1	  0  0  1   0 0 1

.text
MAIN:
	# Declaração I = 0
	li	$s0, -1
	
	# Declaração Endereço A
	la	$s3, A
	
	# Declaração Endereço A
	la	$s4, B
	
	# Declaração Endereço A
	la	$s5, C
	
	# Declaração de TAM = 3
	li	$s6, 3
	
	j	LOOP1
	
LOOP1:	
	beq 	$s0, 2, EXIT
	
	# Declaração J = 0
	li	$s1, -1
	
	addi	$s0, $s0, 1
	
	j 	LOOP2
LOOP2:
	beq	$s1, 2, LOOP1
	
	# Declaração K = 0
	li	$s2, -1
	
	addi	$s1, $s1, 1
	
	# Declaração SUM = 0
	li	$t0, 0
	
	j	LOOP3
LOOP3:
	# Somar +1 em K
	addi	$s2, $s2, 1
	
	## TAM*I + K ##
	
	# $t1 = TAM*i
	mul	$t1, $s6, $s0
	
	# $t1 = $t1 + k
	add	$t1, $t1, $s2
	
	# $t1 = $t1 * 4
	li	$t4, 4
	mul	$t1, $t1, $t4 
	
	# $t1 = $t1 + $s3
	add	$t1, $t1, $s3
	
	lw	$t1, ($t1)
	
	
	## TAM*K + J ##
	
	# $t2 = TAM*K
	mul	$t2, $s6, $s2
	 
	# $t2 = $t2 + J
	add	$t2, $t2, $s1
	
	# $t2 = t2 * 4
	li	$t4, 4
	mul	$t2, $t2, $t4
	
	# $t2 = $t2 + $s3
	add	$t2, $t2, $s4
	
	lw	$t2, ($t2)
	
	
	# $t1 = $t1 * $t2
	mul	$t1, $t1, $t2
	
	# soma += $t1
	add	$t0, $t0, $t1
	
	beq	$s2, 2, SOMA
	
	j	LOOP3
	
SOMA:
	#C[TAM * I + J] = soma
	
	# $t3 = TAM * I
	mul	$t3, $s6, $s0
	
	# $t3 = $t3 + J
	add	$t3, $t3, $s1
	
	# $t3 = $t3 * 4
	li	$t4, 4
	mul	$t3, $t3,$t4 
	
	# $t3 = $t3 + C
	add	$t3, $t3, $s5
		
	sw	$t0, ($t3)


	j	LOOP2
EXIT:

