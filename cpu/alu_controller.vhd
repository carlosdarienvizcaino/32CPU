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
	
	signal alu_lut_output : std_logic_vector(5 downto 0);
	
begin 

	process(ALUOp) 
	begin 
	
		-- Defaults
		HI_en <= '0';
		LO_en <= '0';
		ALU_LO_HI <= (others =>('0'));
		OpSelect <= "111111";
		
		if (ALUOp = "000000") then 
			OpSelect <= IR5To0;
			
			case IR5To0 is 
			
				when ALU_MFHI => 
					ALU_LO_HI <= "10";
					
				when ALU_MFLO =>
					ALU_LO_HI <= "01";
					
				when ALU_MULT =>
					HI_en <= '1';
					LO_en <= '1';
					
				when ALU_MUL_UNSGINED => 
					HI_en <= '1';
					LO_en <= '1';
					
				when others =>
					HI_en <= '0';
					LO_en <= '0';
					ALU_LO_HI <= (others =>('0'));
					
			end case;
			
		else
			
			case ALUOp is      
        
			-- Arithmetic 
			when ALU_ADD_I => 
				OpSelect <= ALU_ADD;
				
			when ALU_SUB_I => 
				OpSelect <= ALU_SUB;

			-- Logical
			when ALU_AND_I => 
				OpSelect <= ALU_AND;
				
			when ALU_XOR_I => 
				OpSelect <= ALU_XOR;
				
			when ALU_SLTI  => 
				OpSelect <= ALU_SLT;
				
			when ALU_SLTIU => 
				OpSelect <= ALU_SLTU;

			when ALU_LW => 
				OpSelect <= ALU_ADD;
				
			when ALU_SW => 
				OpSelect <= ALU_ADD;
					
			-- Unconditial Jumps
			when ALU_JTA => 
				OpSelect <= ALU_ADD;
				
			when ALU_JNL =>
				OpSelect <= ALU_ADD;
		  
			-- error
			when others => 
				OpSelect <= "111111";
				
			end case;
			
		end if;
	end process;
	
end STR;