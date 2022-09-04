.data
    symbol: .space 40
    array:  .space 40
    str_enter: .asciiz "\n"
    str_space: .asciiz " "
 
 .text
    li $v0,5
    syscall
    move $s0,$v0
    li $a1, 0
    jal Fullarray
    li $v0 ,10
    syscall
    
    Fullarray:
    blt $a1, $s0, elif
    li $t0, 0
    for_1:
    beq $t0, $s0, for_1_end
    sll $t1, $t0,2 
    lw $a0, array($t1)
    li $v0,1
    syscall
    la $a0, str_space
    li $v0, 4
    syscall
    addi $t0, $t0, 1
    j for_1
    for_1_end:
    la $a0, str_enter
    li $v0, 4
    syscall
    jr $31
    
    elif:
    li $t0, 0
    for_2:
    beq $t0, $s0, for_2_end
    sll $t1, $t0, 2
    lw $t2, symbol($t1) 
    bne $t2, $0, notequal
    
    sll $t1, $a1,2
    addi $s1, $t0, 1 
    sw $s1,array($t1)
  
    li $s2,1
    sll $t1, $t0, 2
    sw $s2, symbol($t1) 
    
    sw  $ra, 0($sp)
    sub $sp, $sp, 4
    sw  $a1, 0($sp)
    sub $sp, $sp, 4
    sw  $t0, 0($sp)
    sub $sp, $sp, 4
    
    addi $a1, $a1, 1
    jal Fullarray
    
    addi $sp, $sp, 4
    lw $t0, 0($sp)
    addi $sp, $sp,4
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $ra, 0($sp)
    

    sll $t1, $t0, 2
    sw $0, symbol($t1) 
    
    notequal:
    addi $t0, $t0, 1
    j for_2
    for_2_end:
    jr $31
    