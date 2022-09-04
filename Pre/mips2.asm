.data
 lineA :   .space  3000
 lineB :   .space  3000
 lineC :   .space  3000
 str_enter :    .asciiz "\n"
 str_space :   .asciiz " "

.text
la $t2 ,lineA
la $t3 ,lineB
la $t4 ,lineC
li $v0 ,5
syscall 
move $s0 ,$v0
 
li $v0 ,5
syscall
move $s1 ,$v0

li $t0, 1
for_i :
bgt $t0 ,$s0, for_i_end
li $t1 ,1
for_j:
bgt $t1, $s1 ,for_j_end
li $v0,5
syscall
beq $v0,$0 ,else
sw $t0 ,0($t2)
sw $t1 ,0($t3)
sw $v0 ,0($t4)
addi $t2,$t2,4
addi $t3,$t3,4
addi $t4,$t4,4
else :
addi $t1,$t1,1
j for_j
for_j_end:
addi $t0,$t0,1
j for_i 
for_i_end:


out:
beq $t2,$0,end
addi $t2,$t2,-4
addi $t3,$t3,-4
addi $t4,$t4,-4

lw $a0,0($t2)
li $v0 ,1
syscall

la $a0,str_space
li $v0, 4
syscall

lw $a0,0($t3)
li $v0 ,1
syscall

la $a0,str_space
li $v0, 4
syscall 

lw $a0,0($t4)
li $v0 ,1
syscall

la $a0,str_enter
li $v0, 4
syscall

j out

end:
li $v0 10
syscall


