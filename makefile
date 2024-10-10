MAKEFLAGS = -sR
MKDIR = mkdir
RMDIR = rmdir
CP = cp
CD = cd
DD = dd
RM = rm

ASM		= nasm
CC		= gcc
LD		= ld
OBJCOPY	= objcopy

ASMBFLAGS	= -f elf -w-orphan-labels
CFLAGS		= -c -Os -std=c99 -m32 -Wall -Wshadow -W -Wconversion -Wno-sign-conversion  -fno-stack-protector -fomit-frame-pointer -fno-builtin -fno-common  -ffreestanding  -Wno-unused-parameter -Wunused-variable
LDFLAGS		= -s -static -T nekos.lds -n -Map NekOS.map 
OJCYFLAGS	= -S -O binary

NEKOS_OBJS :=
NEKOS_OBJS += entry.o main.o vgastr.o
NEKOS_ELF = NekOS.elf
NEKOS_BIN = NekOS.bin

.PHONY : build clean all link bin

all: clean build link bin

clean:
	$(RM) -f *.o *.bin *.elf

build: $(NEKOS_OBJS)

link: $(NEKOS_ELF)
$(NEKOS_ELF): $(NEKOS_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(NEKOS_OBJS)
bin: $(NEKOS_BIN)
$(NEKOS_BIN): $(NEKOS_ELF)
	$(OBJCOPY) $(OJCYFLAGS) $< $@

%.o : %.asm
	$(ASM) $(ASMBFLAGS) -o $@ $<
%.o : %.c
	$(CC) $(CFLAGS) -o $@ $<