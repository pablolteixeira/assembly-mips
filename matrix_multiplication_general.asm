.data	
	input_n: .asciiz "Escreva a ordem N da matrix quadrada: "
	first: .asciiz "Escreva a primeira matrix: \n"
	second: .asciiz "Escreva a segunda matrix: \n"
	nome_arquivo: .asciiz "produto.txt"
	arquivo_final: .space 2048
.text
MAIN:	
	### Leitura do N
	
	# Print da frase "input_n"
	li 	$v0, 4
	la	$a0, input_n
	syscall
	
	# Input do N
	li 	$v0, 5
	syscall
	
	# $s0 = N
	move 	$s0, $v0 
	
	####################################
	### Leitura da primeira matriz
	
	# Print da frase "first"
	li 	$v0, 4
	la	$a0, first
	syscall 
	
	# Alocando memória para a matrix A
	li 	$v0, 9
	mul	$t0, $s0, $s0
	mul 	$t0, $t0, 4
	move	$a0, $t0
	syscall
	
	# $s1 = endereço inicial da matrix A
	move 	$s1, $v0
	
	# Chamada de procedimento e $a0 = 0
	li	$a0, 0
	la	$a1, ($s1)
	mul	$a3, $s0, $s0
	jal	INPUT
	#####################################
	
	
	####################################
	### Leitura da segunda matriz
	
	#Print da frase "second"
	li 	$v0, 4
	la	$a0, second
	syscall 
	
	# Alocando memória para a matrix B
	li 	$v0, 9
	mul	$t0, $s0, $s0
	mul 	$t0, $t0, 4
	move	$a0, $t0
	syscall
	
	# $s2 = endereço inicial da matrix B
	move 	$s2, $v0
	
	# Chamada de procedimento e $a0 = 0
	li	$a0, 0
	la	$a1, ($s2)
	mul	$a3, $s0, $s0
	jal	INPUT
	
	####################################
	
	###################################
	## Alocação de memória para a matrix final
	li 	$v0, 9
	mul	$t0, $s0, $s0
	mul 	$t0, $t0, 4
	move	$a0, $t0
	syscall
	
	# $s3 = endereço inicial da matrix final
	move 	$s3, $v0
	
	####################################
	## Chamada de procedimento para multiplicação de matrix
	
	li 	$a0, -1	# $a0 serve como index para o loop
	la	$a1, ($s1) # $a1 serve como endereço base da Matrix A
	la	$a2, ($s2) # $a2 serve como endereço base da Matrix B
	la	$a3, ($s3) # $a3 serve como endereço base da Matrix Final
	jal	MULT_MATRIX_1
	
	###################################
	## Abrir arquivo "produto.txt"
	
	li 	$v0, 13
	la	$a0, nome_arquivo
	li	$a1, 1
	li	$a2, 0
	syscall
	
	move	$s6, $v0
	
	li	$s5, -1
	li	$a0, -1
	la	$a1, arquivo_final
	move	$a2, $s3
	li	$a3, -1
	jal	CONVERTER_ASCII_1
	
	####################################
	## Escrita no arquivo
	
	li	$v0, 15
	move	$a0, $s6
	la	$a1, arquivo_final
	li	$a2, 2048
	syscall
	
	###################################
	## Fechar arquivo
	
	li	$v0, 16
	move 	$a0, $s6
	syscall
	
	#Jump para final
	j	EXIT
	
CONVERTER_ASCII_1:
	# $a3 = contador para localizar elemento na heap e mandar para converter em ASCII
	addi	$a3, $a3, 1
	
	# Guardar $ra antes de chamar um pŕoximo jal
	addi	$sp, $sp, -8
	sw	$a3, 4($sp)
	sw	$ra, 0($sp)
	
	# Pegar o elemento da matrix_final[i]
	move	$t0, $a3
	mul	$t0, $t0, 4
	add	$t0, $t0, $a2
	
	move	$a3, $t0
	lw	$a3, 0($a3)
	li	$a0, 0
	jal	CONVERTER_ASCII_2	
	
	lw	$ra, 0($sp)
	lw	$a3, 4($sp)
	addi	$sp, $sp, 8
	
	mul	$t0, $s0, $s0 
	addi	$t0, $t0, -1 
	
	bne 	$a3, $t0, CONVERTER_ASCII_1
	
	jr	$ra

