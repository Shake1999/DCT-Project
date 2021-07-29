	.arch armv4t
	.eabi_attribute 27, 3
	.fpu neon
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 18, 4
	.file	"roughDCT.c"
	.text
	.align	2
	.global	readJPEG
	.type	readJPEG, %function
readJPEG:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	bx	lr
	.size	readJPEG, .-readJPEG
	.align	2
	.global	butterfly
	.type	butterfly, %function
butterfly:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	fmsr	s15, r2
	fmsr	s14, r1
	fadds	s13, s14, s15
	fsubs	s14, s14, s15
	fmsr	s15, r3
	fmuls	s12, s13, s15
	flds	s15, [sp, #0]
	fmuls	s13, s14, s15
	fsts	s12, [r0, #0]
	fsts	s13, [r0, #4]
	bx	lr
	.size	butterfly, .-butterfly
	.align	2
	.global	reflector
	.type	reflector, %function
reflector:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	fmsr	s15, r1
	fmsr	s14, r2
	fadds	s13, s15, s14
	fsubs	s15, s15, s14
	fsts	s13, [r0, #0]
	fsts	s15, [r0, #4]
	bx	lr
	.size	reflector, .-reflector
	.align	2
	.global	rotators
	.type	rotators, %function
rotators:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	ip, .L9
	fmsr	s10, r2
	add	r2, r3, #1
	add	r2, ip, r2, asl #2
	add	ip, ip, r3, asl #2
	flds	s11, [r2, #0]
	flds	s12, [ip, #0]
	fmsr	s13, r1
	fmuls	s14, s11, s10
	fmuls	s15, s12, s10
	fmacs	s14, s12, s13
	fnmacs	s15, s11, s13
	fsts	s14, [r0, #0]
	fsts	s15, [r0, #4]
	bx	lr
.L10:
	.align	2
.L9:
	.word	.LANCHOR0
	.size	rotators, .-rotators
	.align	2
	.global	scaleup
	.type	scaleup, %function
scaleup:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	fmsr	s15, r0
	fcvtds	d16, s15
	fldd	d17, .L13
	fmuld	d18, d16, d17
	fcvtsd	s15, d18
	fmrs	r0, s15
	bx	lr
.L14:
	.align	3
.L13:
	.word	1708926943
	.word	1073127582
	.size	scaleup, .-scaleup
	.align	2
	.global	dct
	.type	dct, %function
dct:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	fstmfdd	sp!, {d8, d9, d10}
	flds	s5, [r0, #0]
	flds	s19, [r0, #24]
	flds	s17, [r0, #28]
	flds	s4, [r0, #4]
	fsubs	s12, s5, s17
	fsubs	s8, s4, s19
	flds	s2, [r0, #16]
	flds	s18, [r0, #20]
	flds	s16, [r0, #8]
	flds	s1, [r0, #12]
	flds	s10, .L17+8
	flds	s9, .L17+12
	flds	s15, .L17+16
	flds	s14, .L17+20
	fsubs	s11, s16, s18
	fsubs	s13, s1, s2
	fmuls	s7, s12, s10
	fmuls	s6, s12, s15
	fmuls	s3, s8, s14
	fmuls	s0, s8, s9
	flds	s15, .L17+24
	flds	s14, .L17+28
	fmacs	s7, s13, s15
	fmacs	s0, s11, s14
	fmacs	s6, s13, s10
	fmacs	s3, s11, s9
	fadds	s1, s1, s2
	fsubs	s12, s6, s0
	fsubs	s10, s7, s3
	fadds	s5, s5, s17
	fadds	s4, s4, s19
	fsubs	s17, s5, s1
	fcvtds	d5, s10
	fcvtds	d6, s12
	fadds	s16, s16, s18
	flds	s19, .L17+32
	flds	s15, .L17+36
	fldd	d16, .L17
	fsubs	s18, s4, s16
	fmuld	d4, d6, d16
	fmuls	s14, s17, s15
	fmuld	d6, d5, d16
	fadds	s5, s5, s1
	fadds	s4, s4, s16
	fadds	s6, s6, s0
	fadds	s7, s7, s3
	flds	s15, .L17+40
	fmuls	s2, s17, s19
	fsubs	s11, s5, s4
	fmacs	s2, s18, s15
	fmacs	s14, s18, s19
	fadds	s15, s6, s7
	fcvtsd	s12, d6
	fcvtsd	s8, d4
	fadds	s5, s5, s4
	fsubs	s7, s7, s6
	fsts	s15, [r0, #28]
	fsts	s5, [r0, #0]
	fsts	s11, [r0, #4]
	fsts	s14, [r0, #8]
	fsts	s2, [r0, #12]
	fsts	s7, [r0, #16]
	fsts	s12, [r0, #20]
	fsts	s8, [r0, #24]
	fldmfdd	sp!, {d8, d9, d10}
	bx	lr
.L18:
	.align	3
.L17:
	.word	1708926943
	.word	1073127582
	.word	1065352329
	.word	1065353118
	.word	1009283127
	.word	996185731
	.word	-1138200521
	.word	-1151297917
	.word	1068825384
	.word	1022243317
	.word	-1125240331
	.size	dct, .-dct
	.align	2
	.global	createMatrix
	.type	createMatrix, %function
createMatrix:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, r8, lr}
	mov	r5, r0
	mov	r0, r0, asl #2
	mov	r4, r1
	bl	malloc
	cmp	r5, #0
	mov	r7, r0
	ble	.L20
	mov	r6, r4, asl #2
	mov	r4, #0
.L21:
	mov	r0, r6
	bl	malloc
	str	r0, [r7, r4, asl #2]
	add	r4, r4, #1
	cmp	r5, r4
	bgt	.L21
.L20:
	mov	r0, r7
	ldmfd	sp!, {r4, r5, r6, r7, r8, lr}
	bx	lr
	.size	createMatrix, .-createMatrix
	.align	2
	.global	freeMatrix
	.type	freeMatrix, %function
freeMatrix:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, lr}
	mov	r4, r0
	ldr	r0, [r0, #0]
	bl	free
	ldr	r0, [r4, #4]
	bl	free
	ldr	r0, [r4, #8]
	bl	free
	ldr	r0, [r4, #12]
	bl	free
	ldr	r0, [r4, #16]
	bl	free
	ldr	r0, [r4, #20]
	bl	free
	ldr	r0, [r4, #24]
	bl	free
	ldr	r0, [r4, #28]
	bl	free
	mov	r0, r4
	bl	free
	ldmfd	sp!, {r4, lr}
	bx	lr
	.size	freeMatrix, .-freeMatrix
	.align	2
	.global	printMatrix
	.type	printMatrix, %function
printMatrix:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, lr}
	mov	r5, r0
	mov	r4, #0
.L28:
	ldr	r3, [r5, r4]
	flds	s15, [r3, #0]
	fcvtds	d16, s15
	ldr	r0, .L31
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r5, r4]
	flds	s15, [r3, #4]
	fcvtds	d16, s15
	ldr	r0, .L31
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r5, r4]
	flds	s15, [r3, #8]
	fcvtds	d16, s15
	ldr	r0, .L31
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r5, r4]
	flds	s15, [r3, #12]
	fcvtds	d16, s15
	ldr	r0, .L31
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r5, r4]
	flds	s15, [r3, #16]
	fcvtds	d16, s15
	ldr	r0, .L31
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r5, r4]
	flds	s15, [r3, #20]
	fcvtds	d16, s15
	ldr	r0, .L31
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r5, r4]
	flds	s15, [r3, #24]
	fcvtds	d16, s15
	ldr	r0, .L31
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r5, r4]
	flds	s15, [r3, #28]
	fcvtds	d16, s15
	ldr	r0, .L31
	fmrrd	r2, r3, d16
	bl	printf
	add	r4, r4, #4
	mov	r0, #10
	bl	putchar
	cmp	r4, #32
	bne	.L28
	ldmfd	sp!, {r4, r5, r6, lr}
	bx	lr
.L32:
	.align	2
.L31:
	.word	.LC0
	.size	printMatrix, .-printMatrix
	.align	2
	.global	main
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 288
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	fstmfdd	sp!, {d8, d9, d10, d11, d12, d13}
	sub	sp, sp, #292
	add	sl, sp, #32
	ldr	r1, .L55+44
	mov	r2, #256
	mov	r0, sl
	bl	memcpy
	mov	r0, #32
	bl	malloc
	mov	r9, r0
	mov	r0, #32
	bl	malloc
	mov	r3, r9
	str	r0, [r3], #4
	mov	r0, #32
	str	r3, [sp, #8]
	bl	malloc
	str	r0, [r9, #4]
	mov	r0, #32
	bl	malloc
	str	r0, [r9, #8]
	mov	r0, #32
	bl	malloc
	str	r0, [r9, #12]
	mov	r0, #32
	bl	malloc
	str	r0, [r9, #16]
	mov	r0, #32
	bl	malloc
	str	r0, [r9, #20]
	mov	r0, #32
	bl	malloc
	str	r0, [r9, #24]
	mov	r0, #32
	bl	malloc
	add	r3, r9, #8
	str	r3, [sp, #12]
	add	r3, r9, #12
	str	r3, [sp, #16]
	add	r3, r9, #16
	str	r3, [sp, #20]
	add	r3, r9, #20
	str	r3, [sp, #24]
	add	r3, r9, #24
	str	r3, [sp, #28]
	add	r3, r9, #28
	str	r0, [r9, #28]
	str	r3, [sp, #4]
	mov	r4, #0
.L34:
	ldr	r7, [r9, r4, asl #2]
	and	r3, r7, #7
	movs	r2, r3, lsr #2
	ldrne	r3, [sl, r4, asl #5]	@ float
	rsb	r8, r2, #8
	mov	ip, r8, lsr #1
	strne	r3, [r7, #0]	@ float
	moveq	r5, r2
	moveq	r0, #8
	movne	r5, #1
	movne	r0, #7
	movs	lr, ip, asl #1
	movne	r6, r4, asl #3
	addne	r3, r6, r2
	movne	r3, r3, asl #2
	movne	r2, r2, asl #2
	moveq	r6, r4, asl #3
	addne	r3, sl, r3
	addne	r2, r7, r2
	movne	r1, #0
	beq	.L41
.L35:
	add	r1, r1, #1
	vld1.32	{d16}, [r3]!
	cmp	ip, r1
	fstmiad	r2!, {d16}
	bhi	.L35
	cmp	lr, r8
	rsb	r0, lr, r0
	add	r5, r5, lr
	beq	.L36
.L41:
	add	r3, r6, r5
	mov	r3, r3, asl #2
	mov	r2, r5, asl #2
	add	r2, r7, r2
	add	r1, sl, r3
.L37:
	ldr	r3, [r1], #4	@ float
	subs	r0, r0, #1
	str	r3, [r2], #4	@ float
	bne	.L37
.L36:
	add	r4, r4, #1
	cmp	r4, #8
	bne	.L34
	mov	r4, #0
.L42:
	ldr	r3, [r9, r4]
	flds	s15, [r3, #0]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #4]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #8]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #12]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #16]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #20]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #24]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #28]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	add	r4, r4, #4
	mov	r0, #10
	bl	putchar
	cmp	r4, #32
	bne	.L42
	flds	s18, .L55+8
	flds	s22, .L55+12
	flds	s23, .L55+16
	flds	s19, .L55+20
	flds	s24, .L55+24
	flds	s25, .L55+28
	flds	s17, .L55+32
	flds	s20, .L55+36
	flds	s21, .L55+40
	ldr	r0, .L55+52
	bl	puts
	mov	r2, #0
.L43:
	ldr	r3, [r9, r2]
	flds	s0, [r3, #24]
	flds	s6, [r3, #28]
	flds	s9, [r3, #0]
	flds	s8, [r3, #4]
	fsubs	s14, s9, s6
	fsubs	s12, s8, s0
	flds	s7, [r3, #16]
	flds	s1, [r3, #20]
	flds	s2, [r3, #8]
	flds	s4, [r3, #12]
	fsubs	s13, s2, s1
	fsubs	s15, s4, s7
	fmuls	s10, s14, s18
	fmuls	s3, s12, s19
	fmuls	s11, s14, s22
	fmuls	s5, s12, s24
	fmacs	s10, s15, s23
	fmacs	s5, s13, s19
	fmacs	s3, s13, s25
	fmacs	s11, s15, s18
	fsubs	s12, s10, s5
	fadds	s9, s9, s6
	fadds	s4, s4, s7
	fsubs	s14, s11, s3
	fsubs	s16, s9, s4
	fcvtds	d6, s12
	fadds	s2, s2, s1
	fcvtds	d7, s14
	fadds	s8, s8, s0
	fldd	d16, .L55
	fsubs	s0, s8, s2
	fadds	s10, s10, s5
	fmuld	d3, d7, d16
	fadds	s9, s9, s4
	fmuld	d7, d6, d16
	fadds	s8, s8, s2
	fadds	s11, s11, s3
	fmuls	s1, s16, s17
	fmuls	s13, s16, s20
	fsubs	s5, s9, s8
	fadds	s12, s11, s10
	fmacs	s1, s0, s21
	fmacs	s13, s0, s17
	fcvtsd	s14, d7
	fcvtsd	s6, d3
	fadds	s9, s9, s8
	fsubs	s10, s10, s11
	add	r2, r2, #4
	cmp	r2, #32
	fsts	s12, [r3, #28]
	fsts	s9, [r3, #0]
	fsts	s5, [r3, #4]
	fsts	s13, [r3, #8]
	fsts	s1, [r3, #12]
	fsts	s10, [r3, #16]
	fsts	s14, [r3, #20]
	fsts	s6, [r3, #24]
	bne	.L43
	flds	s19, .L55+8
	flds	s23, .L55+12
	flds	s24, .L55+16
	flds	s20, .L55+20
	flds	s25, .L55+24
	flds	s26, .L55+28
	flds	s18, .L55+32
	flds	s21, .L55+36
	flds	s22, .L55+40
	mov	fp, #0
.L44:
	mov	r0, #32
	bl	malloc
	ldr	r7, [r9, #0]
	ldr	r3, [r7, fp]	@ float
	str	r3, [r0, #0]	@ float
	ldr	r3, [sp, #8]
	ldr	r8, [r3, #0]
	ldr	r3, [r8, fp]	@ float
	str	r3, [r0, #4]	@ float
	ldr	r3, [sp, #12]
	ldr	sl, [r3, #0]
	ldr	r3, [sl, fp]	@ float
	str	r3, [r0, #8]	@ float
	ldr	r3, [sp, #16]
	ldr	lr, [r3, #0]
	ldr	r3, [lr, fp]	@ float
	str	r3, [r0, #12]	@ float
	ldr	r3, [sp, #20]
	ldr	r4, [r3, #0]
	ldr	r3, [r4, fp]	@ float
	str	r3, [r0, #16]	@ float
	ldr	r3, [sp, #24]
	ldr	r5, [r3, #0]
	ldr	r3, [r5, fp]	@ float
	str	r3, [r0, #20]	@ float
	ldr	r3, [sp, #28]
	ldr	r6, [r3, #0]
	ldr	r3, [r6, fp]	@ float
	str	r3, [r0, #24]	@ float
	fmsr	s1, r3
	ldr	r3, [sp, #4]
	ldr	ip, [r3, #0]
	add	r3, ip, fp
	flds	s9, [r0, #0]
	flds	s8, [r0, #4]
	flds	s16, [r3, #0]
	fsubs	s12, s8, s1
	flds	s5, [r0, #16]
	flds	s4, [r0, #20]
	fsubs	s13, s9, s16
	flds	s10, [r0, #8]
	flds	s11, [r0, #12]
	fsubs	s14, s10, s4
	fsubs	s15, s11, s5
	fmuls	s7, s13, s19
	fmuls	s2, s12, s20
	fmuls	s6, s13, s23
	fmuls	s3, s12, s25
	fmacs	s7, s15, s24
	fmacs	s3, s14, s20
	fmacs	s2, s14, s26
	fmacs	s6, s15, s19
	fadds	s11, s11, s5
	fadds	s9, s16, s9
	fsubs	s12, s7, s3
	fsubs	s14, s6, s2
	fadds	s10, s10, s4
	fadds	s8, s8, s1
	fsubs	s0, s9, s11
	fcvtds	d6, s12
	fcvtds	d7, s14
	fsubs	s17, s8, s10
	fadds	s9, s9, s11
	fadds	s8, s8, s10
	fmuls	s5, s0, s21
	fmuls	s4, s0, s18
	fadds	s6, s6, s2
	fadds	s7, s7, s3
	fldd	d16, .L55
	fmuld	d5, d7, d16
	fmuld	d7, d6, d16
	fsubs	s1, s9, s8
	fadds	s9, s9, s8
	fmacs	s5, s17, s18
	fmacs	s4, s17, s22
	fsubs	s13, s7, s6
	fcvtsd	s14, d7
	fmrs	r2, s9
	fadds	s6, s6, s7
	fcvtsd	s10, d5
	fsts	s1, [r0, #4]
	fsts	s5, [r0, #8]
	fsts	s4, [r0, #12]
	fsts	s13, [r0, #16]
	fsts	s14, [r0, #20]
	fsts	s10, [r0, #24]
	fsts	s9, [r0, #0]
	fsts	s6, [r0, #28]
	str	r2, [r7, fp]	@ float
	ldr	r3, [r0, #4]	@ float
	str	r3, [r8, fp]	@ float
	ldr	r2, [r0, #8]	@ float
	str	r2, [sl, fp]	@ float
	ldr	r3, [r0, #12]	@ float
	str	r3, [lr, fp]	@ float
	ldr	r2, [r0, #16]	@ float
	str	r2, [r4, fp]	@ float
	ldr	r3, [r0, #20]	@ float
	str	r3, [r5, fp]	@ float
	fmrs	r3, s6
	ldr	r2, [r0, #24]	@ float
	str	r2, [r6, fp]	@ float
	str	r3, [ip, fp]	@ float
	add	fp, fp, #4
	bl	free
	cmp	fp, #32
	bne	.L44
	mov	r4, #0
.L45:
	ldr	r3, [r9, r4]
	flds	s15, [r3, #0]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #4]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #8]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #12]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #16]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #20]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #24]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	ldr	r3, [r9, r4]
	flds	s15, [r3, #28]
	fcvtds	d16, s15
	ldr	r0, .L55+48
	fmrrd	r2, r3, d16
	bl	printf
	add	r4, r4, #4
	mov	r0, #10
	bl	putchar
	cmp	r4, #32
	bne	.L45
	b	.L56
.L57:
	.align	3
.L55:
	.word	1708926943
	.word	1073127582
	.word	1065352329
	.word	1009283127
	.word	-1138200521
	.word	1065353118
	.word	996185731
	.word	-1151297917
	.word	1068825384
	.word	1022243317
	.word	-1125240331
	.word	.LANCHOR0+32
	.word	.LC0
	.word	.LC1
.L56:
	ldr	r0, [r9, #0]
	bl	free
	ldr	r0, [r9, #4]
	bl	free
	ldr	r0, [r9, #8]
	bl	free
	ldr	r0, [r9, #12]
	bl	free
	ldr	r0, [r9, #16]
	bl	free
	ldr	r0, [r9, #20]
	bl	free
	ldr	r0, [r9, #24]
	bl	free
	ldr	r0, [r9, #28]
	bl	free
	mov	r0, r9
	bl	free
	add	sp, sp, #292
	fldmfdd	sp!, {d8, d9, d10, d11, d12, d13}
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	bx	lr
	.size	main, .-main
	.global	constants
	.section	.rodata
	.align	3
.LANCHOR0 = . + 0
	.type	constants, %object
	.size	constants, 32
constants:
	.word	0
	.word	1065353118
	.word	996185731
	.word	1065352329
	.word	1009283127
	.word	0
	.word	1068825384
	.word	1022243317
	.type	C.20.3775, %object
	.size	C.20.3775, 256
C.20.3775:
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.word	1132396544
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"%.3f  \000"
	.space	1
.LC1:
	.ascii	"\012\012 After DCT Calculation \012\000"
	.ident	"GCC: (Sourcery G++ Lite 2008q3-72) 4.3.2"
	.section	.note.GNU-stack,"",%progbits
