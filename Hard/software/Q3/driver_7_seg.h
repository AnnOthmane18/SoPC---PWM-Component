#include "system.h"
#include "altera_avalon_pio_regs.h"
#include <unistd.h>
#include <stdio.h>
#ifndef DRIVER_7_SEG_H_
#define DRIVER_7_SEG_H_

alt_u8 sseg_conv_hex(int hex);
void sseg_disp_ptn(alt_u32 base, alt_u8 *ptn);

#endif /*DRIVER_7_SEG_H_*/
