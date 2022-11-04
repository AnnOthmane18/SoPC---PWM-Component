#include "system.h" // where all the macros are defined(addresses of different components inside the chip)
#include "altera_avalon_pwm.h" //developed driver for pwm interfacing
#include "altera_avalon_pio_regs.h" //contains all the needed APIs for Reading and Writing
#include<stdio.h>

int main(){
    IOWR_ALTERA_AVALON_PWM_DIVIDER(PWM_BASE,0xFF); //PWM_BASE Contains the pwm component address
    IORD_ALTERA_AVALON_PWM_DUTY(PWM_BASE,0xFF);

    printf("Starting!!\n\n\n");
    while(1){
        for(int i=0x00;i<0xFF;i++){
            IORD_ALTERA_AVALON_PWM_DUTY(PWM_BASE,i); //changing the DUty cicyle => that will led to change the 26 LEDs intensity
        }
        IORD_ALTERA_AVALON_PWM_DUTY(PWM_BASE,0x00;
    }
}