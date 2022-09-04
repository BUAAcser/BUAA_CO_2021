.text
li $a0 , 0x12345678
li $s0,  0x00001000
sw $a0, 0($s0)
lb $t0, 1($s0)
sb $a0, 2($s0)
lw $t1, 0($s0)
sh $a0, 2($s0)
lw $t2, 0($s0)
 
li $v0, 10
syscall
