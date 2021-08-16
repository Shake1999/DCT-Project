.global butterfly
        .type   butterfly, %function
butterfly:
        @ Function supports interworking.
        @ args = 0, pretend = 0, frame = 32
        @ frame_needed = 1, uses_anonymous_args = 0
        stmfd   sp!, {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #32
        str     r0, [fp, #-24]  @ float
        str     r1, [fp, #-28]  @ float
        ldr     r3, [fp, #-24]  @ float
        ldr     r2, [fp, #-28]  @ float
        mov     r0, r3
        mov     r1, r2
        bl      __aeabi_fadd
        mov     r3, r0
        str     r3, [fp, #-12]  @ float
        ldr     r3, [fp, #-24]  @ float
        ldr     r2, [fp, #-28]  @ float
        mov     r0, r3
        mov     r1, r2
        bl      __aeabi_fsub
        mov     r3, r0
        str     r3, [fp, #-8]   @ float
        ldr     r0, [fp, #-12]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [fp, #-16]
        ldr     r0, [fp, #-8]   @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [fp, #-15]
        ldrh    r3, [fp, #-16]  @ movhi
        strh    r3, [fp, #-14]  @ movhi
        mov     r1, #0
        str     r1, [fp, #-32]
        ldrb    r3, [fp, #-14]  @ zero_extendqisi2
        and     r2, r3, #255
        ldr     r1, [fp, #-32]
        bic     r3, r1, #255
        orr     r3, r2, r3
        str     r3, [fp, #-32]
        ldrb    r3, [fp, #-13]  @ zero_extendqisi2
        and     r3, r3, #255
        ldr     r1, [fp, #-32]
        bic     r2, r1, #65280
        mov     r3, r3, asl #8
        orr     r2, r3, r2
        str     r2, [fp, #-32]
        ldr     r3, [fp, #-32]
        mov     r0, r3  @ movhi
        sub     sp, fp, #4
        ldmfd   sp!, {fp, lr}
        bx      lr
        .size   butterfly, .-butterfly
        .align  2
        .global rotators
        .type   rotators, %function
rotators:
        @ Function supports interworking.
        @ args = 0, pretend = 0, frame = 32
        @ frame_needed = 1, uses_anonymous_args = 0
        stmfd   sp!, {r4, r5, r6, fp, lr}
        add     fp, sp, #16
        sub     sp, sp, #36
        str     r0, [fp, #-40]  @ float
        str     r1, [fp, #-44]  @ float
        str     r2, [fp, #-48]
        ldr     r2, [fp, #-48]
        ldr     r3, .L2293
        ldr     r5, [r3, r2, asl #2]    @ float
        ldr     r3, [fp, #-48]
        add     r2, r3, #1
        ldr     r3, .L2293
        ldr     r6, [r3, r2, asl #2]    @ float
        ldr     r3, [fp, #-40]  @ float
        mov     r0, r5
        mov     r1, r3
        bl      __aeabi_fmul
        mov     r3, r0
        mov     r4, r3
        ldr     r3, [fp, #-44]  @ float
        mov     r0, r6
        mov     r1, r3
        bl      __aeabi_fmul
        mov     r3, r0
        mov     r0, r4
        mov     r1, r3
        bl      __aeabi_fadd
        mov     r3, r0
        str     r3, [fp, #-28]  @ float
        eor     r3, r6, #-2147483648
        ldr     r2, [fp, #-40]  @ float
        mov     r0, r3
        mov     r1, r2
        bl      __aeabi_fmul
        mov     r3, r0
        mov     r4, r3
        ldr     r3, [fp, #-44]  @ float
        mov     r0, r5
        mov     r1, r3
        bl      __aeabi_fmul
        mov     r3, r0
        mov     r0, r4
        mov     r1, r3
        bl      __aeabi_fadd
        mov     r3, r0
        str     r3, [fp, #-24]  @ float
        ldr     r0, [fp, #-28]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [fp, #-32]
        ldr     r0, [fp, #-24]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [fp, #-31]
        ldrh    r3, [fp, #-32]  @ movhi
        strh    r3, [fp, #-30]  @ movhi
        mov     r1, #0
        str     r1, [fp, #-52]
        ldrb    r3, [fp, #-30]  @ zero_extendqisi2
        and     r2, r3, #255
        ldr     r1, [fp, #-52]
        bic     r3, r1, #255
        orr     r3, r2, r3
        str     r3, [fp, #-52]
        ldrb    r3, [fp, #-29]  @ zero_extendqisi2
        and     r3, r3, #255
        ldr     r1, [fp, #-52]
        bic     r2, r1, #65280
        mov     r3, r3, asl #8
        orr     r2, r3, r2
        str     r2, [fp, #-52]
        ldr     r3, [fp, #-52]
        mov     r0, r3  @ movhi
        sub     sp, fp, #16
        ldmfd   sp!, {r4, r5, r6, fp, lr}
        bx      lr
.L2294:
        .align  2
.L2293:
        .word   constants
        .size   rotators, .-rotators
        .align  2
        .global scaleup
        .type   scaleup, %function
scaleup:
        @ Function supports interworking.
        @ args = 0, pretend = 0, frame = 16
        @ frame_needed = 1, uses_anonymous_args = 0
        stmfd   sp!, {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #16
        str     r0, [fp, #-16]  @ float
        ldr     r3, .L2297      @ float
        str     r3, [fp, #-8]   @ float
        ldr     r3, [fp, #-8]   @ float
        ldr     r2, [fp, #-16]  @ float
        mov     r0, r3
        mov     r1, r2
        bl      __aeabi_fmul
        mov     r3, r0
        mov     r0, r3
        sub     sp, fp, #4
        ldmfd   sp!, {fp, lr}
        bx      lr
.L2298:
        .align  2
.L2297:
        .word   1068827777
        .size   scaleup, .-scaleup
        .global __aeabi_ui2f
        .align  2
        .global dct1d
        .type   dct1d, %function
dct1d:
        @ Function supports interworking.
        @ args = 0, pretend = 0, frame = 56
        @ frame_needed = 1, uses_anonymous_args = 0
        stmfd   sp!, {r4, fp, lr}
        add     fp, sp, #8
        sub     sp, sp, #60
        str     r0, [fp, #-56]
        str     r1, [fp, #-60]
        ldr     r3, [fp, #-56]
        ldrb    r3, [r3, #0]    @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-44]  @ float
        ldr     r3, [fp, #-56]
        add     r3, r3, #1
        ldrb    r3, [r3, #0]    @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-40]  @ float
        ldr     r3, [fp, #-56]
        add     r3, r3, #2
        ldrb    r3, [r3, #0]    @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-36]  @ float
        ldr     r3, [fp, #-56]
        add     r3, r3, #3
        ldrb    r3, [r3, #0]    @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-32]  @ float
        ldr     r3, [fp, #-56]
        add     r3, r3, #4
        ldrb    r3, [r3, #0]    @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-28]  @ float
        ldr     r3, [fp, #-56]
        add     r3, r3, #5
        ldrb    r3, [r3, #0]    @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-24]  @ float
        ldr     r3, [fp, #-56]
        add     r3, r3, #6
        ldrb    r3, [r3, #0]    @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-20]  @ float
        ldr     r3, [fp, #-56]
        add     r3, r3, #7
        ldrb    r3, [r3, #0]    @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-16]  @ float
        ldr     r0, [fp, #-44]  @ float
        ldr     r1, [fp, #-16]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-44]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-16]  @ float
        ldr     r0, [fp, #-40]  @ float
        ldr     r1, [fp, #-20]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-40]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-20]  @ float
        ldr     r0, [fp, #-36]  @ float
        ldr     r1, [fp, #-24]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-36]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-24]  @ float
        ldr     r0, [fp, #-32]  @ float
        ldr     r1, [fp, #-28]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-32]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-28]  @ float
        ldr     r0, [fp, #-44]  @ float
        ldr     r1, [fp, #-32]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-44]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-32]  @ float
        ldr     r0, [fp, #-40]  @ float
        ldr     r1, [fp, #-36]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-40]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-36]  @ float
        ldr     r0, [fp, #-28]  @ float
        ldr     r1, [fp, #-16]  @ float
        mov     r2, #3
        bl      rotators
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-28]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-16]  @ float
        ldr     r0, [fp, #-24]  @ float
        ldr     r1, [fp, #-20]  @ float
        mov     r2, #1
        bl      rotators
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-24]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-20]  @ float
        ldr     r0, [fp, #-44]  @ float
        ldr     r1, [fp, #-40]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-44]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-40]  @ float
        ldr     r0, [fp, #-36]  @ float
        ldr     r1, [fp, #-32]  @ float
        mov     r2, #6
        bl      rotators
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-36]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-32]  @ float
        ldr     r0, [fp, #-28]  @ float
        ldr     r1, [fp, #-20]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-28]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-20]  @ float
        ldr     r0, [fp, #-16]  @ float
        ldr     r1, [fp, #-24]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-16]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-24]  @ float
        ldr     r0, [fp, #-16]  @ float
        ldr     r1, [fp, #-28]  @ float
        bl      butterfly
        mov     r3, r0, asl #16
        mov     r2, r3, asr #16
        mov     r3, r2
        strb    r3, [fp, #-68]
        mov     r3, r2, lsr #8
        strb    r3, [fp, #-67]
        ldrh    r3, [fp, #-68]  @ movhi
        strh    r3, [fp, #-46]  @ movhi
        ldrb    r3, [fp, #-46]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-16]  @ float
        ldrb    r3, [fp, #-45]  @ zero_extendqisi2
        mov     r0, r3
        bl      __aeabi_ui2f
        mov     r3, r0
        str     r3, [fp, #-28]  @ float
        ldr     r0, [fp, #-24]  @ float
        bl      scaleup
        mov     r3, r0
        str     r3, [fp, #-24]  @ float
        ldr     r0, [fp, #-20]  @ float
        bl      scaleup
        mov     r3, r0
        str     r3, [fp, #-20]  @ float
        ldr     r0, [fp, #-44]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        ldr     r2, [fp, #-60]
        strb    r3, [r2, #0]
        ldr     r3, [fp, #-60]
        add     r4, r3, #1
        ldr     r0, [fp, #-40]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [r4, #0]
        ldr     r3, [fp, #-60]
        add     r4, r3, #2
        ldr     r0, [fp, #-36]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [r4, #0]
        ldr     r3, [fp, #-60]
        add     r4, r3, #3
        ldr     r0, [fp, #-32]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [r4, #0]
        ldr     r3, [fp, #-60]
        add     r4, r3, #4
        ldr     r0, [fp, #-28]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [r4, #0]
        ldr     r3, [fp, #-60]
        add     r4, r3, #5
        ldr     r0, [fp, #-24]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [r4, #0]
        ldr     r3, [fp, #-60]
        add     r4, r3, #6
        ldr     r0, [fp, #-20]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [r4, #0]
        ldr     r3, [fp, #-60]
        add     r4, r3, #7
        ldr     r0, [fp, #-16]  @ float
        bl      __aeabi_f2uiz
        mov     r3, r0
        and     r3, r3, #255
        strb    r3, [r4, #0]
        sub     sp, fp, #8
        ldmfd   sp!, {r4, fp, lr}
        bx      lr
        .size   dct1d, .-dct1d
        .align  2
        .global dct2d
        .type   dct2d, %function
dct2d:
        @ Function supports interworking.
        @ args = 0, pretend = 0, frame = 80
        @ frame_needed = 1, uses_anonymous_args = 0
        stmfd   sp!, {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #80
        str     r0, [fp, #-80]
        str     r1, [fp, #-84]
        mov     r3, #0
        str     r3, [fp, #-8]
        b       .L2302
.L2303:
        ldr     r2, [fp, #-80]
        ldr     r3, [fp, #-8]
        mov     r3, r3, asl #3
        add     r1, r2, r3
        ldr     r2, [fp, #-84]
        ldr     r3, [fp, #-8]
        mov     r3, r3, asl #3
        add     r3, r2, r3
        mov     r0, r1
        mov     r1, r3
        bl      dct1d
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        str     r3, [fp, #-8]
.L2302:
        ldr     r3, [fp, #-8]
        cmp     r3, #7
        ble     .L2303
        sub     r3, fp, #72
        ldr     r0, [fp, #-84]
        mov     r1, r3
        bl      transpose
        mov     r3, #0
        str     r3, [fp, #-8]
        b       .L2304
.L2305:
        sub     r2, fp, #72
        ldr     r3, [fp, #-8]
        mov     r3, r3, asl #3
        add     r1, r2, r3
        ldr     r2, [fp, #-84]
        ldr     r3, [fp, #-8]
        mov     r3, r3, asl #3
        add     r3, r2, r3
        mov     r0, r1
        mov     r1, r3
        bl      dct1d
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        str     r3, [fp, #-8]
.L2304:
        ldr     r3, [fp, #-8]
        cmp     r3, #7
        ble     .L2305
        sub     sp, fp, #4
        ldmfd   sp!, {fp, lr}
        bx      lr
        .size   dct2d, .-dct2d
        .section        .rodata