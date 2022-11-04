/* system.h
 *
 * Machine generated for a CPU named "cpu" as defined in:
 * d:\BER_MED\TP2\Lab_SoPC_2\Hard\Lab_1_SoPC_restored\software\Q1_syslib\..\..\NIOS_System_1.ptf
 *
 * Generated: 2022-10-17 16:56:09.703
 *
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

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

/*
 * system configuration
 *
 */

#define ALT_SYSTEM_NAME "NIOS_System_1"
#define ALT_CPU_NAME "cpu"
#define ALT_CPU_ARCHITECTURE "altera_nios2"
#define ALT_DEVICE_FAMILY "CYCLONEII"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN_BASE 0x00041100
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_PRESENT
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT_BASE 0x00041100
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_PRESENT
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDERR_BASE 0x00041100
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_PRESENT
#define ALT_CPU_FREQ 50000000
#define ALT_IRQ_BASE NULL

/*
 * processor configuration
 *
 */

#define NIOS2_CPU_IMPLEMENTATION "small"
#define NIOS2_BIG_ENDIAN 0

#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_FLUSHDA_SUPPORTED

#define NIOS2_EXCEPTION_ADDR 0x00020020
#define NIOS2_RESET_ADDR 0x00020000
#define NIOS2_BREAK_ADDR 0x00040820

#define NIOS2_HAS_DEBUG_STUB

#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0

/*
 * A define for each class of peripheral
 *
 */

#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_TIMER
#define __ALTERA_AVALON_UART
#define __ALTERA_AVALON_LCD_16207

/*
 * CPU_MEM configuration
 *
 */

#define CPU_MEM_NAME "/dev/CPU_MEM"
#define CPU_MEM_TYPE "altera_avalon_onchip_memory2"
#define CPU_MEM_BASE 0x00020000
#define CPU_MEM_SPAN 102400
#define CPU_MEM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define CPU_MEM_RAM_BLOCK_TYPE "M4K"
#define CPU_MEM_INIT_CONTENTS_FILE "CPU_MEM"
#define CPU_MEM_NON_DEFAULT_INIT_FILE_ENABLED 0
#define CPU_MEM_GUI_RAM_BLOCK_TYPE "Automatic"
#define CPU_MEM_WRITEABLE 1
#define CPU_MEM_DUAL_PORT 0
#define CPU_MEM_SIZE_VALUE 102400
#define CPU_MEM_SIZE_MULTIPLE 1
#define CPU_MEM_USE_SHALLOW_MEM_BLOCKS 0
#define CPU_MEM_INIT_MEM_CONTENT 1
#define CPU_MEM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define CPU_MEM_INSTANCE_ID "NONE"
#define CPU_MEM_READ_DURING_WRITE_MODE "DONT_CARE"
#define CPU_MEM_IGNORE_AUTO_BLOCK_TYPE_ASSIGNMENT 1
#define CPU_MEM_CONTENTS_INFO ""
#define ALT_MODULE_CLASS_CPU_MEM altera_avalon_onchip_memory2

/*
 * jtag_uart configuration
 *
 */

#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_BASE 0x00041100
#define JTAG_UART_SPAN 8
#define JTAG_UART_IRQ 0
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_READ_CHAR_STREAM ""
#define JTAG_UART_SHOWASCII 1
#define JTAG_UART_READ_LE 0
#define JTAG_UART_WRITE_LE 0
#define JTAG_UART_ALTERA_SHOW_UNRELEASED_JTAG_UART_FEATURES 0
#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart

/*
 * LED_R configuration
 *
 */

#define LED_R_NAME "/dev/LED_R"
#define LED_R_TYPE "altera_avalon_pio"
#define LED_R_BASE 0x00041060
#define LED_R_SPAN 16
#define LED_R_DO_TEST_BENCH_WIRING 0
#define LED_R_DRIVEN_SIM_VALUE 0
#define LED_R_HAS_TRI 0
#define LED_R_HAS_OUT 1
#define LED_R_HAS_IN 0
#define LED_R_CAPTURE 0
#define LED_R_DATA_WIDTH 18
#define LED_R_RESET_VALUE 0
#define LED_R_EDGE_TYPE "NONE"
#define LED_R_IRQ_TYPE "NONE"
#define LED_R_BIT_CLEARING_EDGE_REGISTER 0
#define LED_R_FREQ 50000000
#define ALT_MODULE_CLASS_LED_R altera_avalon_pio

