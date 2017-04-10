library ieee;
use ieee.std_logic_1164.all;

entity signed_extend is
	port (
		-- Inputs
		rst     : in std_logic;
		clock   : in std_logic;
		input   : in std_logic_vector(15 downto 0);
		isSigned : in std_logic;
		
		-- Outputs
		output   :out std_logic_vector(31 downto 0)
		);
end signed_extend;

architecture BHV of signed_extend is

begin

	
	process(isSigned, input) 
	begin 
		
		if (isSigned = '1') then
			
			if ( input(15) = '1') then
				 output <= "1111111111111111" & input;
			else 
				output <= "0000000000000000" & input;
			end if;
			
		else
			output <= "0000000000000000" & input;
		end if;
		
	end process;

end BHV;