#ifndef __ALTERA_AVALON_PWM_REGS_H__
#define __ALTERA_AVALON_PWM_REGS_H__

#include <io.h>

#define IORD_ALTERA_AVALON_PWM_DIVIDER(base)            IORD(base, 0) 
#define IOWR_ALTERA_AVALON_PWM_DIVIDER(base, data)      IOWR(base, 0, data)

#define IORD_ALTERA_AVALON_PWM_DUTY(base)       IORD(base, 1) 
#define IOWR_ALTERA_AVALON_PWM_DUTY(base, data) IOWR(base, 1, data)


#endif /* __ALTERA_AVALON_PWM_REGS_H__ */
