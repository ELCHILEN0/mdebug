.section .init
.global _start

_start: b _start

/*
_init_core:
    ldr x2, #0x80000
    ldr x3, #0x70000
    ldr x4, #0x60000

    mov sp, x2
    bl main
*/
//    msr sp_el1, x3
//    msr sp_el0, x4

/*
    // Initialize MPID/MPIDR registers
    mrs	x0, midr_el1
	mrs	x1, mpidr_el1
	msr	vpidr_el2, x0
	msr	vmpidr_el2, x1

    // Disable Coprocessor traps
    mov	x0, #0x33ff
	msr	cptr_el2, x0						// Disable coprocessor traps to EL2
	msr	hstr_el2, xzr						// Disable coprocessor traps to EL2
	mov	x0, #3 << 20
	msr	cpacr_el1, x0

    // HCR_EL2 so EL1 is 64 bit...
    mov	x0, #(1 << 31)						// 64bit EL1
	msr	hcr_el2, x0
*/

/*
    mov	x0, #0x3c5							// EL1_SP1 | D | A | I | F
	msr	spsr_el2, x0						// Set spsr_el2 with settings
	adr	x0, exit_el1						// Address to exit EL2
	msr	elr_el2, x0							// Set elevated return register
	eret
*/


//exit_el1:
//    bl main


/*
M[3:0] = 0x0 -> EL0
M[3:0] = 0x5 -> EL1
M[3:0] = 0x9 -> EL2
*/
