        .global butterfly
        .type   butterfly, %function
butterfly:
        @ Function supports interworking.
        @ args = 0, pretend = 0, frame = 0
        @ frame_needed = 0, uses_anonymous_args = 0
        @ link register save eliminated.
        add     r3, r1, r0
        and     r3, r3, #255
        rsb     r0, r1, r0
        and     r0, r0, #255
        mov     r3, r3, asl #8
        add     r3, r3, r0
        mov     r3, r3, asl #16
        mov     r0, r3, lsr #16
        bx      lr
        .size   butterfly, .-butterfly
        .global __aeabi_i2f
        .global __aeabi_fmul
        .global __aeabi_f2uiz
        .align  2
        .global rotators
        .type   rotators, %function
rotators:
        @ Function supports interworking.
        @ args = 4, pretend = 0, frame = 0
        @ frame_needed = 0, uses_anonymous_args = 0
        stmfd   sp!, {r4, r5, r6, r7, r8, lr}
        mov     r4, r2
        mov     r8, r0
        add     r0, r1, r0
        mov     r7, r3
        mov     r6, r1
        bl      __aeabi_i2f
        mov     r1, r4
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        mov     r5, r0
        mov     r0, r6
        bl      __aeabi_i2f
        mov     r1, r7
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r5, r5, #255
        add     r4, r5, r0
        mov     r0, r8
        bl      __aeabi_i2f
        ldr     r1, [sp, #24]   @ float
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r4, r4, #255
        add     r5, r5, r0
        and     r5, r5, #255
        mov     r4, r4, asl #8
        add     r4, r4, r5
        mov     r4, r4, asl #16
        mov     r0, r4, lsr #16
        ldmfd   sp!, {r4, r5, r6, r7, r8, lr}
        bx      lr
        .size   rotators, .-rotators
        .global __aeabi_i2d
        .global __aeabi_dmul
        .global __aeabi_d2uiz
        .align  2
        .global scaleup
        .type   scaleup, %function
scaleup:
        @ Function supports interworking.
        @ args = 0, pretend = 0, frame = 0
        @ frame_needed = 0, uses_anonymous_args = 0
        stmfd   sp!, {r4, lr}
        bl      __aeabi_i2d
        adr     r3, .L232
        ldmia   r3, {r2-r3}
        bl      __aeabi_dmul
        bl      __aeabi_d2uiz
        and     r0, r0, #255
        ldmfd   sp!, {r4, lr}
        bx      lr
.L233:
        .align  3
.L232:
        .word   769658139
        .word   1073127568
        .size   scaleup, .-scaleup
        .align  2
        .global dct1d
        .type   dct1d, %function
dct1d:
        @ Function supports interworking.
        @ args = 0, pretend = 0, frame = 0
        @ frame_needed = 0, uses_anonymous_args = 0
        stmfd   sp!, {r3, r4, r5, r6, r7, r8, r9, sl, fp, lr}
        ldrb    r4, [r0, #0]    @ zero_extendqisi2
        ldrb    r3, [r0, #1]    @ zero_extendqisi2
        ldrb    r2, [r0, #2]    @ zero_extendqisi2
        ldrb    ip, [r0, #3]    @ zero_extendqisi2
        ldrb    r7, [r0, #4]    @ zero_extendqisi2
        ldrb    r5, [r0, #6]    @ zero_extendqisi2
        ldrb    r6, [r0, #5]    @ zero_extendqisi2
        ldrb    lr, [r0, #7]    @ zero_extendqisi2
        mov     r4, r4, asl #8
        mov     r3, r3, asl #8
        mov     r2, r2, asl #8
        mov     ip, ip, asl #8
        add     lr, lr, r4
        add     r3, r3, r5
        add     r2, r2, r6
        add     ip, ip, r7
        mov     lr, lr, asl #16
        mov     r3, r3, asl #16
        mov     r2, r2, asl #16
        mov     ip, ip, asl #16
        mov     r0, lr, lsr #16
        mov     r4, r3, lsr #16
        mov     r5, r2, lsr #16
        mov     r6, ip, lsr #16
        and     r0, r0, #255
        and     r4, r4, #255
        and     r5, r5, #255
        and     r6, r6, #255
        mov     lr, lr, lsr #24
        mov     r3, r3, lsr #24
        mov     r2, r2, lsr #24
        mov     ip, ip, lsr #24
        add     r7, lr, r0
        add     sl, r3, r4
        add     r9, r2, r5
        add     r8, ip, r6
        rsb     lr, r0, lr
        rsb     r3, r4, r3
        rsb     r2, r5, r2
        rsb     ip, r6, ip
        and     r7, r7, #255
        and     sl, sl, #255
        and     r9, r9, #255
        and     r8, r8, #255
        and     lr, lr, #255
        and     r3, r3, #255
        and     r2, r2, #255
        and     ip, ip, #255
        mov     r7, r7, asl #8
        mov     sl, sl, asl #8
        mov     r9, r9, asl #8
        mov     r8, r8, asl #8
        add     r7, r7, lr
        add     sl, sl, r3
        add     r9, r9, r2
        add     r8, r8, ip
        mov     r7, r7, asl #16
        mov     sl, sl, asl #16
        mov     r9, r9, asl #16
        mov     r8, r8, asl #16
        mov     ip, r8, lsr #24
        mov     r0, r9, lsr #24
        mov     r2, r7, lsr #24
        mov     r3, sl, lsr #24
        add     r4, ip, r2
        add     r6, r0, r3
        rsb     r2, ip, r2
        rsb     r3, r0, r3
        and     r4, r4, #255
        and     r6, r6, #255
        and     r2, r2, #255
        and     r3, r3, #255
        mov     r4, r4, asl #8
        mov     r6, r6, asl #8
        add     r4, r4, r2
        add     r6, r6, r3
        mov     r4, r4, asl #16
        mov     r6, r6, asl #16
        mov     r0, r6, lsr #24
        mov     r2, r4, lsr #24
        add     r3, r0, r2
        and     r3, r3, #255
        rsb     r2, r0, r2
        and     r2, r2, #255
        mov     r3, r3, asl #8
        add     r3, r3, r2
        mov     r4, r4, lsr #16
        mov     r6, r6, lsr #16
        mov     r2, r3, lsr #8
        and     r6, r6, #255
        and     r4, r4, #255
        strb    r2, [r1, #0]
        strb    r3, [r1, #4]
        add     r0, r4, r6
        mov     fp, r1
        bl      __aeabi_i2f
        mvn     r1, #4915200
        sub     r1, r1, #1360
        sub     r1, r1, #-1073741822
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        mov     r5, r0
        mov     r0, r4
        bl      __aeabi_i2f
        mov     r1, #1065353216
        add     r1, r1, #3227648
        add     r1, r1, #288
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r5, r5, #255
        add     r4, r5, r0
        mov     r0, r6
        bl      __aeabi_i2f
        ldr     r1, .L236+8
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r4, r4, #255
        add     r5, r5, r0
        and     r5, r5, #255
        mov     r4, r4, asl #8
        add     r4, r4, r5
        mov     r7, r7, lsr #16
        mov     r8, r8, lsr #16
        mvn     r5, #1664
        mov     r3, r4, lsr #8
        and     r7, r7, #255
        and     r8, r8, #255
        sub     r5, r5, #-1073741811
        strb    r3, [fp, #2]
        sub     r5, r5, #8388608
        strb    r4, [fp, #6]
        add     r0, r8, r7
        bl      __aeabi_i2f
        mov     r1, r5
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        mov     r4, r0
        mov     r0, r7
        bl      __aeabi_i2f
        ldr     r1, .L236+12
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r4, r4, #255
        add     r6, r4, r0
        mov     r0, r8
        bl      __aeabi_i2f
        mov     r1, #1065353216
        add     r1, r1, #84992
        add     r1, r1, #572
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        mov     sl, sl, lsr #16
        mov     r9, r9, lsr #16
        and     r9, r9, #255
        and     sl, sl, #255
        add     r4, r4, r0
        add     r0, sl, r9
        bl      __aeabi_i2f
        mov     r1, r5
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        mov     r5, r0
        mov     r0, sl
        bl      __aeabi_i2f
        ldr     r1, .L236+16
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r6, r6, #255
        and     r4, r4, #255
        and     r5, r5, #255
        mov     r6, r6, asl #8
        add     r6, r6, r4
        add     r4, r5, r0
        mov     r0, r9
        bl      __aeabi_i2f
        mov     r1, #1065353216
        add     r1, r1, #27648
        add     r1, r1, #34
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r4, r4, #255
        add     r5, r5, r0
        and     r5, r5, #255
        mov     r4, r4, asl #8
        add     r4, r4, r5
        mov     r6, r6, asl #16
        mov     r4, r4, asl #16
        mov     r2, r4, lsr #16
        mov     r3, r6, lsr #16
        and     r2, r2, #255
        mov     r4, r4, lsr #24
        mov     r6, r6, lsr #24
        and     r3, r3, #255
        add     r5, r6, r2
        add     r0, r4, r3
        rsb     r6, r2, r6
        rsb     r3, r4, r3
        and     r5, r5, #255
        and     r0, r0, #255
        and     r6, r6, #255
        and     r3, r3, #255
        mov     r5, r5, asl #8
        mov     r0, r0, asl #8
        add     r5, r5, r6
        add     r0, r0, r3
        mov     r5, r5, asl #16
        mov     r0, r0, asl #16
        mov     r1, r0, lsr #24
        mov     r2, r5, lsr #24
        add     r3, r1, r2
        and     r3, r3, #255
        rsb     r2, r1, r2
        and     r2, r2, #255
        mov     r3, r3, asl #8
        add     r3, r3, r2
        adr     r7, .L236
        ldmia   r7, {r6-r7}
        mov     r1, r3, lsr #8
        mov     r0, r0, lsr #16
        strb    r3, [fp, #7]
        and     r0, r0, #255
        strb    r1, [fp, #1]
        bl      __aeabi_i2d
        mov     r2, r6
        mov     r3, r7
        bl      __aeabi_dmul
        bl      __aeabi_d2uiz
        mov     r5, r5, lsr #16
        and     r5, r5, #255
        strb    r0, [fp, #3]
        mov     r0, r5
        bl      __aeabi_i2d
        mov     r2, r6
        mov     r3, r7
        bl      __aeabi_dmul
        bl      __aeabi_d2uiz
        strb    r0, [fp, #5]
        ldmfd   sp!, {r3, r4, r5, r6, r7, r8, r9, sl, fp, lr}
        bx      lr
.L237:
        .align  3
.L236:
        .word   769658139
        .word   1073127568
        .word   1069069369
        .word   1065178733
        .word   1065294496
        .size   dct1d, .-dct1d
        .align  2
        .global dct2d
        .type   dct2d, %function
dct2d:
        @ Function supports interworking.
        @ args = 0, pretend = 0, frame = 72
        @ frame_needed = 0, uses_anonymous_args = 0
        stmfd   sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
        add     r3, r1, #8
        sub     sp, sp, #76
        mov     r5, r1
        mov     r4, r0
        str     r3, [sp, #4]
        add     fp, r5, #16
        bl      dct1d
        add     r0, r4, #8
        ldr     r1, [sp, #4]
        bl      dct1d
        add     r9, r5, #24
        add     r0, r4, #16
        mov     r1, fp
        bl      dct1d
        add     sl, r5, #32
        add     r0, r4, #24
        mov     r1, r9
        bl      dct1d
        add     r8, r5, #40
        add     r0, r4, #32
        mov     r1, sl
        bl      dct1d
        add     r7, r5, #48
        add     r0, r4, #40
        mov     r1, r8
        bl      dct1d
        add     r6, r5, #56
        add     r0, r4, #48
        mov     r1, r7
        bl      dct1d
        add     r0, r4, #56
        mov     r1, r6
        bl      dct1d
        add     r0, sp, #8
        mov     r1, r0
        mov     ip, r5
.L239:
        ldrb    r3, [ip, #0]    @ zero_extendqisi2
        strb    r3, [r1, #0]
        ldrb    r2, [ip, #8]    @ zero_extendqisi2
        strb    r2, [r1, #1]
        ldrb    r3, [ip, #16]   @ zero_extendqisi2
        strb    r3, [r1, #2]
        ldrb    r2, [ip, #24]   @ zero_extendqisi2
        strb    r2, [r1, #3]
        ldrb    r3, [ip, #32]   @ zero_extendqisi2
        strb    r3, [r1, #4]
        ldrb    r2, [ip, #40]   @ zero_extendqisi2
        strb    r2, [r1, #5]
        ldrb    r3, [ip, #48]   @ zero_extendqisi2
        strb    r3, [r1, #6]
        ldrb    r2, [ip, #56]   @ zero_extendqisi2
        add     r3, sp, #72
        strb    r2, [r1, #7]
        add     r1, r1, #8
        cmp     r1, r3
        add     ip, ip, #1
        bne     .L239
        mov     r1, r5
        bl      dct1d
        ldr     r1, [sp, #4]
        add     r0, sp, #16
        bl      dct1d
        mov     r1, fp
        add     r0, sp, #24
        bl      dct1d
        mov     r1, r9
        add     r0, sp, #32
        bl      dct1d
        mov     r1, sl
        add     r0, sp, #40
        bl      dct1d
        mov     r1, r8
        add     r0, sp, #48
        bl      dct1d
        mov     r1, r7
        add     r0, sp, #56
        bl      dct1d
        mov     r1, r6
        add     r0, sp, #64
        bl      dct1d
        add     sp, sp, #76
        ldmfd   sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
        bx      lr
        .size   dct2d, .-dct2d
