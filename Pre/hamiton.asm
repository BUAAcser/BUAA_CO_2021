.data
matrix : .space  256
visited: .space  40
.macro getindex ( %ans,%i,%j,%k)
   addi %ans,%i,-1
   mult %ans,%j
   mflo %ans
   add %ans,%ans,%k
   sll %ans,%ans,2       
.end_macro

.text
   li $t4,0      #  $s4作为flag来判断是否存在哈密顿会理
   
   li $v0,5
   syscall
   move $s0,$v0
   li $v0,5
   syscall
   move $s1,$v0

   li $t0,1
for:
   bgt $t0,$s1,for_end
   li $v0,5
   syscall
   move $t1, $v0
   li $v0,5
   syscall
   move $t2, $v0

   getindex($t3,$t1,$s0,$t2) 
   li $a0,1
   sw $a0,matrix($t3)
   
   getindex($t3,$t2,$s0,$t1) 
   li $a0,1
   sw $a0,matrix($t3)
    
      #对邻接矩阵赋初值1，G[i][j]=G[j][i]=1

   addi $t0,$t0,1
   j for

for_end:

   li $s2,1
   sll $s2,$s2,2
   li $s3 ,1
   sw $s3,visited($s2)
   

   li $a0,1
   li $a1,1
   jal eDFS
   
   move $a0 ,$t4
   li $v0 ,1
   syscall
   li $v0,10
   syscall
   
   
eDFS:
   bne $a1,$s0,work 
   li $t5,1
   getindex ($t6,$a0,$s0,$t5)
   lw $t5,matrix($t6)
   li $t6,1
   bne $t5,$t6,else
   li $t4,1
else:
   jr $31
   
   
work:
   move $t1,$a0
   move $t2,$a1
   li $t0,1 
for_j:                                 
   bgt $t0,$s0,for_j_end
   move $s2,$t0
   sll $s2,$s2,2
   lw $t3 ,visited($s2)
   bne $t3,$0,end
   getindex ($t6,$t1,$s0,$t0)
   lw $t3,matrix($t6)
   beq $t3,$0,end    #判断!visited[j]&&G[v][j]==1
   
   move $s2,$t0
   sll $s2,$s2,2
   li $t3,1
   sw  $t3 ,visited($s2)   #visited[j]=1
   
   sw  $ra ,0($sp)
   subi $sp,$sp,4
   sw $t1,0($sp)
   subi $sp,$sp 4
   sw $t2,0($sp)
   subi $sp ,$sp,4
   sw $t0,0($sp)
   subi $sp,$sp,4
   
   addi $t2,$t2,1
   move $a1,$t2
   move $a0,$t0
   jal eDFS
   
   addi $sp,$sp,4
   lw $t0,0($sp)
   addi $sp,$sp,4
   lw $t2,0($sp)
   addi $sp,$sp,4
   lw $t1,0($sp)
   addi $sp,$sp,4
   lw,$ra,0($sp)
   
   move $s2,$t0
   sll $s2,$s2,2
   li $t3,0
   sw  $t3 ,visited($s2)   #visited[j]=0
   
end:
   addi $t0,$t0,1
   j for_j
for_j_end:
   jr $31

 
   