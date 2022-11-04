library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_pwm_gen is
  generic (n: integer := 8); 
  port (
        clk 		: in std_logic;
	writedata 	: in std_logic_vector (31 downto 0);
	chipselect 	: in std_logic;
	write_n 	: in std_logic;
	address 	: in std_logic;
	reset_n 	: in std_logic;
	readdata 	: out std_logic_vector (31 downto 0);
	out_port 	: out std_logic_vector (n-1 downto 0) );
end avalon_pwm_gen;


architecture RTL of avalon_pwm_gen is

  
  signal div     : unsigned (31 downto 0);
  signal duty    : unsigned (31 downto 0);
  signal counter : unsigned (31 downto 0);
  signal pwm_on  : std_logic;

begin

 



    divider: process (clk, reset_n)
  begin
    if reset_n = '0' then
      counter <= (others => '0');
    elsif clk'event and clk = '1' then
      if counter >= div then
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;



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

  readdata <= std_logic_vector(div) when address = '0' else std_logic_vector(duty);

  registers : process (clk, reset_n)
  begin
    if reset_n = '0' then
      div <= (others => '0');
    elsif clk'event and clk = '1' then
      if chipselect = '1' and write_n ='0' then
        if address ='0' then
	  div(31 downto 0) <= unsigned(writedata(31 downto 0));
	else
	  duty(31 downto 0) <= unsigned(writedata(31 downto 0));
	end if;
       end if;
     end if;
end process;


  out_port <= (others=> pwm_on);

end RTL;

