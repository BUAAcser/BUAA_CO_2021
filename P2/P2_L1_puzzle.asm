.data
    array: .space 400
    str_enter: .asciiz "\n"
    str_space: .asciiz " "
    .macro calc_addr(%addr,%i,%j,%n)
        mult %i, %n
        mflo %addr
        add %addr, %addr, %j
        sll %addr, %addr, 2
    .end_macro
.text
   li $v0, 5
   syscall 
   move $s0, $v0
   li $v0, 5
   syscall 
   move $s1, $v0
   
   li $t0, 0
   for_i:
       beq $t0, $s0, for_i_end
       li $t1,0
       for_j:
           beq $t1, $s1, for_j_end
           calc_addr($t2, $t0, $t1, $s1)
           li $v0, 5
           syscall
           sw $v0, array($t2)
           addi $t1, $t1, 1
           j for_j
       for_j_end:
       addi $t0, $t0, 1
       j for_i
    for_i_end:
    
    li $v0, 5
    syscall
    move $s2, $v0
    li $v0, 5
    syscall
    move $s3, $v0
    li $v0, 5
    syscall
    move $s4, $v0
    li $v0, 5
    syscall
    move $s5, $v0
    
    addi $s2, $s2, -1
    addi $s3, $s3, -1
    addi $s4, $s4, -1
    addi $s5, $s5, -1
        
    add $a0, $s2, $0
    add $a1, $s3, $0
    
    li $t3,0
    jal eDFS
    
    move $a0, $t3
    li $v0,1
    syscall
    li $v0,10
    syscall
    
    
eDFS:
    
    bne $a0, $s4, elif
    bne $a1, $s5, elif
    
    addi $t3, $t3, 1
    jr  $31
    
    elif:
        calc_addr($t2, $a0, $a1, $s1)
        li $t0, 2
        sw $t0, array($t2)
        
        li $t0, 1
        blt $a0, $t0, elif1
        addi $t4, $a0, -1
        add  $t5, $a1, $0
        calc_addr($t2, $t4, $t5, $s1)
        lw $t0, array($t2)
        bne $t0, $0, elif1
        
        sw $ra, 0($sp)
        subi $sp, $sp, 4
        sw $a0, 0($sp)
        subi $sp, $sp, 4
        sw $a1, 0($sp)
        subi $sp, $sp, 4
        
        subi $a0, $a0, 1
        jal eDFS
        
        addi $sp, $sp, 4
        lw $a1, 0($sp)  
        addi $sp, $sp, 4
        lw $a0, 0($sp) 
        addi $sp, $sp, 4
        lw $ra, 0($sp)   
        
        elif1:
        addi $t1, $s1, -2
        bgt $a1, $t1, elif2
        add $t4, $a0, $0
        addi  $t5, $a1, 1
        calc_addr($t2, $t4, $t5, $s1)
        lw $t0, array($t2)
        bne $t0, $0, elif2
        
        sw $ra, 0($sp)
        subi $sp, $sp, 4
        sw $a0, 0($sp)
        subi $sp, $sp, 4
        sw $a1, 0($sp)
        subi $sp, $sp, 4
        
        addi $a1, $a1, 1
        jal eDFS
        
        addi $sp, $sp, 4
        lw $a1, 0($sp)  
        addi $sp, $sp, 4
        lw $a0, 0($sp) 
        addi $sp, $sp, 4
        lw $ra, 0($sp)   
        
        elif2:
        addi $t0, $s0, -2
        bgt $a0, $t0, elif3
        addi $t4, $a0, 1
        add  $t5, $a1, $0
        calc_addr($t2, $t4, $t5, $s1)
        lw $t0, array($t2)
        bne $t0, $0, elif3
        
        sw $ra, 0($sp)
        subi $sp, $sp, 4
        sw $a0, 0($sp)
        subi $sp, $sp, 4
        sw $a1, 0($sp)
        subi $sp, $sp, 4
        
        addi $a0, $a0, 1
        jal eDFS
        
        addi $sp, $sp, 4
        lw $a1, 0($sp)  
        addi $sp, $sp, 4
        lw $a0, 0($sp) 
        addi $sp, $sp, 4
        lw $ra, 0($sp)   
        
        elif3:
        
        li $t1, 1
        blt $a1, $t1, elif4
        add $t4, $a0, $0
        addi  $t5, $a1, -1
        calc_addr($t2, $t4, $t5, $s1)
        lw $t0, array($t2)
        bne $t0, $0, elif4
        
        sw $ra, 0($sp)
        subi $sp, $sp, 4
        sw $a0, 0($sp)
        subi $sp, $sp, 4
        sw $a1, 0($sp)
        subi $sp, $sp, 4
        
        subi $a1, $a1, 1
        jal eDFS
        
        addi $sp, $sp, 4
        lw $a1, 0($sp)  
        addi $sp, $sp, 4
        lw $a0, 0($sp) 
        addi $sp, $sp, 4
        lw $ra, 0($sp)   
    
       elif4:
         calc_addr($t2, $a0, $a1, $s1)
        li $t0, 0
        sw $t0, array($t2)
        jr $31
    
    
       
           
           
   
        
       