/*
 * LED_G configuration
 *
 */

#define LED_G_NAME "/dev/LED_G"
#define LED_G_TYPE "altera_avalon_pio"
#define LED_G_BASE 0x00041070
#define LED_G_SPAN 16
#define LED_G_DO_TEST_BENCH_WIRING 0
#define LED_G_DRIVEN_SIM_VALUE 0
#define LED_G_HAS_TRI 0
#define LED_G_HAS_OUT 1
#define LED_G_HAS_IN 0
#define LED_G_CAPTURE 0
#define LED_G_DATA_WIDTH 8
#define LED_G_RESET_VALUE 0
#define LED_G_EDGE_TYPE "NONE"
#define LED_G_IRQ_TYPE "NONE"
#define LED_G_BIT_CLEARING_EDGE_REGISTER 0
#define LED_G_FREQ 50000000
#define ALT_MODULE_CLASS_LED_G altera_avalon_pio

/*
 * KEYS configuration
 *
 */

#define KEYS_NAME "/dev/KEYS"
#define KEYS_TYPE "altera_avalon_pio"
#define KEYS_BASE 0x00041080
#define KEYS_SPAN 16
#define KEYS_DO_TEST_BENCH_WIRING 0
#define KEYS_DRIVEN_SIM_VALUE 0
#define KEYS_HAS_TRI 0
#define KEYS_HAS_OUT 0
#define KEYS_HAS_IN 1
#define KEYS_CAPTURE 0
#define KEYS_DATA_WIDTH 3
#define KEYS_RESET_VALUE 0
#define KEYS_EDGE_TYPE "NONE"
#define KEYS_IRQ_TYPE "NONE"
#define KEYS_BIT_CLEARING_EDGE_REGISTER 0
#define KEYS_FREQ 50000000
#define ALT_MODULE_CLASS_KEYS altera_avalon_pio

/*
 * SWITCHS configuration
 *
 */

#define SWITCHS_NAME "/dev/SWITCHS"
#define SWITCHS_TYPE "altera_avalon_pio"
#define SWITCHS_BASE 0x00041090
#define SWITCHS_SPAN 16
#define SWITCHS_DO_TEST_BENCH_WIRING 0
#define SWITCHS_DRIVEN_SIM_VALUE 0
#define SWITCHS_HAS_TRI 0
#define SWITCHS_HAS_OUT 0
#define SWITCHS_HAS_IN 1
#define SWITCHS_CAPTURE 0
#define SWITCHS_DATA_WIDTH 18
#define SWITCHS_RESET_VALUE 0
#define SWITCHS_EDGE_TYPE "NONE"
#define SWITCHS_IRQ_TYPE "NONE"
#define SWITCHS_BIT_CLEARING_EDGE_REGISTER 0
#define SWITCHS_FREQ 50000000
#define ALT_MODULE_CLASS_SWITCHS altera_avalon_pio

/*
 * sys_clk_timer configuration
 *
 */

#define SYS_CLK_TIMER_NAME "/dev/sys_clk_timer"
#define SYS_CLK_TIMER_TYPE "altera_avalon_timer"
#define SYS_CLK_TIMER_BASE 0x00041000
#define SYS_CLK_TIMER_SPAN 32
#define SYS_CLK_TIMER_IRQ 1
#define SYS_CLK_TIMER_ALWAYS_RUN 0
#define SYS_CLK_TIMER_FIXED_PERIOD 0
#define SYS_CLK_TIMER_SNAPSHOT 1
#define SYS_CLK_TIMER_PERIOD 1
#define SYS_CLK_TIMER_PERIOD_UNITS "ms"
#define SYS_CLK_TIMER_RESET_OUTPUT 0
#define SYS_CLK_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define SYS_CLK_TIMER_LOAD_VALUE 49999
#define SYS_CLK_TIMER_COUNTER_SIZE 32
#define SYS_CLK_TIMER_MULT 0.0010
#define SYS_CLK_TIMER_TICKS_PER_SEC 1000
#define SYS_CLK_TIMER_FREQ 50000000
#define ALT_MODULE_CLASS_sys_clk_timer altera_avalon_timer

