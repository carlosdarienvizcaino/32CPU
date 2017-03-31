library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
  generic (WIDTH : positive := 32);
  port (
		-- Inputs
		clock       : std_logic;
		rst         : std_logic;
		instruction : std_logic_vector(WIDTH-1 downto 0);
		address 	   : std_logic_vector(WIDTH-1 downto 0);
		
		-- Outputs
		MemRead   : std_logic;
		MemWrite  : std_logic;
		output    : std_logic_vector(WIDTH-1 downto 0)
	 );
end cpu;

architecture STR of cpu is
	
	
begin 



	 
end STR;