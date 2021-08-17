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
        adr     r3, .L230
        ldmia   r3, {r2-r3}
        bl      __aeabi_dmul
        bl      __aeabi_d2uiz
        and     r0, r0, #255
        ldmfd   sp!, {r4, lr}
        bx      lr
.L231:
        .align  3
.L230:
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
        ldrb    ip, [r0, #0]    @ zero_extendqisi2
        ldrb    r2, [r0, #7]    @ zero_extendqisi2
        ldrb    r6, [r0, #1]    @ zero_extendqisi2
        ldrb    r3, [r0, #2]    @ zero_extendqisi2
        ldrb    r7, [r0, #3]    @ zero_extendqisi2
        ldrb    lr, [r0, #6]    @ zero_extendqisi2
        ldrb    r5, [r0, #4]    @ zero_extendqisi2
        ldrb    r4, [r0, #5]    @ zero_extendqisi2
        mov     ip, ip, asl #8
        add     r2, r2, ip
        mov     r6, r6, asl #8
        mov     r3, r3, asl #8
        mov     r7, r7, asl #8
        add     r6, r6, lr
        add     r3, r3, r4
        add     r7, r7, r5
        mov     r2, r2, asl #16
        mov     r6, r6, asl #16
        mov     r3, r3, asl #16
        mov     r7, r7, asl #16
        mov     r0, r2, lsr #16
        mov     sl, r1
        mov     r2, r2, lsr #24
        and     r0, r0, #255
        mov     r1, r6, lsr #16
        mov     ip, r3, lsr #16
        mov     lr, r7, lsr #16
#APP
@ 71 "hardwareopt.c" 1
        butterfly       r2, r2, r0

@ 0 "" 2
        mov     r2, r2, asl #16
        mov     r6, r6, lsr #24
        and     r1, r1, #255
        mov     r8, r2, lsr #16
#APP
@ 76 "hardwareopt.c" 1
        butterfly       r6, r6, r1

@ 0 "" 2
        mov     r6, r6, asl #16
        mov     r3, r3, lsr #24
        and     ip, ip, #255
        mov     r9, r6, lsr #16
#APP
@ 81 "hardwareopt.c" 1
        butterfly       r3, r3, ip

@ 0 "" 2
        mov     r3, r3, asl #16
        mov     r7, r7, lsr #24
        and     lr, lr, #255
        mov     fp, r3, lsr #16
#APP
@ 86 "hardwareopt.c" 1
        butterfly       r7, r7, lr

@ 0 "" 2
        mov     r7, r7, asl #16
        mov     r1, r7, lsr #24
        mov     r2, r2, lsr #24
        mov     r7, r7, lsr #16
#APP
@ 97 "hardwareopt.c" 1
        butterfly       r2, r2, r1

@ 0 "" 2
        mov     r2, r2, asl #16
        mov     r6, r6, lsr #24
        mov     r3, r3, lsr #24
        mov     r4, r2, lsr #16
#APP
@ 102 "hardwareopt.c" 1
        butterfly       r6, r6, r3

@ 0 "" 2
        mov     r6, r6, asl #16
        mov     r3, r6, lsr #24
        mov     r2, r2, lsr #24
        mov     r6, r6, lsr #16
#APP
@ 109 "hardwareopt.c" 1
        butterfly       r2, r2, r3

@ 0 "" 2
        mov     r3, r2, lsr #8
        and     r6, r6, #255
        and     r4, r4, #255
        strb    r2, [sl, #4]
        strb    r3, [sl, #0]
        add     r0, r4, r6
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
        ldr     r1, .L234+8
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r4, r4, #255
        add     r5, r5, r0
        and     r5, r5, #255
        mov     r4, r4, asl #8
        add     r4, r4, r5
        mvn     r6, #1664
        mov     r3, r4, lsr #8
        and     r7, r7, #255
        and     r8, r8, #255
        sub     r6, r6, #-1073741811
        strb    r3, [sl, #2]
        sub     r6, r6, #8388608
        strb    r4, [sl, #6]
        add     r0, r8, r7
        bl      __aeabi_i2f
        mov     r1, r6
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        mov     r4, r0
        mov     r0, r8
        bl      __aeabi_i2f
        ldr     r1, .L234+12
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r4, r4, #255
        add     r5, r4, r0
        mov     r0, r7
        bl      __aeabi_i2f
        mov     r1, #1065353216
        add     r1, r1, #84992
        add     r1, r1, #572
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r7, fp, #255
        and     r9, r9, #255
        add     r4, r4, r0
        add     r0, r9, r7
        bl      __aeabi_i2f
        mov     r1, r6
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        mov     r6, r0
        mov     r0, r9
        bl      __aeabi_i2f
        ldr     r1, .L234+16
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r5, r5, #255
        and     r4, r4, #255
        and     r6, r6, #255
        mov     r5, r5, asl #8
        add     r5, r5, r4
        add     r4, r6, r0
        mov     r0, r7
        bl      __aeabi_i2f
        mov     r1, #1065353216
        add     r1, r1, #27648
        add     r1, r1, #34
        bl      __aeabi_fmul
        bl      __aeabi_f2uiz
        and     r4, r4, #255
        add     r6, r6, r0
        and     r6, r6, #255
        mov     r4, r4, asl #8
        add     r4, r4, r6
        mov     r4, r4, asl #16
        mov     r5, r5, asl #16
        mov     r2, r4, lsr #16
        mov     r3, r5, lsr #24
        and     r2, r2, #255
        mov     r5, r5, lsr #16
#APP
@ 125 "hardwareopt.c" 1
        butterfly       r3, r3, r2

@ 0 "" 2
        mov     r3, r3, asl #16
        mov     r4, r4, lsr #24
        and     r5, r5, #255
        mov     r8, r3, lsr #16
#APP
@ 130 "hardwareopt.c" 1
        butterfly       r5, r5, r4

@ 0 "" 2
        mov     r5, r5, asl #16
        mov     r2, r5, lsr #24
        mov     r3, r3, lsr #24
        mov     r5, r5, lsr #16
#APP
@ 137 "hardwareopt.c" 1
        butterfly       r3, r3, r2

@ 0 "" 2
        adr     r7, .L234
        ldmia   r7, {r6-r7}
        mov     r1, r3, lsr #8
        and     r5, r5, #255
        strb    r3, [sl, #7]
        strb    r1, [sl, #1]
        mov     r0, r5
        bl      __aeabi_i2d
        mov     r2, r6
        mov     r3, r7
        bl      __aeabi_dmul
        bl      __aeabi_d2uiz
        and     r8, r8, #255
        strb    r0, [sl, #3]
        mov     r0, r8
        bl      __aeabi_i2d
        mov     r2, r6
        mov     r3, r7
        bl      __aeabi_dmul
        bl      __aeabi_d2uiz
        strb    r0, [sl, #5]
        ldmfd   sp!, {r3, r4, r5, r6, r7, r8, r9, sl, fp, lr}
        bx      lr
.L235:
        .align  3
.L234:
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
.L237:
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
        bne     .L237
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
