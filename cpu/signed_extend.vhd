library ieee;
use ieee.std_logic_1164.all;

entity signed_extend is
	port (
		-- Inputs
		clock    : in std_logic;
		input   : in std_logic_vector(15 downto 0);
		isSigned : in std_logic;
		
		-- Outputs
		output   :out std_logic_vector(31 downto 0)
		);
end signed_extend;

architecture BHV of signed_extend is

begin
	
	output <= "0000000000000000" & input;
end BHV;