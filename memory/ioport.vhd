library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ioport is
  generic(WIDTH : natural := 32);
  port (
			clk    : in std_logic;
			en     : in std_logic;
			input  : in std_logic_vector(WIDTH -1 downto 0);
			output : out std_logic_vector(31 downto 0)
	 );
end ioport;

architecture STR of ioport is
	signal temp_output : std_logic_vector(WIDTH -1 downto 0);
begin 

	process(clk)
	begin
			if(clk'event and clk = '1') then 
					output <= temp_output;
			end if;
	end process;
	
	process(en)
	begin 
			if(en = '1') then 
				temp_output <= input;
			end if;
	 
	end process;
	 
end STR;