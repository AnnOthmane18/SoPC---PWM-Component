<!-- # Size Limit [![Cult Of Martians][cult-img]][cult] -->
<h1>System On Programmable Chip</h1>
<p align="center">
    <img src="Files/SOC.png"  alt="Size Limit logo by Anton Lovchikov" width="500" height="550">
</p>

In this Mini-Project, I've tried to develop a mini **System On Chip**, developping both side(Hard + Soft), based on the open source, given processor in an **IP**(intellectual Property) Format, which is the **NIOS II** processor, by the company **Intel Altera**, using the **Quartus** Environment.


## HARD(SoPC)
### Board used :
 
* **Board used**: FPGA CYCLONE II DE2-70
<p align="center">
    <img src="Files/fpga.jpg" alt="Size Limit logo by Anton Lovchikov" width="500" height="550">
</p>

### Developping the Chip
To build the chip, I used the **SoPC Builder** tool of Quartus, It's an integrated tool, which allow us to add all the given component for free by Altera, in an IP Format(HDL Code Encrypted), also one of his big advantages, is that he can generate the HDL,ASM,C code for the created chip.
<p align="center">
  <img src="Files/Sopc_builder.png" alt="Sopc Builder">
</p>
We should add in the first place the main processor, which NIOS II, the CPU MEMORY, and the JTAG_UART component, as an essenital components for the chip, and then adding other component(Controllers), like Swicthes, Buttons, LCD, 7 Segments...etc. at the end we got the generated Chip below :

<p align="center">
<img src="Files/Generated_Chip.png"  alt="Generated Chip">
</p>


 `PWM Output size 26`=> it's because on the FPGA Board, we have just 26 LEDs in total.

#### Altera Avalon Bus
The NIOS II processor, uses only one component(as an intermediate) to communicate with other controllers, existed inside the chip which is the AVALON Bus, It's an integrated Bus, from which all the data pass through it.
<p align="center">
<img src="Files/avalon_bus.png"  alt="Generated Chip">
</p>

### PWM Component
Inisde the SoPC Builder, Altera does not provide, an IP for PWM component(Controller + Interface), so that we can add it to our Chip, we have to develop our own VHDL code, and create a new component, in the file menu. the VHDL code contains 2 parts one for the **PWM logic**, and one for the **Interfacing**, since NIOS II, uses AVALON Bus as internal bus, from which the processor can `read/write` from/to other internal components.

<p align="center">
<img src="Files/PWM.png"  alt="Generated Chip">
</p>

* **Address Signal**: To select which Register to use(Duty/Div), and since we got just 2 registers, this signal is coded on 1 bit(0/1). 
* **CS Signal**: Since all the compoenent are linked to the processor via this bus, we need to specify which chip we're dealing(write/read) with.
* **WriteDATA Signal**: For sending data over the bus.
* **Write_n Signal**: For Enabling/Disabling writing operation.
* **ReadDATA Signal**: For reading data from the bus.
* **Read_n  Signal**: For Enabling/Disabling Reading operation.
* **OutputPWM Signal**: Either 1 or 0 for all the other 25 bits, since the output signal is coded on 26 bits(26 LEDs).
## Reports

## Soft

As a first step, we should develop the driver, to make it easy and simple manipulating the 2 registers (Duty && Div).
* **Driver:**
```yaml
#ifndef __ALTERA_AVALON_PWM_REGS_H__
#define __ALTERA_AVALON_PWM_REGS_H__

#include <io.h>

#define IORD_ALTERA_AVALON_PWM_DIVIDER(base)            IORD(base, 0) 
#define IOWR_ALTERA_AVALON_PWM_DIVIDER(base, data)      IOWR(base, 0, data)

#define IORD_ALTERA_AVALON_PWM_DUTY(base)       IORD(base, 1) 
#define IOWR_ALTERA_AVALON_PWM_DUTY(base, data) IOWR(base, 1, data)


#endif /* __ALTERA_AVALON_PWM_REGS_H__ */

```

