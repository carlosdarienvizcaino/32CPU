library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_mapper is
  generic(WIDTH : natural := 32);
  port (
		input_address : in std_logic_vector(WIDTH-1 downto 0);
		output : out std_logic_vector(1 downto 0)
	 );
end address_mapper;

architecture STR of address_mapper is
	
begin 

	process(input_address)
	begin
			if( input_address = to_stdlogicvector(x"0000FFF8")) then 
				output <= "01";
				
			elsif (input_address = to_stdlogicvector(x"0000FFFC")) then
				output <= "10";
				
			else 
				output <= (others => '0');
			end if;
	 
	end process;
	 
end STR;