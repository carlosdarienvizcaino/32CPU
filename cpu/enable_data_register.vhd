library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enable_data_register is
  generic(WIDTH : natural := 32);
  port (
			-- Inputs
			clock    : in std_logic;
			rst 		: in std_logic;
			enable   : in std_logic;
			input    : in std_logic_vector(WIDTH-1 downto 0);
			
			-- Outputs
			output   : out std_logic_vector(WIDTH-1 downto 0)
	 );
end enable_data_register;

architecture STR of enable_data_register is
	
	signal internal_enable : std_logic;
begin 

	process(rst, clock)
	begin
			internal_enable <= enable;
			if(rst = '1') then
					output <= (others => '0');
			
			elsif(clock'event and clock = '1') then 
			
				if (internal_enable = '1') then
					output <= input;
				end if;
				
			 end if;
			
	end process;
	 
end STR;