/*
 * high_res_timer configuration
 *
 */

#define HIGH_RES_TIMER_NAME "/dev/high_res_timer"
#define HIGH_RES_TIMER_TYPE "altera_avalon_timer"
#define HIGH_RES_TIMER_BASE 0x00041020
#define HIGH_RES_TIMER_SPAN 32
#define HIGH_RES_TIMER_IRQ 2
#define HIGH_RES_TIMER_ALWAYS_RUN 0
#define HIGH_RES_TIMER_FIXED_PERIOD 0
#define HIGH_RES_TIMER_SNAPSHOT 1
#define HIGH_RES_TIMER_PERIOD 1
#define HIGH_RES_TIMER_PERIOD_UNITS "us"
#define HIGH_RES_TIMER_RESET_OUTPUT 0
#define HIGH_RES_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define HIGH_RES_TIMER_LOAD_VALUE 49
#define HIGH_RES_TIMER_COUNTER_SIZE 32
#define HIGH_RES_TIMER_MULT "1.0E-6"
#define HIGH_RES_TIMER_TICKS_PER_SEC 1000000
#define HIGH_RES_TIMER_FREQ 50000000
#define ALT_MODULE_CLASS_high_res_timer altera_avalon_timer

/*
 * uart configuration
 *
 */

#define UART_NAME "/dev/uart"
#define UART_TYPE "altera_avalon_uart"
#define UART_BASE 0x00041040
#define UART_SPAN 32
#define UART_IRQ 3
#define UART_BAUD 115200
#define UART_DATA_BITS 8
#define UART_FIXED_BAUD 1
#define UART_PARITY 'N'
#define UART_STOP_BITS 1
#define UART_USE_CTS_RTS 0
#define UART_USE_EOP_REGISTER 0
#define UART_SIM_TRUE_BAUD 0
#define UART_SIM_CHAR_STREAM ""
#define UART_FREQ 50000000
#define ALT_MODULE_CLASS_uart altera_avalon_uart

/*
 * HEX0 configuration
 *
 */

#define HEX0_NAME "/dev/HEX0"
#define HEX0_TYPE "altera_avalon_pio"
#define HEX0_BASE 0x000410a0
#define HEX0_SPAN 16
#define HEX0_DO_TEST_BENCH_WIRING 0
#define HEX0_DRIVEN_SIM_VALUE 0
#define HEX0_HAS_TRI 0
#define HEX0_HAS_OUT 1
#define HEX0_HAS_IN 0
#define HEX0_CAPTURE 0
#define HEX0_DATA_WIDTH 7
#define HEX0_RESET_VALUE 0
#define HEX0_EDGE_TYPE "NONE"
#define HEX0_IRQ_TYPE "NONE"
#define HEX0_BIT_CLEARING_EDGE_REGISTER 0
#define HEX0_FREQ 50000000
#define ALT_MODULE_CLASS_HEX0 altera_avalon_pio

/*
 * HEX1 configuration
 *
 */

#define HEX1_NAME "/dev/HEX1"
#define HEX1_TYPE "altera_avalon_pio"
#define HEX1_BASE 0x000410b0
#define HEX1_SPAN 16
#define HEX1_DO_TEST_BENCH_WIRING 0
#define HEX1_DRIVEN_SIM_VALUE 0
#define HEX1_HAS_TRI 0
#define HEX1_HAS_OUT 1
#define HEX1_HAS_IN 0
#define HEX1_CAPTURE 0
#define HEX1_DATA_WIDTH 7
#define HEX1_RESET_VALUE 0
#define HEX1_EDGE_TYPE "NONE"
#define HEX1_IRQ_TYPE "NONE"
#define HEX1_BIT_CLEARING_EDGE_REGISTER 0
#define HEX1_FREQ 50000000
#define ALT_MODULE_CLASS_HEX1 altera_avalon_pio

/*
 * HEX2 configuration
 *
 */

