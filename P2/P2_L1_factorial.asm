.data
   array: .space 4800
   .macro calc_addr(%addr,%i)
      li  %addr, 0
      add %addr, %addr, %i
      sll %addr, %addr, 2
   .end_macro
   
 .text 
    li $v0, 5
    syscall
    move $s0, $v0
    li $t0,1
    calc_addr($t2,$t0)
    sw $t0, array($t2)   #array[1]=1
    
    li $s1, 1
    li $s2, 0
    li $t0, 2
    for_i:
    bgt $t0, $s0, for_i_end
        li $t1, 1
        for_j:
        bgt $t1, $s1, for_j_end
        calc_addr($t2, $t1)
        lw $t3, array($t2)  # $t3 = array[j]
        mult $t3, $t0          #$t4 =array[j]*i+cin    
        mflo $t4               #$t4 =array[j]*i+cin    
        add $t4, $t4, $s2     #$t4 =array[j]*i+cin    
        li $t5, 10
        div $t4, $t5
        mflo $s2
        mfhi $t3
        calc_addr($t2, $t1)
        sw $t3, array($t2) 
        
        bne $t1, $s1, elif
        beq $s2, $0,  elif
        addi $s1, $s1, 1
        
        elif:
        addi $t1, $t1, 1
        j for_j
        for_j_end:
    addi $t0, $t0, 1
    j for_i
    for_i_end:
    
    move $t0, $s1
    out:
    beq $t0, $0,end
    calc_addr($t2, $t0)
    lw $a0, array($t2) 
    li $v0, 1
    syscall
    
    subi $t0, $t0, 1
    j out
    end:
    li $v0, 10
    syscall
    
    
    
    