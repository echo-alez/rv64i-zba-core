	.file	"test.c"
	.option nopic
	.attribute arch, "rv64i2p1_zba1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	mem
	.bss
	.align	3
	.type	mem, @object
	.size	mem, 64
mem:
	.zero	64
	.text
	.align	2
	.type	sh1add, @function
sh1add:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	sd	a0,-40(s0)
	sd	a1,-48(s0)
	ld	a5,-40(s0)
	ld	a4,-48(s0)
 #APP
# 7 "test.c" 1
	sh1add a5, a5, a4
# 0 "" 2
 #NO_APP
	sd	a5,-24(s0)
	ld	a5,-24(s0)
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	sh1add, .-sh1add
	.align	2
	.type	sh2add, @function
sh2add:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	sd	a0,-40(s0)
	sd	a1,-48(s0)
	ld	a5,-40(s0)
	ld	a4,-48(s0)
 #APP
# 17 "test.c" 1
	sh2add a5, a5, a4
# 0 "" 2
 #NO_APP
	sd	a5,-24(s0)
	ld	a5,-24(s0)
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	sh2add, .-sh2add
	.align	2
	.type	sh3add, @function
sh3add:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	sd	a0,-40(s0)
	sd	a1,-48(s0)
	ld	a5,-40(s0)
	ld	a4,-48(s0)
 #APP
# 27 "test.c" 1
	sh3add a5, a5, a4
# 0 "" 2
 #NO_APP
	sd	a5,-24(s0)
	ld	a5,-24(s0)
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	sh3add, .-sh3add
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-80
	sd	ra,72(sp)
	sd	s0,64(sp)
	addi	s0,sp,80
	li	a5,10
	sd	a5,-24(s0)
	li	a5,3
	sd	a5,-32(s0)
	ld	a4,-24(s0)
	ld	a5,-32(s0)
	add	a5,a4,a5
	sd	a5,-40(s0)
	ld	a4,-24(s0)
	ld	a5,-32(s0)
	sub	a5,a4,a5
	sd	a5,-48(s0)
	lui	a5,%hi(mem)
	addi	a5,a5,%lo(mem)
	ld	a4,-40(s0)
	sd	a4,0(a5)
	lui	a5,%hi(mem)
	addi	a5,a5,%lo(mem)
	ld	a4,-48(s0)
	sd	a4,8(a5)
	ld	a4,-40(s0)
	ld	a5,-48(s0)
	bleu	a4,a5,.L8
	lui	a5,%hi(mem)
	addi	a5,a5,%lo(mem)
	li	a4,1
	sd	a4,16(a5)
	j	.L9
.L8:
	lui	a5,%hi(mem)
	addi	a5,a5,%lo(mem)
	sd	zero,16(a5)
.L9:
	ld	a1,-32(s0)
	ld	a0,-24(s0)
	call	sh1add
	sd	a0,-56(s0)
	ld	a1,-32(s0)
	ld	a0,-24(s0)
	call	sh2add
	sd	a0,-64(s0)
	ld	a1,-32(s0)
	ld	a0,-24(s0)
	call	sh3add
	sd	a0,-72(s0)
	lui	a5,%hi(mem)
	addi	a5,a5,%lo(mem)
	ld	a4,-56(s0)
	sd	a4,24(a5)
	lui	a5,%hi(mem)
	addi	a5,a5,%lo(mem)
	ld	a4,-64(s0)
	sd	a4,32(a5)
	lui	a5,%hi(mem)
	addi	a5,a5,%lo(mem)
	ld	a4,-72(s0)
	sd	a4,40(a5)
.L10:
	j	.L10
	.size	main, .-main
	.ident	"GCC: (14.2.0+19) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
