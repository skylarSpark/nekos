/******************************************************************
*		HAL Automatic Link Configuration
*		Chris OCT. 19 2024
******************************************************************/
#include "config.h"
MAKEFLAGS = -s
#ifdef CFG_X86_PLATFORM
KERNELCE_PATH	= ../hal/x86/
HEADFILE_PATH = -I ../include -I ../include/bastypeinc -I ../include/halinc -I ../include/knlinc -I ../include/libinc -I ../include/drvinc
#endif