#define HEX2_NAME "/dev/HEX2"
#define HEX2_TYPE "altera_avalon_pio"
#define HEX2_BASE 0x000410c0
#define HEX2_SPAN 16
#define HEX2_DO_TEST_BENCH_WIRING 0
#define HEX2_DRIVEN_SIM_VALUE 0
#define HEX2_HAS_TRI 0
#define HEX2_HAS_OUT 1
#define HEX2_HAS_IN 0
#define HEX2_CAPTURE 0
#define HEX2_DATA_WIDTH 7
#define HEX2_RESET_VALUE 0
#define HEX2_EDGE_TYPE "NONE"
#define HEX2_IRQ_TYPE "NONE"
#define HEX2_BIT_CLEARING_EDGE_REGISTER 0
#define HEX2_FREQ 50000000
#define ALT_MODULE_CLASS_HEX2 altera_avalon_pio

/*
 * HEX3 configuration
 *
 */

#define HEX3_NAME "/dev/HEX3"
#define HEX3_TYPE "altera_avalon_pio"
#define HEX3_BASE 0x000410d0
#define HEX3_SPAN 16
#define HEX3_DO_TEST_BENCH_WIRING 0
#define HEX3_DRIVEN_SIM_VALUE 0
#define HEX3_HAS_TRI 0
#define HEX3_HAS_OUT 1
#define HEX3_HAS_IN 0
#define HEX3_CAPTURE 0
#define HEX3_DATA_WIDTH 7
#define HEX3_RESET_VALUE 0
#define HEX3_EDGE_TYPE "NONE"
#define HEX3_IRQ_TYPE "NONE"
#define HEX3_BIT_CLEARING_EDGE_REGISTER 0
#define HEX3_FREQ 50000000
#define ALT_MODULE_CLASS_HEX3 altera_avalon_pio

/*
 * HEX4_to_HEX7 configuration
 *
 */

#define HEX4_TO_HEX7_NAME "/dev/HEX4_to_HEX7"
#define HEX4_TO_HEX7_TYPE "altera_avalon_pio"
#define HEX4_TO_HEX7_BASE 0x000410e0
#define HEX4_TO_HEX7_SPAN 16
#define HEX4_TO_HEX7_DO_TEST_BENCH_WIRING 0
#define HEX4_TO_HEX7_DRIVEN_SIM_VALUE 0
#define HEX4_TO_HEX7_HAS_TRI 0
#define HEX4_TO_HEX7_HAS_OUT 1
#define HEX4_TO_HEX7_HAS_IN 0
#define HEX4_TO_HEX7_CAPTURE 0
#define HEX4_TO_HEX7_DATA_WIDTH 28
#define HEX4_TO_HEX7_RESET_VALUE 0
#define HEX4_TO_HEX7_EDGE_TYPE "NONE"
#define HEX4_TO_HEX7_IRQ_TYPE "NONE"
#define HEX4_TO_HEX7_BIT_CLEARING_EDGE_REGISTER 0
#define HEX4_TO_HEX7_FREQ 50000000
#define ALT_MODULE_CLASS_HEX4_to_HEX7 altera_avalon_pio

/*
 * lcd configuration
 *
 */

#define LCD_NAME "/dev/lcd"
#define LCD_TYPE "altera_avalon_lcd_16207"
#define LCD_BASE 0x000410f0
#define LCD_SPAN 16
#define ALT_MODULE_CLASS_lcd altera_avalon_lcd_16207

/*
 * system library configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK SYS_CLK_TIMER
#define ALT_TIMESTAMP_CLK none

/*
 * Devices associated with code sections.
 *
 */

#define ALT_TEXT_DEVICE       CPU_MEM
#define ALT_RODATA_DEVICE     CPU_MEM
#define ALT_RWDATA_DEVICE     CPU_MEM
#define ALT_EXCEPTIONS_DEVICE CPU_MEM
#define ALT_RESET_DEVICE      CPU_MEM

/*
 * The text section is initialised so no bootloader will be required.
 * Set a variable to tell crt0.S to provide code at the reset address and
 * to initialise rwdata if appropriate.
 */

#define ALT_NO_BOOTLOADER


#endif /* __SYSTEM_H_ */
