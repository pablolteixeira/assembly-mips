.data
    matrix:     .word 1, 2, 0, 1, -1, -3, 0, 1, 3, 6, 1, 3, 2, 4, 0, 3
    matrix_f:   .space 16
    fout:       .asciiz "transpose.dat"
    buffer:     .word 0:64
.text
allocate_bytes:
    li     $v0, 9        
    li     $a0, 16        
    syscall

    la     $s5, matrix_f    

MAIN:
    li     $v0, 13        
    la     $a0, fout   
    li     $a1, 1        
    syscall
    move   $s6, $v0   

    li     $s0, 0       
    li     $s1, 0     

    la     $s3, matrix   
    la     $s4, matrix_f    

LOOP1:
    sll    $t0, $s0, 2    
    sll    $t1, $s1, 2   

    add    $t0, $t0, $s1    
    add    $t1, $t1, $s0    

    sll    $t0, $t0, 2   
    sll    $t1, $t1, 2   

    add    $t0, $t0, $s3    
    add    $t1, $t1, $s4    

    lw     $t2, 0($t0)    
    sw     $t2, 0($t1)    

    addi   $s5, $s5, 4    
    addi   $s1, $s1, 1    
    bge    $s1, 4, LOOP2  
    j      LOOP1    	   

LOOP2:
    li     $s1, 0        
    addi   $s0, $s0, 1   

    bge    $s0, 4, EXIT   
    j      LOOP1 
        
EXIT:
    li     $v0, 15        
    move   $a0, $s6    
    la     $a1, matrix_f   
    la     $a2, 64        
    syscall

    li     $v0, 16        
    move   $a0, $s6    
    syscall
