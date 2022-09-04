.text
 li $v0 ,5
 syscall
 move $s0 , $v0
 
 
 li $t0 , 4
 div $s0 , $t0
 mfhi $t1
 bne $t1 ,$0 ,no
 
li $t0 , 100
div $s0 , $t0
mfhi $t1 
bne $t1 ,$0 ,yes

li $t0 , 400
div $s0 ,$t0
mfhi $t1
beq $t1 ,$0,yes

no:
li $a0 ,0
li $v0, 1
syscall
li $v0,10
syscall

yes:
li $a0 ,1
li $v0 ,1
syscall
li $v0 ,10
syscall


  
  
  
  
  
  
  
  
  
  
  
  
  
  
