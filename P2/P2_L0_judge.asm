.data
    array : .space 100
    
 .text
   li $v0 ,5
   syscall
   move $s0 ,$v0
   li $s1,1 #int flag =1
   
   li $t0 ,0 # int i =0
   for_i:  #for(i=0;i<n;i++)
   beq $t0,$s0,for_i_end
   li $v0 ,12
   syscall
   sb $v0 , array($t0)
   addi $t0 ,$t0,1
   j for_i
   for_i_end:
   li $t0 ,0
   move $t1 ,$s0
   addi $t1,$t1 ,-1
   for_judge: #for(i=0,j=length-1;i<=j;i++,j--)
   bgt $t0,$t1,for_judge_end
   lb $t2 ,array($t0)
   lb $t3 ,array($t1)
   bne $t2,$t3,not_equal
   addi,$t0,$t0,1
   addi,$t1,$t1,-1
   j for_judge
   not_equal:
   li $s1,0
   for_judge_end:
   
   move $a0,$s1
   li $v0 ,1
   syscall
   li $v0 ,10
   syscall
   
   
   
   
   
   
   
      
