#include "system.h"
#include "altera_avalon_pwm.h" //developed driver for pwm interfacing
#include "altera_avalon_pio_regs.h" //contains all the needed APIs for Reading and Writing
#include<stdio.h>

int main(){
    IOWR_ALTERA_AVALON_PWM_DIVIDER(PWM_BASE,0xFF);
    IORD_ALTERA_AVALON_PWM_DUTY(PWM_BASE,0xFF);

    printf("Starting!!\n\n\n");
    while(1){
        for(int i=0x00;i<0xFF;i++){
            IORD_ALTERA_AVALON_PWM_DUTY(PWM_BASE,i);
        }
        IORD_ALTERA_AVALON_PWM_DUTY(PWM_BASE,0x00;
    }

}