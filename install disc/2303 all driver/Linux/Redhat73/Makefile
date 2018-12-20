# USB-Serial Makefile
#
# USAGE:
# To install driver -
#        make inst (The Makefile will check the module and compile and link it automatically. It will also remove
#                   the loaded USB-Serial driver)
#
# To uninstall driver -
#        make uninst
#
# To uninstall all drivers (including base driver) -
#        make uninst_all
#
# To remove module (*.o) files -
#        make clean
#

KINCLUDES=/usr/src/linux-2.4/include
DRVINCLUDES=/usr/src/linux-2.4/drivers/usb/serial

# uncomment line below if you have SMP
#SMPFLAGS=	-D__SMP__ -DCONFIG_SMP=1

# Unless you have a 386/486, you shouldn't need
# to change anything below here...

# CPUFLAGS=	-DCPU=586 -march=i586
MODULE=		pl2303
BASE_MODULE=	usbserial
CC=		gcc
CPPFLAGS=	-D__KERNEL__ -I$(KINCLUDES) -I$(DRVINCLUDES)
MODFLAGS=	-DMODULE
KERNFLAGS=      $(CPPFLAGS) $(CPUFLAGS) $(SMPFLAGS) \
		-Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fomit-frame-pointer \
		-fno-strict-aliasing -fno-common -Wno-unused
# EXTRA_CFLAGS=	-DEXPORT_SYMTAB
# DBGCFLAGS=	-DDEBUG -DCONFIG_USB_SERIAL_DEBUG
CFLAGS=		$(KERNFLAGS) $(DBGCFLAGS) $(MODFLAGS)

RELVER=		$(shell uname -r)

all::		$(MODULE).o

$(MODULE).o:	$(MODULE).c
	$(CC) $(CFLAGS) -c $<

.PHONY: inst, uninst, uninst_all, clean

inst:	$(MODULE).o
ifneq (,$(findstring $(MODULE),$(shell lsmod | grep $(MODULE))))		# if module was already loaded
	rmmod $(MODULE)
	insmod ./$(MODULE).o
else
ifeq (,$(findstring $(BASE_MODULE),$(shell lsmod | grep $(BASE_MODULE))))	# if there is no base module
	insmod /lib/modules/$(RELVER)/kernel/drivers/usb/serial/$(BASE_MODULE).o
endif	
	insmod ./$(MODULE).o
endif
	@echo
	@echo ">> Please unplug and plug the cable if it is already plugged-in. <<"
	@echo

uninst:
ifneq (,$(findstring $(MODULE),$(shell lsmod | grep $(MODULE))))		# if module was loaded
	rmmod $(MODULE)
endif	
	@echo
	@echo ">> The USB-Serial driver is removed! <<"
	@echo

uninst_all:
ifneq (,$(findstring $(MODULE),$(shell lsmod | grep $(MODULE))))		# if module was loaded
	rmmod $(MODULE)
endif
ifneq (,$(findstring $(BASE_MODULE),$(shell lsmod | grep $(BASE_MODULE))))	# if base module was loaded
	rmmod $(BASE_MODULE)
endif	
	@echo
	@echo ">> The USB-Serial and base driver are removed! <<"
	@echo

clean:
	rm -f *.o
