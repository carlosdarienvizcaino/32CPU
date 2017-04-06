library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;


entity alu is
	generic (WIDTH : positive := 8);
	port (
	input1   : in std_logic_vector(WIDTH-1 downto 0);
	input2   : in std_logic_vector(WIDTH-1 downto 0);
	opSelect : in std_logic_vector(5 downto 0);
	output : out std_logic_vector(WIDTH-1 downto 0);
	outputHi : out std_logic_vector(WIDTH-1 downto 0);
	branchTaken : out std_logic
	);
end alu;

architecture BHV of alu is

begin
	process(input1,input2,opSelect)
		variable temp_add : unsigned(WIDTH downto 0);
		variable temp_sub : unsigned(WIDTH downto 0);
		variable temp_mult : unsigned(2*WIDTH-1 downto 0);
		variable zeros: unsigned(WIDTH-1 downto 0);
		variable temp_input2 : integer;
		variable temp_operation : std_logic_vector(WIDTH-1 downto 0);
		
		
	begin
		
		outputHi <= (others => '0');
		branchTaken <= '0';
	
		case opSelect is
		
		-- Arithmetic 
			
			when ALU_ADD =>
				temp_add := ("0" & unsigned(input1)) + ("0" & unsigned(input2));
				output <= std_logic_vector(unsigned(temp_add(WIDTH-1 downto 0)));
				
			when ALU_SUB =>
				temp_sub := ("0" & unsigned(input1)) - ("0" & unsigned(input2));
				output <= std_logic_vector(unsigned(temp_sub(WIDTH-1 downto 0)));
				
			when ALU_MULT =>
				temp_mult:= unsigned(input1) * unsigned(input2); 
				output <= std_logic_vector(unsigned(temp_mult(WIDTH-1 downto 0)));
				outputHi <= std_logic_vector(unsigned(temp_mult(WIDTH*2-1 downto WIDTH)));
			
			when ALU_MUL_UNSGINED =>
				temp_mult:= unsigned(input1) * unsigned(input2); 
				output <= std_logic_vector(unsigned(temp_mult(WIDTH-1 downto 0)));
				outputHi <= std_logic_vector(unsigned(temp_mult(WIDTH*2-1 downto WIDTH)));
			
			when ALU_AND =>
				output <= input1 and input2;
				
			when ALU_OR =>
				output <= input1 or input2;
			
			when ALU_XOR =>
				output <= input1 xor input2;
				
			when ALU_SRL =>
				output <= std_logic_vector(shift_right( unsigned(input2),  to_integer(unsigned(input1) )));
				 
			when ALU_SLL =>
				output <= std_logic_vector(shift_left( unsigned(input2),  to_integer(unsigned(input1) )));
				
			when ALU_SRA => 
				temp_operation := std_logic_vector(shift_right( unsigned(input2),  to_integer(unsigned(input1) )));
				output <= "1" & temp_operation(WIDTH-2 downto 0);
							
			when others =>
				temp_add := ("0" & unsigned(input1)) + ("0" & unsigned(input2));
				output <= std_logic_vector(unsigned(temp_add(WIDTH-1 downto 0)));
				
		end case;
		
	end process;
end BHV;
