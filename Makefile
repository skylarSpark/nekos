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
MAKE	= make
OBJCOPY	= objcopy
QEMU	= qemu-system-x86_64

LKIMG = ./lmoskrlimg -m k
X86BARD = -f ./Makefile.x86

VVMRLMOSFLGS = -C $(BUILD_PATH) -f vbox.mkf

LOGOFILE = logo.bmp
FONTFILE = font.fnt
BUILD_PATH = ./build
EXKNL_PATH = ./exckrnl
DSTPATH = ../exckrnl
RELEDSTPATH = ../release
INITLDR_BUILD_PATH =./initldr/build/
INITLDR_PATH =./initldr/
CPLILDR_PATH =./release/
INSTALL_PATH =/boot/
INSTALLSRCFILE_PATH =./release/Cosmos.eki
SRCFILE = $(BOOTEXCIMG) $(KRNLEXCIMG) $(LDEREXCIMG) $(SHELEXCIMG)
RSRCFILE = $(BOOTEXCIMG) $(KRNLEXCIMG) $(LDEREXCIMG) $(SHELEXCIMG)

IMGSECTNR = 204800
NEKOS_BIN = Nekos.bin
NEKOS_IMG = hd.img

INITLDRIMH = initldrimh.bin
INITLDRKRL = initldrkrl.bin
INITLDRSVE = initldrsve.bin

VMFLAGES = -smp 4 -hda $(NEKOS_IMG) -m 256 -enable-kvm

CPLILDRSRC= $(INITLDR_BUILD_PATH)$(INITLDRSVE) $(INITLDR_BUILD_PATH)$(INITLDRKRL) $(INITLDR_BUILD_PATH)$(INITLDRIMH)

.PHONY : build print clean all link bin cplmildr cpkrnl cprelease release createimg

all:
	$(MAKE) $(X86BARD)
	@echo 'Congratulations, the system is successfully compiled and built! :P'

clean:
	$(CD) $(INITLDR_PATH); $(MAKE) clean
	$(CD) $(BUILD_PATH); $(RM) -f *.o *.bin *.i *.krnl *.s *.map *.lib *.btoj *.vdi *.elf *vmdk *.lds *.mk *.mki krnlobjs.mh
	$(CD) $(EXKNL_PATH); $(RM) -f *.o *.bin *.i *.krnl *.s *.map *.lib *.btoj *.vdi *.elf *vmdk *.lds *.mk *.mki krnlobjs.mh
	$(CD) $(CPLILDR_PATH); $(RM) -f *.o *.bin *.i *.krnl *.s *.eki *.map *.lib *.btoj *.elf *.vdi *vmdk *.lds *.mk *.mki krnlobjs.mh
	@echo 'Cleaned up all built files... ^_^'

print:
	@echo '********* starting compiling and building *************'

build: clean print all


cplmildr:
	$(CP) $(CPFLAGES) $(CPLILDRSRC) $(CPLILDR_PATH)
cpkrnl:
	$(CD) $(BUILD_PATH) && $(CP) $(CPFLAGES) $(SRCFILE) $(DSTPATH)
cprelease:
	$(CD) $(EXKNL_PATH) && $(CP) $(CPFLAGES) $(RSRCFILE) $(RELEDSTPATH)

release: clean all cplmildr cpkrnl cprelease KIMG

KIMG:
	@echo 'Genrating NekOS kernel img file.....'
	$(CD) $(CPLILDR_PATH) && $(LKIMG) -lhf $(INITLDRIMH) -o Cosmos.eki -f $(LKIMG_INFILE)


createimg:
	$(DD) if=/dev/zero of=$(DSKIMG) count=$(IMGSECTNR) bs=512

#update: $(NEKOS_BIN)
#	sudo mount floppy.img /mnt/kernel
#	sudo cp $< /mnt/kernel/nk_kernel
#	sleep 1
#	sudo umount /mnt/kernel

QEMURUN:
	$(MAKE) $(VMFLAGES)

qemu: release QEMURUN
