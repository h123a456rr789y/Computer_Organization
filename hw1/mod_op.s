.data

.text
.globl main



main:
######################### read integer
 	li      $v0, 5          	
  	syscall                 	
  	move    $t1, $v0	#  read $t1=a		

  	li      $v0, 5          	
  	syscall                 	
  	move    $t2, $v0	#  read $t2=b		

  	li      $v0, 5          	
  	syscall                 	
  	move    $t3, $v0	#  read $t3=m

  	addi 	$t9,$zero,2	#t9=2
	addi	$v1,$zero,1	
	jal 	mod

	move $a0, $v1		
	li $v0, 1					# call system call: print integer
	syscall 					# run the syscall

	li $v0, 10					# call system call: exit
	syscall						# run the syscall

mod:
	addi 	$sp,$sp, -12
	sw 		$ra, 0($sp)
	sw		$t2, 4($sp)
	move 	$t8,$zero
	sw		$t8, 8($sp)
	beq		$t2, $zero, L1
	div 	$t2, $t9
	mflo 	$t4			#quotient
	mfhi 	$t5			#reminder
	beq		$t5, $zero,	L2	#if y%2=0
	bne 	$t5, $zero, L3	#if y%2!=0
	jr		$ra

L1:	addi	$sp,$sp,12
	jr 		$ra

L2:	div		$t2, $t9	#if y%2=0
	mflo	$t2			#quotient
	mfhi	$t6			#reminder
	jal 	mod
	jal		mod
	lw 		$ra, 0($sp)
	lw		$t2, 4($sp)
	lw		$t8, 8($sp)
	addi 	$t8,$t8,1
	sw		$t8, 4($sp)
	addi	$sp,$sp,12

	div		$v1,$t3
	mfhi	$v1			#reminder
	
	beq		$t8,$t9,L1
	jr		$ra
	
L3:	div		$t2, $t9	#if y%2!=0
	mflo	$t2			#quotient
	mfhi	$t6			#reminder
	jal 	mod
	jal		mod
	lw 		$ra, 0($sp)
	lw		$t2, 4($sp)
	lw		$t8, 8($sp)
	addi	$t8,$t8,1
	sw		$t8,4($sp)
	addi	$sp,$sp,12

	div		$t1,$t3
	mflo	$s1
	mfhi	$s2		#x%n

	mul 	$v1,$v1,$s2
	div		$v1,$t3
	mfhi	$v1			#reminder

	beq		$t8,$t9,L1
	jr		$ra


