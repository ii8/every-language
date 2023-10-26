.globl _start
.data
msg:
	.ascii "Hello, World!\n"
	len = . - msg
.text
_start:
	mov	$1, %rax
	mov	$1, %rdi
	mov	$msg, %rsi
	mov	$len, %rdx
	syscall
	mov	$60, %rax
	xor	%rdi, %rdi
	syscall
