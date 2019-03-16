.data
msg1:	.asciiz " "
msg2:	.asciiz "*"
msg3:	.asciiz	"\n"
.text
.globl main 

main:
	li	$v0, 5
	syscall
	move	$a0, $v0  	# n
	move 	$t1, $a0  	# t1=n
	move	$t2, $zero	# i=1 t2=i
floop:	
	addi	$t2,$t2,1	# i++
	slt 	$t0, $t1,$t2	# n< i
	bne	$t0, $zero,exit1
	move	$t3, $zero	#t3=j=0
	
	sub	$t4, $t1 ,$t2	#t4= n-i  
	addi	$t5, $t4, 1	#t5=n-i+1
	add	$t6, $t1,$t2	#t6=n+i
	floop1:
		addi 	$t3,$t3,1	#j++
		slt  	$t0,$t4,$t3	#j>n-i
		bne	$t0,$zero,floop2
		li	$v0, 4		#print space
		la	$a0, msg1
		syscall
		j	floop1
	floop2:	
		addi 	$t5,$t5,1	
		li	$v0,4
		la	$a0,msg2
		syscall
		slt	$t0,$t5,$t6	#j<n+1
		bne	$t0,$zero,floop2
	
	li	$v0,4
	la	$a0,msg3
	syscall 		
	j	floop

exit1: 	move	$t2,$t1		#t2=n
	addi	$t9,$zero,1	#t9=1

sloop:	
	addi 	$t2,$t2,-1	# n-1
	slt	$t0,$t2,$t9	# i<1
	bne	$t0,$zero,exit2
	move	$t3,$zero	#j=0
	sub	$t4, $t1 ,$t2	#t4= n-i  
	addi	$t5, $t4, 1	#t5=n-i+1
	add	$t6, $t1,$t2	#t6=n+i
	
	sloop1:
		addi	$t3,$t3,1
		li	$v0,4
		la	$a0,msg1
		syscall
		slt	$t0,$t3,$t4
		bne	$t0,$zero,sloop1
	sloop2:
		addi	$t5,$t5,1
		li	$v0,4
		la	$a0,msg2
		syscall
		slt	$t0,$t5,$t6
		bne	$t0,$zero,sloop2
		li	$v0,4
		
	la	$a0,msg3
	syscall
		
	j	sloop	
	
					

exit2:	li 	$v0, 10					
  		syscall	

	 
	
