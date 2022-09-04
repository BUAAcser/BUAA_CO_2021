.data
   martix_1 : .space 256
   martix_2 : .space 256
   martix_3 : .space 256
   str_enter: .asciiz "\n"
   str_space: .asciiz " "
   .macro calc_addr(%addr,%i,%j,%line)
        mult %i,%line
        mflo %addr
        add %addr,%addr,%j
        sll %addr,%addr,2
   .end_macro
   
.text
   li $v0,5
   syscall
   move $s0,$v0 # $s0 is the num of line and row
   
   
   li $t0 ,0
   for_i_1:
   beq $t0,$s0,for_i_1_end
   li $t1 ,0
   for_j_1:
   beq $t1,$s0,for_j_1_end
   li $v0,5
   syscall
   calc_addr($t2,$t0,$t1,$s0)
   sw $v0,martix_1($t2)
   addi $t1,$t1,1
   j for_j_1
   for_j_1_end:
   addi $t0,$t0,1
   j for_i_1
   for_i_1_end:
   
   li $t0 ,0
   for_i_2:
   beq $t0,$s0,for_i_2_end
   li $t1 ,0
   for_j_2:
   beq $t1,$s0,for_j_2_end
   li $v0,5
   syscall
   calc_addr($t2,$t0,$t1,$s0)
   sw $v0,martix_2($t2)
   addi $t1,$t1,1
   j for_j_2
   for_j_2_end:
   addi $t0,$t0,1
   j for_i_2
   for_i_2_end:
   
   li $t0 ,0
   for_i_3:
   beq $t0,$s0,for_i_3_end
   li $t1 ,0
   for_j_3:
   beq $t1,$s0,for_j_3_end
   li $s3 0
   li $t5 0
   for_cal:
   beq $t5 ,$s0, cal_end
   calc_addr($t2,$t0,$t5,$s0)
   lw $s1,martix_1($t2)
   calc_addr($t2,$t5,$t1,$s0)
   lw $s2,martix_2($t2)
   mult $s1,$s2
   mflo $s4
   add $s3 ,$s3,$s4
   addi $t5,$t5,1
   j for_cal
   cal_end:
   calc_addr($t2,$t0,$t1,$s0)
   sw $s3,martix_3($t2)
   
   addi $t1,$t1,1
   j for_j_3
   for_j_3_end:
   addi $t0,$t0,1
   j for_i_3
   for_i_3_end:
   
   li $t0 ,0
   out_i:
   beq $t0 ,$s0 , out_i_end
   li $t1 ,0
   out_j:
   beq $t1 , $s0 ,out_j_end
   calc_addr($t2,$t0,$t1,$s0)
   lw $a0,martix_3($t2)
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
   
   
   
   
   
   
   
   
  
   
   
   
   