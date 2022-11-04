library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_pwm_gen is
  generic (n: integer := 8); 
  port (
        clk 		: in std_logic;
	      writedata 	: in std_logic_vector (31 downto 0);  -- 32 bits because the NIOS II processor uses 32 bits
	      chipselect 	: in std_logic;
	      write_n 	  : in std_logic;
	      address 	  : in std_logic;
	      reset_n 	  : in std_logic;
	      readdata 	  : out std_logic_vector (31 downto 0);
	      out_port 	  : out std_logic_vector (n-1 downto 0));
end avalon_pwm_gen;


architecture RTL of avalon_pwm_gen is  
  signal div     : unsigned (31 downto 0);
  signal duty    : unsigned (31 downto 0);
  signal counter : unsigned (31 downto 0);
  signal pwm_on  : std_logic;

begin
  -- COUNTER process
  divider: process (clk, reset_n)
  begin
    if reset_n = '0' then -- reset signal has the higher priority among all signals
      counter <= (others => '0');
    elsif clk'event and clk = '1' then -- on a Rising edge
      if counter >= div then
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;
--Comparator process 
  duty_cyle: process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_on <= '1';
    elsif clk'event and clk = '1' then
      if counter >= duty then
        pwm_on <= '0';
      elsif counter = 0 then
        pwm_on <= '1';
      end if;
    end if;
  end process;

  --Interfacing between ALtera Avalon BUS and PWM component
   
  readdata <= std_logic_vector(div) when address = '0' else std_logic_vector(duty);

  registers : process (clk, reset_n) --since we have 2 internal registers, they will be code on 1 bit,
                                     -- each register will have either 0 or 1 as a reg address
  begin
    if reset_n = '0' then
      div <= (others => '0');
    elsif clk'event and clk = '1' then
      if chipselect = '1' and write_n ='0' then -- Write_n = '0' it means that we want to write data to the bus(Enabling writing operation) 
        if address ='0' then -- address 0 >> div register
	        div(31 downto 0) <= unsigned(writedata(31 downto 0));
	      else  -- address 1 >> duty register
	        duty(31 downto 0) <= unsigned(writedata(31 downto 0));
	      end if;
      end if;
    end if;
end process;

out_port <= (others=> pwm_on);

end RTL;

