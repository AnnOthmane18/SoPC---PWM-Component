#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "unistd.h"
#include "stdio.h"

int main(void){
    int e=~ 0x79;
    int n=~ 0x54;
    int s=~ 0x6D;
    int a=~ 0x77;
    //long int ensa =~ 0x79546D77;
    int ensa =~ 0xF3536F7;
    int init =~ 0xFFFFFFF;
    //int ensa2 =~ 0b1111001101010011011011110111
    while(1){
        IOWR_ALTERA_AVALON_PIO_DATA(HEX3_BASE,e);
        IOWR_ALTERA_AVALON_PIO_DATA(HEX2_BASE,n);
        IOWR_ALTERA_AVALON_PIO_DATA(HEX1_BASE,s);
        IOWR_ALTERA_AVALON_PIO_DATA(HEX0_BASE,a);
        IOWR_ALTERA_AVALON_PIO_DATA(HEX4_TO_HEX7_BASE,init);
    }
return 0;
}