CONVERTER_ASCII_2:
	li	$t0, 10
	div 	$a3, $t0
	
	mflo	$a3
	mfhi	$t1
	
	addi	$sp, $sp, -4
	sw	$t1, 0($sp)
	
	addi	$a0, $a0, 1
	
	bne 	$a3, 0, CONVERTER_ASCII_2
	
	move	$s7, $ra
	
	jal	CONVERTER_ASCII_3
	
	addi	$s5, $s5, 1
	
	move	$t1, $s5
	mul	$t1, $t1, 4
	add	$t1, $t1, $a1
	
	li	$t0, 32
	
	sw	$t0, 0($t1)
	
	move	$ra, $s7
	
	jr	$ra

CONVERTER_ASCII_3:
	addi	$s5, $s5, 1
	
	lw	$t0, 0($sp)
	addi	$sp, $sp, 4
	
	move	$t1, $s5
	mul	$t1, $t1, 4
	add	$t1, $t1, $a1
	
	addi	$t0, $t0, 48
	
	sw	$t0, 0($t1)
	
	
	addi	$a0, $a0, -1	

	bne	$a0, 0, CONVERTER_ASCII_3
	
	
	
	jr	$ra

INPUT:	
	# Leitura de um número inteiro
	li 	$v0, 5
	syscall
	
	# $t0 = $a0(index) * 4
	mul 	$t0, $a0, 4
	# $t0 = $t0 + $a1(endereço da matrix)
	add	$t0, $t0, $a1
	
	# Posição 0 do endereço $t0 vai receber $v0
	sw	$v0, 0($t0)
	
	# Adição de 1 no index
	addi	$a0, $a0, 1
	
	# Se $a0 for diferente de $s0, o código voltara para o início do procedimento
	bne 	$a0, $a3, INPUT
	
	# Jump para onde foi chamado o procedimento
	jr	$ra

MULT_MATRIX_1:
	# Adicionar 1 ao index
	addi 	$a0, $a0, 1
	move	$s4, $a0
	# Guardar $ra no stack
	addi	$sp, $sp, -20
	sw	$a3, 16($sp)
	sw	$a2, 12($sp)
	sw	$a1, 8($sp)
	sw	$a0, 4($sp)
	sw	$ra, 0($sp)	
	
	
	mul	$a0, $a0, $s0
	mul	$a0, $a0, 4
	# $a1 vai corresponder de forma analoga a matrix[i]
	add	$a1, $a0, $a1
	# $a0 vai servir também como index para MULT_MATRIX_2
	li	$a0, -1
	jal	MULT_MATRIX_2
	
	#Retirando dados da Stack
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$a2, 12($sp)
	lw	$a3, 16($sp)
	addi	$sp, $sp, 20
	
	move 	$t0, $s0
	addi	$t0, $t0, -1
	
	# Continuara no loop enquanto $a0 != N
	bne	$a0, $t0, MULT_MATRIX_1
	
	jr	$ra
	
MULT_MATRIX_2:	
	# Adicionar 1 ao index
	addi 	$a0, $a0, 1
	move	$s5, $a0
	# Guardar $ra no stack
	addi	$sp, $sp, -20
	sw	$a3, 16($sp)
	sw	$a2, 12($sp)
	sw	$a1, 8($sp)
	sw	$a0, 4($sp)
	sw	$ra, 0($sp)
	
	# $a0 = $a0(index) * 4
	mul 	$a0, $a0, 4
	# $a2 = $a0 + $a2
	add 	$a2, $a0, $a2
	
	li	$a0, -1
	li	$s7, 0
	jal	MULT_MATRIX_3
	
	#Retirando dados da Stack
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$a2, 12($sp)
	lw	$a3, 16($sp)
	addi	$sp, $sp, 20
	
	move 	$t0, $s0
	addi	$t0, $t0, -1
	
	# Continuara no loop enquanto $a0 != N
	bne	$a0, $t0, MULT_MATRIX_2
	
	jr	$ra
	
MULT_MATRIX_3:
	addi	$a0, $a0, 1 
	
	## Pegando o elemento da primeira matrix A
	mul	$t0, $a0, 4
	add	$t0, $t0, $a1 
	
	lw	$t0, ($t0)
	
	## Pegando o elemento da segunda matrix B
	mul	$t1, $a0, $s0
	mul	$t1, $t1, 4
	add	$t1, $t1, $a2 
	
	lw	$t1, ($t1)
	
	
	## Multiplicar os dois elementos
	mult	$t0, $t1
	mflo	$t2
	
	add	$s7, $s7, $t2
	
	move 	$t0, $s0
	addi	$t0, $t0, -1
	
	bne	$a0, $t0, MULT_MATRIX_3
	
	## Pegar endereço para guardar o elemento na matrix final
	mul	$t3, $s4, $s0
	add	$t3, $t3, $s5
	mul	$t3, $t3, 4
	add	$t3, $t3, $a3 
	sw	$s7, ($t3)
	
	jr	$ra

EXIT: