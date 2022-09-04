.data
    martix : .space 400
    core: .space 400
    result: .space 400
    str_enter : .asciiz "\n"
    str_space :  .asciiz " "
    .macro calc_addr(%addr,%i,%j,%n)
         mult %i, %n
         mflo %addr
         add %addr, %addr, %j
         sll %addr, %addr, 2
    .end_macro
 
 .text 
    li $v0 ,5
    syscall
    move $s0,$v0
    li $v0 ,5
    syscall
    move $s1, $v0
    li $v0 ,5
    syscall
    move $s2, $v0
    li $v0 ,5
    syscall
    move $s3, $v0   # int $s0 = m1, $s1 = n1, $s2 = m2, $s3 = n2
    
    li $t0 ,0
    for1_i:
        beq $t0, $s0, end1_i
        li  $t1 ,0
        for1_j:
            beq $t1,$s1,end1_j
            calc_addr($t2,$t0,$t1,$s1)
            li $v0, 5
            syscall
            sb $v0, martix($t2)
            addi $t1, $t1, 1
            j for1_j
        end1_j:
        addi $t0, $t0, 1
        j for1_i
    end1_i:
    
    li $t0 ,0
    for2_i:
        beq $t0, $s2, end2_i
        li  $t1 ,0
        for2_j:
            beq $t1,$s3,end2_j
            calc_addr($t2,$t0,$t1,$s3)
            li $v0, 5
            syscall
            sb $v0, core($t2)
            addi $t1, $t1, 1
            j for2_j
        end2_j:
        addi $t0, $t0, 1
        j for2_i
    end2_i:
    
    ##这里$t2 不能用来存储offset了
    sub $s4, $s0, $s2
    sub $s5, $s1, $s3
    addi $s4, $s4, 1
    addi $s5, $s5, 1   # $s4 =  m1-m2+1  $s5 = n1 -n2 +1
    li $t0, 0
    get_i: 
        beq $t0, $s4, get_i_end
        li $t1, 0
        get_j:
            beq $t1, $s5, get_j_end
            li $t2,0
            li $t8, 0
            cal_i:
                beq $t2, $s2, cal_i_end
                li $t3, 0
                cal_j:
                    beq $t3, $s3, cal_j_end
                    add $s6, $t0, $t2  #s6 存martix 的行
                    add $s7, $t1, $t3   #7  存martix的列
                    calc_addr($t4, $s6, $s7, $s1)
                    lw $t5, martix($t4)
                    calc_addr($t4, $t2, $t3, $s3)
                    lw $t6, core($t4)
                    mult $t5, $t6
                    mflo $t7
                    add $t8, $t8, $t7
                    addi $t3,$t3,1
                    j cal_j
                cal_j_end:
                addi $t2,$t2,1
                j cal_i
          cal_i_end:
          calc_addr($t4,$t0,$t1,$s5)
          sw $t8, result($t4)
          addi $t1, $t1, 1
          j get_j
        get_j_end:
        addi  $t0, $t0 ,1
        j get_i
    get_i_end:
    
   li $t0 ,0
   out_i:
   beq $t0 ,$s4 , out_i_end
   li $t1 ,0
   out_j:
   beq $t1 , $s5 ,out_j_end
   calc_addr($t2,$t0,$t1,$s5)
   lw $a0, result($t2)
   li $v0 ,1
   syscall
   la $a0,str_space
   li $v0,4
   syscall
   addi $t1,$t1,1
   j out_j
   out_j_end:
   la $a0, str_enter
   li $v0 ,4
   syscall
   addi $t0,$t0,1
   j out_i
   out_i_end:
    
    li $v0,10
    syscall
   
      
          
                    
                    
                    

    
    
    
    
    
   
    
        
       
    
    
    
    