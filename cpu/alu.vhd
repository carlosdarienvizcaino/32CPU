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
		variable temp_mult : signed(2*WIDTH-1 downto 0);
		variable temp_mult_unsigned : unsigned(2*WIDTH-1 downto 0);
		variable zeros: unsigned(WIDTH-1 downto 0);
		variable temp_input2 : integer;
		variable temp_operation : std_logic_vector(WIDTH-1 downto 0);
		variable zero : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
		
		variable temp_add_signed : signed (WIDTH downto 0);
		
	begin
		
		outputHi <= (others => '0');
		branchTaken <= '0';
		output <= (others => '0');
	
		case opSelect is
		
		-- Arithmetic 
			
			when ALU_ADD =>
				temp_add := ("0" & unsigned(input1)) + ("0" & unsigned(input2));
				output <= std_logic_vector(unsigned(temp_add(WIDTH-1 downto 0)));
				
			when ALU_ADD_SIGNED =>
				temp_add_signed := ("0" & signed(input1)) + ("0" & signed(input2));
				output <= std_logic_vector(unsigned(temp_add(WIDTH-1 downto 0)));
				
			when ALU_SUB =>
				temp_sub := ("0" & unsigned(input1)) - ("0" & unsigned(input2));
				output <= std_logic_vector(unsigned(temp_sub(WIDTH-1 downto 0)));
				
			when ALU_MULT =>
				temp_mult := signed(input1) * signed(input2); 
				output <= std_logic_vector(signed(temp_mult(WIDTH-1 downto 0)));
				outputHi <= std_logic_vector(signed(temp_mult(WIDTH*2-1 downto WIDTH)));
			
			when ALU_MUL_UNSGINED =>
				temp_mult_unsigned := unsigned(input1) * unsigned(input2); 
				output <= std_logic_vector(unsigned(temp_mult_unsigned(WIDTH-1 downto 0)));
				outputHi <= std_logic_vector(unsigned(temp_mult_unsigned(WIDTH*2-1 downto WIDTH)));
			
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
			
			when ALU_SLT =>
				
					if( to_integer(signed(input1)) < to_integer(signed(input2))) then
						output <= "00000000000000000000000000000001";
					end if;
					
			when ALU_SLTU =>
				
					if( to_integer(unsigned(input1)) < to_integer(unsigned(input2))) then
						output <= "00000000000000000000000000000001";
					end if;
					
			when ALU_BEQ =>
				
				if (input1 = input2) then 
					branchTaken <= '1';
				end if;
				
			when ALU_BNE => 
			
				if (input1 = input2) then
					branchTaken <= '0';
				else 
					branchTaken <= '1';
				end if;
				
			when ALU_LTOEZ =>
				
				if (input1 <= zero) then 
					branchTaken <= '1';
				end if;
				
			when ALU_BGTZ =>
				
				if (input1 > zero) then 
					branchTaken <= '1';
				end if;
				
			when ALU_JR => 
				temp_add := ("0" & unsigned(input1)) + ("0" & unsigned(input2));
				output <= std_logic_vector(unsigned(temp_add(WIDTH-1 downto 0)));
							
			when others =>
				temp_add := ("0" & unsigned(input1)) + ("0" & unsigned(input2));
				output <= std_logic_vector(unsigned(temp_add(WIDTH-1 downto 0)));
				
		end case;
		
	end process;
end BHV;
