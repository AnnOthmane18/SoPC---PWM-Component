/* alt_sys_init.c - HAL initialisation source
 *
 * Machine generated for a CPU named "cpu" as defined in:
 * d:\BER_MED\TP2\Lab_SoPC_2\Hard\Lab_1_SoPC_restored\software\lcdensa_syslib\..\..\NIOS_System_1.ptf
 *
 * Generated: 2022-10-26 21:47:42.64
 *
 */

/*

DO NOT MODIFY THIS FILE

   Changing this file will have subtle consequences
   which will almost certainly lead to a nonfunctioning
   system. If you do modify this file, be aware that your
   changes will be overwritten and lost when this file
   is generated again.

DO NOT MODIFY THIS FILE

*/

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/

#include "system.h"
#include "sys/alt_sys_init.h"

#include <stddef.h>

/*
 * device headers
 *
 */

#include "altera_avalon_jtag_uart.h"
#include "altera_avalon_timer.h"
#include "altera_avalon_uart.h"
#include "altera_avalon_lcd_16207.h"

/*
 * Allocate the device storage
 *
 */

ALTERA_AVALON_JTAG_UART_INSTANCE( JTAG_UART, jtag_uart );
ALTERA_AVALON_TIMER_INSTANCE( SYS_CLK_TIMER, sys_clk_timer );
ALTERA_AVALON_TIMER_INSTANCE( HIGH_RES_TIMER, high_res_timer );
ALTERA_AVALON_UART_INSTANCE( UART, uart );
ALTERA_AVALON_LCD_16207_INSTANCE( LCD, lcd );

/*
 * Initialise the devices
 *
 */

void alt_sys_init( void )
{
    ALTERA_AVALON_TIMER_INIT( SYS_CLK_TIMER, sys_clk_timer );
    ALTERA_AVALON_TIMER_INIT( HIGH_RES_TIMER, high_res_timer );
    ALTERA_AVALON_JTAG_UART_INIT( JTAG_UART, jtag_uart );
    ALTERA_AVALON_UART_INIT( UART, uart );
    ALTERA_AVALON_LCD_16207_INIT( LCD, lcd );
}
