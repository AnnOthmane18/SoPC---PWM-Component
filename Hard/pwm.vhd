--Legal Notice: (C)2022 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pwm is 
        port (
              -- inputs:
                 signal address : IN STD_LOGIC;
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal write_n : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal out_port : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                 signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity pwm;


architecture europa of pwm is
component avalon_pwm is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (25 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component avalon_pwm;

                signal internal_out_port :  STD_LOGIC_VECTOR (25 DOWNTO 0);
                signal internal_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --the_avalon_pwm, which is an e_instance
  the_avalon_pwm : avalon_pwm
    port map(
      out_port => internal_out_port,
      readdata => internal_readdata,
      address => address,
      chipselect => chipselect,
      clk => clk,
      reset_n => reset_n,
      write_n => write_n,
      writedata => writedata
    );


  --vhdl renameroo for output signals
  out_port <= internal_out_port;
  --vhdl renameroo for output signals
  readdata <= internal_readdata;

end europa;

