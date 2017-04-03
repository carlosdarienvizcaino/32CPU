library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_controller is
  generic (WIDTH : positive := 32);
  port (
		-- Inputs
		IR5To0  : in std_logic_vector(5 downto 0);
		ALUOp   : in std_logic_vector(5 downto 0);
			
	-- Outpus
		OpSelect : out std_logic_vector(5 downto 0);
		HI_en    : out std_logic;
		LO_en 	: out std_logic;
		ALU_LO_HI : out std_logic_vector(1 downto 0)
 );
end alu_controller;

architecture STR of alu_controller is
	
	
begin 

	process(ALUOp) 
	begin 
	
		-- Defaults
		HI_en <= '0';
		LO_en <= '0';
		ALU_LO_HI <= (others =>('0'));
		
		if (ALUOp = "000000") then 
			OpSelect <= IR5To0;
		else
			OpSelect <= (others =>('0'));
		end if;
	end process;
	
end STR;