#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "unistd.h"
#include "stdio.h"

int main(){
    
    //exp1
    /*printf("ENSA-FES\n");
    FILE *fp;
    fp = fopen(LCD_NAME, "r+");
    fprintf(fp, "%s", "ENSA FES");*/
    
    
    
    //exp2
    /*alt_u8 button_val, var_1;
    FILE* fp;
    
    printf("App LCD\n");
    while(1) {
    
        usleep(1000);
        button_val = ~IORD_ALTERA_AVALON_PIO_DATA(KEYS_BASE);
        if (button_val & 0x01){
            var_1 = 0x01;
        }else if(button_val & 0x04){
            var_1 = 0x02;
        }else
            var_1 = 0x00;
            
        fp = fopen(LCD_NAME, "r+");
        
        switch(var_1){
            case 0x01: usleep(1000);
            fprintf(fp, "%s", "ENSA FES");
            break;
            
            case 0x02: usleep(1000);
            fprintf(fp, "%s", "-_-");
            break;
            
            default: break;
        }
        
        fclose(fp);
    }*/
    
    
    
    
     //exp3
     
    alt_u8 button_val, var_1;
    FILE *fp1, *fp2;
    
    printf("App LCD et RS232\n");
    while(1) {
    
        usleep(1000);
        button_val = ~IORD_ALTERA_AVALON_PIO_DATA(KEYS_BASE);
        if (button_val & 0x01){
            var_1 = 0x01;
        }else if(button_val & 0x04){
            var_1 = 0x02;}
            
        fp1 = fopen(LCD_NAME, "r+");
        fp2 = fopen(UART_NAME, "r+");
        
        switch(var_1){
            case 0x01: usleep(1000);
            fprintf(fp1, "%s", "ENSA FES");
            break;
            
            case 0x02: usleep(1000);
            fprintf(fp2, "%s", "-_-");
            break;
            
            default: break;
        }
        
        fclose(fp1);
        fclose(fp2);
    
    }
return 0;
}