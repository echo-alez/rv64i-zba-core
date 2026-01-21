/* Minimal, warning-free linker script for RV64 bare-metal simulation */
/* Separate RX for .text and RW for data/bss */

MEMORY
{
    IMEM (rx) : ORIGIN = 0x00000000, LENGTH = 32K
    DMEM (rw) : ORIGIN = 0x00008000, LENGTH = 32K
}

SECTIONS
{
    /* Program code */
    .text : {
        *(.text*)
    } > IMEM

    /* Read-only data */
    .rodata : {
        *(.rodata*)
    } > DMEM

    /* Initialized data */
    .data : {
        *(.data*)
    } > DMEM

    /* Uninitialized data */
    .bss : {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    } > DMEM

    /* Stack at the end of DMEM */
    . = ORIGIN(DMEM) + LENGTH(DMEM);
    __stack_top = .;
}
