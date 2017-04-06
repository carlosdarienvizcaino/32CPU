library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_lib.all;

entity cpu_controller is
  generic (WIDTH : positive := 32);
  port (
		-- Inputs
		clock       : in std_logic;
		rst         : in std_logic;
		opcode      : in  std_logic_vector(5 downto 0);
		IR5to0      : in  std_logic_vector(5 downto 0);
		
		-- Outputs
		PcWriteCond   : out std_logic;
		PcWrite       : out std_logic;
		IorD          : out std_logic;
		MemRead       : out std_logic;
		MemWrite      : out std_logic;
		MemToReg      : out std_logic;
		IRWrite       : out std_logic;
		
		JumAndLink    : out std_logic;
		IsSigned      : out std_logic;
		PcSource      : out std_logic_vector(1 downto 0);
		ALUOp         : out std_logic_vector(5 downto 0);
		ALUSrcB       : out std_logic_vector(1 downto 0);
		ALUSrcA       : out std_logic_vector(1 downto 0);
		RegWrite      : out std_logic;
		RegDst        : out std_logic
	 );
end cpu_controller;

architecture STR of cpu_controller is
	
	
	type STATE_TYPE is (
			S_START,
			S_INSTRUCTION_FETCH,
			S_INSTRUCTION_DECODE,
			S_MEMORY_ADDRESS, S_LW_MEMORY_ACCESS, S_SW_MEMORY_ACCESS, S_MEMORY_ACCESS_COMPUTATION, S_MEMORY_READ_COMPLETION,
		   	S_RTYPE_EXECUCTION, S_RTYPE_COMPLETION,
			S_BRANCH_COMPLETION,
			S_JUMP_COMPLETION,
			S_ITYPE_EXECUTION, S_ITYPE_COMPLETION,
			S_SHIFT_EXECUTION, S_SHIFT_COMPLETION
	);
	
	signal currentState, nextState : STATE_TYPE;
	
