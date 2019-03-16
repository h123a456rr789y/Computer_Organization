.data
msg1:	.asciiz "Input: \n"
msg2:	.asciiz "ERROR"
msg3:	.asciiz	"Output: \n"
msg4:	.asciiz	"A"
msg5:	.asciiz	"B"
msg6:	.asciiz "ERROR!"

.text
.globl	main
main:
	li      $v0, 4		#print input
	la      $a0, msg1			
	syscall

	
########################################################## 	store a[]	
	li	$v0,5		#read input
	syscall	
	move	$s1,$v0
	
	move 	$t1,$zero	#initialize i
	addi	$t2,$zero,4	#t2=4
	addi 	$t3,$zero,10	#t3=10
	
	addi	$sp,$sp,-16
	
	div	$s1,$t3
	mflo	$s1	#qeotient
	mfhi	$t9	#remainder
	sw 	$t9, 0($sp)
	
	div	$s1,$t3
	mflo	$s1	#qeotient
	mfhi	$t9	#remainder
	sw 	$t9, 4($sp)
	
	div	$s1,$t3
	mflo	$s1	#qeotient
	mfhi	$t9	#remainder
	sw 	$t9, 8($sp)
	
	div	$s1,$t3
	mflo	$s1	#qeotient
	mfhi	$t9	#remainder
	sw 	$t9, 12($sp)
	
########################################################## 	check a[]	

	lw 	$t0, 0($sp)
	lw 	$t4, 4($sp)
	beq	$t0,$t4 error

	lw 	$t0, 0($sp)
	lw 	$t4, 8($sp)
	beq	$t0,$t4 error

	lw $t0, 0($sp)
	lw $t4, 12($sp)
	beq	$t0,$t4 error

	lw $t0, 4($sp)
	lw $t4, 8($sp)
	beq	$t0,$t4 error

	lw $t0, 4($sp)
	lw $t4, 12($sp)
	beq	$t0,$t4 error

	lw $t0, 8($sp)
	lw $t4, 12($sp)
	beq	$t0,$t4 error
	

########################################################## 	store b[]	
 	li      $v0, 5		#read input
  	syscall                 	
  	move    $s1, $v0
  	

	move 	$t1,$zero	#initialize i
	addi	$t2,$zero,4	#t2=4
	addi 	$t3,$zero,10	#t3=10
	
	move 	$t5, $sp
	addi 	$t5, $t5,-16

	div	$s1,$t3
	mflo	$s1	#qeotient
	mfhi	$t9	#remainder
	sw 	$t9, 0($t5)
	

	div	$s1,$t3
	mflo	$s1	#qeotient
	mfhi	$t9	#remainder
	sw 	$t9, 4($t5)
	
	div	$s1,$t3
	mflo	$s1	#qeotient
	mfhi	$t9	#remainder
	sw 	$t9, 8($t5)
	
	div	$s1,$t3
	mflo	$s1	#qeotient
	mfhi	$t9	#remainder
	sw 	$t9, 12($t5)
	
########################################################## 	check b[]	

	lw 	$t0, 0($t5)
	lw 	$t4, 4($t5)
	beq	$t0,$t4 error1

	lw 	$t0, 0($t5)
	lw 	$t4, 8($t5)
	beq	$t0,$t4 error1

	lw $t0, 0($t5)
	lw $t4, 12($t5)
	beq	$t0,$t4 error1

	lw $t0, 4($t5)
	lw $t4, 8($t5)
	beq	$t0,$t4 error1

	lw $t0, 4($t5)
	lw $t4, 12($t5)
	beq	$t0,$t4 error1

	lw $t0, 8($t5)
	lw $t4, 12($t5)
	beq	$t0,$t4 error1
#############################################################################
	move	$s2,$zero	#A=0
	move 	$s3,$zero	#B=0
	move 	$t1,$zero		#initialize i
	addi	$t2,$zero,4		#t2=4
	addi 	$t3,$zero,10	#t3=10
	move 	$t8,$zero	#j=0
	move 	$s4,$t5		#move t5 to s4
count:
	beq		$t1,$t2,exit3
	lw		$t0,0($sp)	#ai
	lw		$t4,0($t5)	#bi
	bne		$t0,$t4,L3
	addi		$s2,$s2,1	#A++
	L3:
	move 	$t8,$zero	#j=0
	loop:	
		beq		$t8,$t2,L1
		lw		$t0,0($sp)	#ai
		lw		$t4,0($s4)	#bj
		seq		$s7,$t0,$t4	#a[i ]== b[j] 	$s7=1
		sne		$s6,$t1,$t8	#i!=j
		and		$s5,$s6,$s7	
		beq		$s5,$zero,L2
		addi		$s3,$s3,1	#B++
		L2:
		addi	$t8,$t8,1
		addi	$s4,$s4,4
		j loop
	L1:
	addi	$s4,$s4,-16
	addi	$t1,$t1,1	#i++
	addi	$sp,$sp,4
	addi	$t5,$t5,4
	j count

exit3:
######################################################print answer	
  	li	$v0,4		
  	la	$a0,msg3
  	syscall
  	
  	move	$a0,$s2
  	li	$v0,1
  	syscall
  	
  	li	$v0,4
  	la	$a0,msg4
  	syscall
  	
	move	$a0,$s3
  	li	$v0,1
  	syscall
  	
  	li	$v0,4
  	la	$a0,msg5
  	syscall


	li	$v0,10
	syscall

error:	
 	li      $v0, 4				
	la      $a0, msg2			
	syscall
	li	$v0,10
	syscall
error1:
 	li      $v0, 4				
	la      $a0, msg6			
	syscall	
	li	$v0,10
	syscall
exit666:
