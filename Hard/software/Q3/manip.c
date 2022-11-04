#include "driver_7_seg.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include <unistd.h>
#include <stdio.h>
//#define F 15


//ex 1
/*int main(){

    int add[4] = {HEX0_BASE, HEX1_BASE, HEX2_BASE, HEX3_BASE};
    msg[0] = sseg_conv_hex(1);
    msg[1] = sseg_conv_hex(2);
    msg[2] = sseg_conv_hex(14);
    msg[3] = sseg_conv_hex(15);
    int i;
    for (i=0; i<4; i++){
        IOWR_ALTERA_AVALON_PIO_DATA(add[i], msg[i]);}
    sseg_disp_ptn(HEX4_TO_HEX7_BASE, msg);
    return 0;
}*/
//ex2
int main(){
    alt_u8 msg[4];s
    int add[4] = {HEX0_BASE, HEX1_BASE, HEX2_BASE, HEX3_BASE};
    msg[0] = sseg_conv_hex(5);
    msg[1] = sseg_conv_hex(14);
    msg[2] = sseg_conv_hex(15);
    int i;
    int j;
    for (j=0; j<3; j++){
    for (i=j+0; i<j+3; i++){
        IOWR_ALTERA_AVALON_PIO_DATA(add[i], msg[i]);}}
    usleep(10000);
    return 0;
}