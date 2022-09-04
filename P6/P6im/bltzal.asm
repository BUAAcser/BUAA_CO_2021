.text
ori $s1, $s1, 4
ori $t1,$t1, 1
ori $t5, $t5, 2
subu $t2, $t1, $t5
bltzal $t1 ,jump1
nop
ori $s1, $s1, 20
ori $s2, $s2, 30
bltzal $t2, jump2
nop
jump1:
ori $t3, $t3, 20
ori $t4, $t4, 30
jump2:
addu $30, $31, $s1   ###验证当转跳条件满足时，31号寄存器的值是否会转发出去
ori $t5, $t5, 20
ori $t6, $t6, 30
nop
subu $31, $31, $31
nop    ## 测试lw与bltzal的暂停
sw $t2, 3000($0)
ori $s1, $s1, 6
lw $s1, 3000($0)
bltzal $s1, jump3
nop
lui $2,13827
ori $2,$2,52622
lui $3,35270
ori $3,$3,18911
lui $4,15539
ori $4,$4,62433
lui $5,13788
ori $5,$5,33060
jump3:
subu $29, $31, $s1
ori $2, $2, 123
ori $3, $3, 456
ori $4, $4, 769
ori $5, $5, 0x1234
nop

subu $31, $31, $31    ###验证当转跳条件不满足时，31号寄存器的值是否会转发出去
ori $t3, $t3, 3   ##验证addu的转发
lw $t2, 3000($0)
addu $t2,$t2, $t3
bltzal $t2, jump4
nop
addu $28, $28, $31
ori $20,$20,61396
lui $21,39951
ori $21,$21,6589
lui $22,2051
ori $22,$22,1147
lui $23,4598
ori $23,$23,23408
lui $24,14654
ori $24,$24,43611
jump4:
lui $25,58469
ori $25,$25,42200
lui $26,49917
ori $26,$26,26643
lui $27,40656
ori $27,$27,29981


subu $s1, $s1, $s1
subu $31, $31, $31
ori $s1, $s1, 6
bltzal $s1, jump5
addu $29, $31, $31
sw $15, 2932($0)
sw $27, 2936($0)
sw $16, 2940($0)
sw $29, 2944($0)
jump5:
subu $t2, $t2, $t2
ori $t2, $t2, 8
subu $s1, $s1, $t2
lui $t1, 100
subu $t3, $t3, $t3
ori $t3, $t3, 48
bltzal $s1, jump6
lui $7, 7383
addu $11, $7, $7
ori $4, $11, 14841
ori $29, $0, 31608
jump6:
addu $28, $31, $t3
ori $27, $0, 0
ori $27, $0, 17444
addu $8, $10, $13
ori $8, $0, 28189
lw $2, -25821($8)
jr $28
sw $17, 2728($0)
sw $18, 2732($0)
sw $3, 2736($0)
sw $28, 2740($0)
sw $20, 2744($0)
sw $6, 2748($0)
sw $25, 2752($0)
sw $10, 2756($0)
sw $21, 2760($0)
sw $8, 2764($0)
sw $27, 2768($0)
sw $28, 2772($0)

subu $t1, $t1, $t1
subu $t2, $t2, $t2
ori $t2, $t2, 6
subu $t2, $t1,$t6
sw $t2, 3000($0)
lw $t1, 3000($0)
addu $t6, $t1, $t2
bltzal $t1, jump7
addu $11, $28, $9
addu $10, $11, $11
addu $14, $8, $9
jump7:
lui $16, 18671
ori $16, $0, 16123
sw $26, -14815($16)
ori $16, $0, 9346
sw $26, -5470($16)
ori $17, $0, 23094
sw $30, -21102($17)
ori $4, $0, 939