begin 
		
		process(clock, rst)
		begin 
			
			if( rst = '1') then
				currentState <= S_START;

			elsif (clock'event and clock = '1') then 
				currentState <= nextState;
			end if;
		
		end process;
		
		process(currentState, opcode)
		begin 
			
			-- Defaults
			nextState <= currentState;
			-- Outputs
			PcWriteCond <= '0';
			PcWrite <= '0';
			IorD <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			MemToReg <= '0';
			IRWrite <= '0';
		
			JumAndLink <= '0';
			IsSigned <= '0';
			PcSource <= "00";
			ALUOp <= opcode;
			ALUSrcB <= "00";
			ALUSrcA <= "00";
			RegWrite <= '0';
			RegDst <= '0';

			
			case currentState is

				-- Start	
				when S_START =>

				nextState <= S_INSTRUCTION_FETCH;
				
				-- Fetch
				when S_INSTRUCTION_FETCH =>
					
				 MemRead <= '1'; -- enable read from memory
				 IorD    <= '0'; -- select address from pc
				 IRWrite <= '1'; -- enable instruction register
				 PCWrite <= '1'; -- enable pc
				 PCSource <= "00"; -- select alu result
				 
				 ALUSrcA <= "00"; -- select pc address
				 ALUSrcB <= "01"; -- select four 
				 ALUOp <= "100001";
				 --ALUOp <= (others => '0'); -- set op code to R-Type
				 
				 nextState <= S_INSTRUCTION_DECODE;
				
				when S_INSTRUCTION_DECODE =>
				
				 -- Disable PC increment
				 PcWriteCond <= '0';
				 PcWrite <= '0';
				 
				 ALUSrcA <= "00"; -- select pc address
				 ALUSrcB <= "11"; -- select four 
				 ALUOp <= (others => '0'); -- set op code to R-Type
				
					-- LW	
					 if (opcode = "100011") then 
						nextState <= S_MEMORY_ACCESS_COMPUTATION;
					
					-- SW
					 elsif (opcode = "101011") then 
						nextState <= S_MEMORY_ACCESS_COMPUTATION;
						
					-- SHIFT LEFT LOGIC
					elsif (opcode = RTYPE and IR5to0 = ALU_SLL ) then 
						nextState <= S_SHIFT_EXECUTION;
						
					-- SHIFT RIGHT LOGIC
					elsif (opcode = RTYPE and IR5to0 = ALU_SRL ) then 
						nextState <= S_SHIFT_EXECUTION;
						
					-- SHIFT RIGHT ARITHMETIC
					elsif (opcode = RTYPE and IR5to0 = ALU_SRA ) then 
						nextState <= S_SHIFT_EXECUTION;
						
					-- RTYPE
					 elsif(opcode = "000000") then
						nextState <= S_RTYPE_EXECUCTION;
						
					-- JUMP COMPLETION
					 elsif(opcode = "000010") then
						nextState <= S_JUMP_COMPLETION;
						
					
					 else 	
						nextState <= S_ITYPE_EXECUTION;		
					 end if;

         
			
			-- MEMORY ACCESS --- -- MEMORY ACCESS --- -- MEMORY ACCESS --- -- MEMORY ACCESS --- -- MEMORY ACCESS ---
				 when S_MEMORY_ACCESS_COMPUTATION =>
					
					-- Common Add offset plus base

					-- Get base from RegA
					ALUSrcA <= "10";

					-- Get offset
					ALUSrcB <= "10";

					-- Add instruction using addi
					ALUOp <= "100001";

					-- LW
				 	if (opcode = "100011") then 
						nextState <= S_LW_MEMORY_ACCESS;

					else
						nextState <= S_SW_MEMORY_ACCESS;

					end if;

				when S_LW_MEMORY_ACCESS  =>
				 	
					-- Select ALU output as adress
					IorD <= '1';

					-- Enable reading from memory
				    MemRead <= '1';
					 
					-- Dont write to register in order to keep 
					IRWrite <= '0';

					nextState <= S_MEMORY_READ_COMPLETION;
					
				when S_MEMORY_READ_COMPLETION  =>
				 
				 	-- Wait for memory register to load

					--nextState <= S_WIRTE_TO_REGISTER_FILE;
					
					-- Select destination register
					RegDst <= '0';
					
					-- Select Memory to register
					MemToReg <= '1';
					
					-- Enable writing to register file
					RegWrite <= '1';
					
					nextState <= S_INSTRUCTION_FETCH;
					
						
				when S_SW_MEMORY_ACCESS  =>
				 	
					nextState <= S_INSTRUCTION_FETCH;
					
				-- MEMORY ACCESS --- -- MEMORY ACCESS --- -- MEMORY ACCESS --- -- MEMORY ACCESS --- -- MEMORY ACCESS ---
				
				
				-- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE --
				when  S_RTYPE_EXECUCTION=>

					-- Select Register file output a
					ALUSrcA <= "10";

					-- Select Register file output b
					ALUSrcB <= "00";
					
					-- Tell ALU controller this is an ITYPE
					ALUOp <= opcode;

					nextState <= S_RTYPE_COMPLETION;
					
				when  S_RTYPE_COMPLETION=>

					-- Select destination register 
					RegDst <= '1';


					-- Select ALUOutput
					MemToReg <= '0';

					-- Enable Writing to register file
					RegWrite <= '1';

					nextState <= S_INSTRUCTION_FETCH;
				-- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE -- -- RTYPE --
				
				

				-- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE --


				when S_ITYPE_EXECUTION => 

					-- Select Register file output a
					ALUSrcA <= "10";

					-- Select immediate value 
					ALUSrcB <= "10";
					
					-- Tell ALU controller this is an RTYPE
					ALUOp <= opcode;
				
					nextState <= S_ITYPE_COMPLETION;
				
				when S_ITYPE_COMPLETION =>

					-- Select destination register 
					RegDst <= '0';


					-- Select ALUOutput
					MemToReg <= '0';

					-- Enable Writing to register file
					RegWrite <= '1';

					nextState <= S_INSTRUCTION_FETCH;
				
					-- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE -- -- ITYPE --
					
					
					-- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT --
					when S_SHIFT_EXECUTION =>
						
						-- Select shift amount
						ALUSrcA <= "01";
						
						-- Select RegB
						ALUSrcB <= "00";
						
						-- Send Opcode to ALUController
						ALUOp <= opcode;
						
						nextState <= S_SHIFT_COMPLETION;
						
					when S_SHIFT_COMPLETION =>
					
						-- Select distination register 15-11 for register file address
						RegDst <= '1';
						
						-- Select ALU ouput for register file data
						MemToReg <= '0';
						
						-- Enable Writing to Register File
						RegWrite <= '1';
					
						nextState <= S_INSTRUCTION_FETCH;
				
					-- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT -- -- SHIFT --
				
					-- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION --
					when S_JUMP_COMPLETION => 
					
					-- Enable PC 
					PCWrite <= '1';
					PCWriteCond <= '1';
					
					-- Select Jump Address
					PCSource <= "10";
					
					nextState <= S_INSTRUCTION_FETCH;
					
				-- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION --
				when others => null;
				
			
			end case;
		
		end process;
		
		
	 
end STR;
