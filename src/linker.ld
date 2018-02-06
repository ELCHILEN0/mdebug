ENTRY(_start)

MEMORY
{
    RAM     (rwx)   : ORIGIN = 0x80000, LENGTH = 256M
    ROM     (rx)    : ORIGIN = 0x20000000, LENGTH = 512M
}

SECTIONS {
    __text_start = .;
    .init : {
        *(.init)
    } > RAM
    __text_end = .;
}