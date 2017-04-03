library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_register is
  generic(WIDTH : natural := 32);
  port (
			clock    : in std_logic;
			rst 		: std_logic;
			input    : in std_logic_vector(WIDTH-1 downto 0);
			output   : out std_logic_vector(WIDTH-1 downto 0)
	 );
end data_register;

architecture STR of data_register is
	
begin 

	process(rst, clock)
	begin
			if(rst = '1') then
					output <= (others => '0');
			
			elsif(clock'event and clock = '1') then 
					output <= input;
			end if;
	end process;
	 
end STR;