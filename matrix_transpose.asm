.data
	MTX:	.word  1 2 0 1 -1 -3 0 1 3 6 1 3 2 4 0 3
	MTX_F:	.space 16
.text
MAIN:	
	# Indice Linha
	li 	$s2, -1
	
	# Multiplicador
	li	$s3, 4
	
	# Endereço MTX
	la	$s4, MTX
	
	# Endereço MTX_F
	la	$s5, MTX_F
	
	
	j	LOOP1
	
LOOP1:	
	# Indice Coluna
	li	$s1, 0
	
	# Soma +1 no Indice Linha
	addi	$s2, $s2, 1
	
	beq	$s2, 4, EXIT
	
	# Soma +1 no Indice Linha
	
	j	LOOP2
	
LOOP2:	
	### Encontrar elemento da matrix principal ###
	
	# $t2 = coluna * 4
	mul	$t2, $s1, $s3
	
	# $t2 = $t2 + linha
	add	$t2, $t2, $s2
	
	# $t2 = $t2 * 4
	mul	$t2, $t2, $s3
	
	# $t2 = $t2 + base
	add	$t2, $t2, $s4
	
	
	lw	$t0, ($t2)
	
	
	### Inserir elemento na matrix final ###
	
	# $t2 = linha * 4
	mul	$t2, $s2, $s3
	
	# $t2 = $t2 + coluna
	add	$t2, $t2, $s1
	
	# $t2 = $t2 * 4
	mul	$t2, $t2, $s3
	
	# $t2 = $t2 + base
	add	$t2, $t2, $s5
	
	
	sw	$t0, ($t2)
	
	# Soma +1 no Indice Coluna
	addi	$s1, $s1, 1
	
	# Caso coluna == 4, irá para o Loop
	beq 	$s1, 4, LOOP1
	
	j	LOOP2
EXIT:


