; Chris @ Oct. 7 2024
; define magic number
MBT_HDR_FLAGS EQU 0x00010003
MBT_HDR_MAGIC EQU 0x1BADB002
MBT_HDR2_MAGIC EQU 0xe85250d6

global _start   ; export _start symbol
extern main     ; inport main function

[section .start.text]
[bits 32]               ; run in x86 mode
_start:
jmp _entry
; GRUB header
ALIGN 8
mbt_hdr:
    dd MBT_HDR_MAGIC
    dd MBT_HDR_FLAGS
    dd -(MBT_HDR_MAGIC+MBT_HDR_FLAGS)
    dd mbt_hdr
    dd _start
    dd 0
    dd 0
    dd _entry
; GRUB2 header
ALIGN 8
mbt2_hdr:
    dd MBT_HDR2_MAGIC
    dd 0
    dd mbt2_hdr_end - mbt2_hdr
    dd -(MBT_HDR2_MAGIC + 0 + (mbt2_hdr_end - mbt2_hdr))
    dw 2, 0
    dd 24
    dd mbt2_hdr
    dd _start
    dd 0
    dd 0
    dw 3, 0
    dd 12
    dd _entry
    dd 0
    dw 0, 0
    dd 8
mbt2_hdr_end:

ALIGN 8
_entry:
    ; close interupt
    cli
    in al, 0x70
    or al, 0x80
    out 0x70,al
    ; reload GDT
    lgdt [GDT_PTR]
    jmp dword 0x8 :_32bits_mode
_32bits_mode:
    ; init registers for C environment
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor edi, edi
    xor esi, esi
    xor ebp, ebp
    xor esp, esp
    ; init stack
    mov esp, 0x9000
    ; call c function main
    call main

halt_step:
    halt
jmp halt_step

GDT_START:
knull_dsc: dq 0
kcode_dsc: dq 0x00cf9e000000ffff
kdata_dsc: dq 0x00cf92000000ffff
k16cd_dsc: dq 0x00009e000000ffff
k16da_dsc: dq 0x000092000000ffff
GDT_END:
GDT_PTR:
GDTLEN dw GDT_END-GDT_START-1
GDTBASE dd GDT_START