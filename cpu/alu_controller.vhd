library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

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
			
			-- Set HI_en when IR5To is mult or multu
			if ( IR5To0 = ALU_MULT or IR5To0 = ALU_MUL_UNSGINED) then
				HI_en <= '1';
				LO_en <= '1';
			else
				HI_en <= '1';
				LO_en <= '1';
			end if;
			
		else
			OpSelect <= ALUOp;
		end if;
	end process;
	
end STR;