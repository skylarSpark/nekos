include krnlbuidcmd.mh
include ldrobjs.mh
.PHONY : all everything build_kernel
all: build_kernel 
#INITLDR
build_kernel:everything build_bin
everything : $(INITLDRIMH_ELF) $(INITLDRKRL_ELF) $(INITLDRSVE_ELF)
build_bin:$(INITLDRIMH) $(INITLDRKRL) $(INITLDRSVE)

$(INITLDRIMH_ELF): $(INITLDRIMH_LINK)
	$(LD) $(LDRIMHLDFLAGS) -o $@ $(INITLDRIMH_LINK)
$(INITLDRKRL_ELF): $(INITLDRKRL_LINK)
	$(LD) $(LDRKRLLDFLAGS) -o $@ $(INITLDRKRL_LINK)
$(INITLDRSVE_ELF): $(INITLDRSVE_LINK)
	$(LD) $(LDRSVELDFLAGS) -o $@ $(INITLDRSVE_LINK)
$(INITLDRIMH):$(INITLDRIMH_ELF)
	$(OBJCOPY) $(OJCYFLAGS) $< $@
	@echo 'OBJCOPY -[M] Building...' $@  
$(INITLDRKRL):$(INITLDRKRL_ELF)
	$(OBJCOPY) $(OJCYFLAGS) $< $@
	@echo 'OBJCOPY -[M] Building...' $@ 
$(INITLDRSVE):$(INITLDRSVE_ELF)
	$(OBJCOPY) $(OJCYFLAGS) $< $@
	@echo 'OBJCOPY -[M] Building...' $@ 