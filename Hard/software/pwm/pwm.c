#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_pwm.h"
#include "unistd.h"
#include "stdio.h"
#include "stdlib.h"

int main(){
    int rx_char;
    printf("App - PWM\n");
    printf("Enter Intensity of LED between 1-4 (0 to exit) \n");
    IOWR_ALTERA_AVALON_PWM_DIVIDER(PWM_BASE, 0xFF);
    IOWR_ALTERA_AVALON_PWM_DUTY(PWM_BASE, 0xFF);
    
    while(1){
        
        rx_char = getc(stdin);
        switch(rx_char){
            
        case '4': IOWR_ALTERA_AVALON_PWM_DUTY(PWM_BASE, 0xFF);
        printf("Intensity level 4\n");
        break;
        
        case '3': IOWR_ALTERA_AVALON_PWM_DUTY(PWM_BASE, 0x80);
        printf("Intensity level 3\n");
        break;
        
        case '2': IOWR_ALTERA_AVALON_PWM_DUTY(PWM_BASE, 0x30);
        printf("Intensity level 2\n");
        break;
        
        case '1': IOWR_ALTERA_AVALON_PWM_DUTY(PWM_BASE, 0x10);
        printf("Intensity level 1\n");
        break;
        
        case '0':
        printf("F.O.\n");
        return 0;
        break;
        
        default: break;
        
        }
    }
    return 0;
}