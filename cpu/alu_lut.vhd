library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

entity lau_lut is
    port (
        -- Inputs 
        opcode : in std_logic_vector(5 downto 0);
		  
		  -- Outputs
        func  : out std_logic_vector(5 downto 0)
    );
end lau_lut;

architecture BHV of lau_lut is
begin
	
    process (opcode) is
    begin
        
		 case opcode is      
        
		 -- Arithmetic 
		 when ALU_ADD_I => func <= "100011";
		 when ALU_SUB_I => func <= ALU_SUB;

		 -- Logical
		 when ALU_AND_I => func <= ALU_AND;
		 when ALU_XOR_I => func <= ALU_XOR;
		 when ALU_SLTI  => func <= ALU_SLT;
		 when ALU_SLTIU => func <= ALU_SLTIU;


		 when ALU_LW => func <= ALU_ADD;
		 when ALU_SW => func <= ALU_ADD;

		 -- Unconditial Jumps
		 when ALU_JTA => func <= ALU_ADD;
		  
		 -- error
		 when others => func <= "111111";
		  
        end case;
    end process;
	 
end BHV;
