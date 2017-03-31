library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package alu_lib is
	
	constant NUMBER_SIZE : integer := 6;
	
	-- Arithmetic 
	constant ALU_ADD : std_logic_vector := std_logic_vector(to_unsigned(16#21#, NUMBER_SIZE));
	constant ALU_SUB : std_logic_vector := std_logic_vector(to_unsigned(16#23#, NUMBER_SIZE));
	constant ALU_MULT : std_logic_vector := std_logic_vector(to_unsigned(16#18#, NUMBER_SIZE));
	constant MUL_UNSGINED : std_logic_vector := std_logic_vector(to_unsigned(16#19#, NUMBER_SIZE));
	
	-- Logical
	constant ALU_AND : std_logic_vector := std_logic_vector(to_unsigned(16#24#, NUMBER_SIZE));
	constant ALU_OR : std_logic_vector := std_logic_vector(to_unsigned(16#25#, NUMBER_SIZE));
	constant ALU_XOR : std_logic_vector := std_logic_vector(to_unsigned(16#26#, NUMBER_SIZE));
	
	constant ALU_SRL : std_logic_vector := std_logic_vector(to_unsigned(16#02#, NUMBER_SIZE)); -- shift right logic
	constant ALU_SLL : std_logic_vector := std_logic_vector(to_unsigned(16#00#, NUMBER_SIZE)); -- shift left logic 
	
	-- Unconditional Jump
end alu_lib;
