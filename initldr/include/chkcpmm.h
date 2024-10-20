/*******************************
 * system global memory check
 * Chris Oct. 16 2024
 ******************************/
#ifndef _CHKCPMM_H
#define _CHKCPMM_H
void init_mem(machbstart_t* mbsp);
void init_krlinitstack(machbstart_t* mbsp);
void init_meme820(machbstart_t* mbsp);
void init_chkcpu(machbstart_t* mbsp);
void mmap(e820map_t** retemp,u32_t* retemnr);
int chk_cpuid();
int chk_cpu_longmode();
e820map_t* chk_memsize(e820map_t* e8p,u32_t enr,u64_t sadr,u64_t size);
u64_t get_memsize(e820map_t* e8p,u32_t enr);
void init_chkmm();
void out_char(char* c);
void init_bstartpages(machbstart_t *mbsp);
void ldr_createpage_and_open();
#define CLI_HALT() __asm__ __volatile__("cli; hlt": : :"memory")
#endif