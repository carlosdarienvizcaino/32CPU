library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package alu_lib is
	
	constant NUMBER_SIZE : integer := 6;
	
	constant RTYPE : std_logic_vector := std_logic_vector(to_unsigned(16#00#, NUMBER_SIZE));
	
	-- Arithmetic 
	constant ALU_ADD : std_logic_vector := std_logic_vector(to_unsigned(16#21#, NUMBER_SIZE));
	constant ALU_SUB : std_logic_vector := std_logic_vector(to_unsigned(16#23#, NUMBER_SIZE));
	constant ALU_MULT : std_logic_vector := std_logic_vector(to_unsigned(16#18#, NUMBER_SIZE));
	constant ALU_MUL_UNSGINED : std_logic_vector := std_logic_vector(to_unsigned(16#19#, NUMBER_SIZE));
	
	-- Logical
	constant ALU_AND : std_logic_vector := std_logic_vector(to_unsigned(16#24#, NUMBER_SIZE));
	constant ALU_OR : std_logic_vector := std_logic_vector(to_unsigned(16#25#, NUMBER_SIZE));
	constant ALU_XOR : std_logic_vector := std_logic_vector(to_unsigned(16#26#, NUMBER_SIZE));
	
	constant ALU_SRL : std_logic_vector := std_logic_vector(to_unsigned(16#02#, NUMBER_SIZE)); -- shift right logic
	constant ALU_SLL : std_logic_vector := std_logic_vector(to_unsigned(16#00#, NUMBER_SIZE)); -- shift left logic
	constant ALU_SRA : std_logic_vector := std_logic_vector(to_unsigned(16#03#, NUMBER_SIZE)); -- shift left arithmetic
	constant ALU_SLT : std_logic_vector := std_logic_vector(to_unsigned(16#2A#, NUMBER_SIZE)); -- Set on less than signed
	constant ALU_SLTU : std_logic_vector := std_logic_vector(to_unsigned(16#2B#, NUMBER_SIZE)); -- Set on less than unsiged
	
	constant ALU_MFHI : std_logic_vector := std_logic_vector(to_unsigned(16#10#, NUMBER_SIZE)); -- move from HI
	constant ALU_MFLO : std_logic_vector := std_logic_vector(to_unsigned(16#12#, NUMBER_SIZE)); -- move from LO
	
	
	-- Unconditional Jump
	constant ALU_JR : std_logic_vector := std_logic_vector(to_unsigned(16#08#, NUMBER_SIZE)); -- branch greater than zero
	
	
	
	-- ITypes
	-- Arithmetic
	constant ALU_ADD_I : std_logic_vector := std_logic_vector(to_unsigned(16#09#, NUMBER_SIZE));
	constant ALU_SUB_I : std_logic_vector := std_logic_vector(to_unsigned(16#10#, NUMBER_SIZE));
	
	-- Logical
	constant ALU_AND_I : std_logic_vector := std_logic_vector(to_unsigned(16#0C#, NUMBER_SIZE));
	constant ALU_XOR_I : std_logic_vector := std_logic_vector(to_unsigned(16#0E#, NUMBER_SIZE));
	
	constant ALU_SLTI : std_logic_vector := std_logic_vector(to_unsigned(16#0A#, NUMBER_SIZE)); -- Set on less than immediate signed
	constant ALU_SLTIU : std_logic_vector := std_logic_vector(to_unsigned(16#0B#, NUMBER_SIZE)); -- Set on less than immediate unsigned
	
	constant ALU_LW : std_logic_vector := std_logic_vector(to_unsigned(16#23#, NUMBER_SIZE)); -- load word
	constant ALU_SW : std_logic_vector := std_logic_vector(to_unsigned(16#2B#, NUMBER_SIZE)); -- store word
	
	constant ALU_BEQ : std_logic_vector := std_logic_vector(to_unsigned(16#04#, NUMBER_SIZE)); -- branch equal
	constant ALU_BNE : std_logic_vector := std_logic_vector(to_unsigned(16#05#, NUMBER_SIZE)); -- branch not equal
	
	constant ALU_LTOEZ : std_logic_vector := std_logic_vector(to_unsigned(16#06#, NUMBER_SIZE)); -- branch less than or equal to zero
	constant ALU_BGTZ : std_logic_vector := std_logic_vector(to_unsigned(16#07#, NUMBER_SIZE)); -- branch greater than zero
	
	-- Unconditional jums
	constant ALU_JTA : std_logic_vector := std_logic_vector(to_unsigned(16#02#, NUMBER_SIZE)); -- branch not equal
	constant ALU_JNL : std_logic_vector := std_logic_vector(to_unsigned(16#03#, NUMBER_SIZE)); -- branch less than or equal to zero
	
	
end alu_lib;
