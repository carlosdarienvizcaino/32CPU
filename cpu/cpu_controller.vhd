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
			S_SHIFT_EXECUTION, S_SHIFT_COMPLETION,
			S_MOVE_EXECUTION,
			S_BRANCH_CONDITION_EXECUTION, S_BRANCH_CONDITION_COMPLETION,
			S_JUMP_AND_LINK_EXCECUTION, S_JUMP_AND_LINK_COMPLETION,
			S_JUMP_REGISTER_COMPLETION,
			S_REGISTER_COMPARE_EXECUTION, S_REGISTER_COMPARE_COMPLETION, S_IMMEDIATE_COMPARE_EXECUTION, S_IMMEDIATE_COMPARE_COMPLETION
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
					 if (opcode = ALU_LW) then 
						nextState <= S_MEMORY_ACCESS_COMPUTATION;
					
					-- SW
					 elsif (opcode = ALU_SW) then 
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
						
					-- SET ON LESS THAN SINGED
					elsif (opcode = RTYPE and IR5to0 = ALU_SLT ) then 
						nextState <= S_REGISTER_COMPARE_EXECUTION;
						
					-- SET ON LESS THAN UNSIGED
					elsif (opcode = RTYPE and IR5to0 = ALU_SLTU ) then 
						nextState <= S_REGISTER_COMPARE_EXECUTION;
						
					-- SET ON LESS THAN IMMEDIATE SINGED
					elsif (opcode = ALU_SLTI) then 
						nextState <= S_IMMEDIATE_COMPARE_EXECUTION;
						
					-- SET ON LESS THAN IMMEDIATE UNSIGED
					elsif (opcode = ALU_SLTIU) then 
						nextState <= S_IMMEDIATE_COMPARE_EXECUTION;
						
					-- MOVE FROM HI
					elsif (opcode = RTYPE and IR5to0 = ALU_MFHI ) then 
						nextState <= S_MOVE_EXECUTION;
					
					-- MOVE FROM LOW
					elsif (opcode = RTYPE and IR5to0 = ALU_MFLO  ) then 
						nextState <= S_MOVE_EXECUTION;
						
					-- JUMP REGISTER
					elsif (opcode = RTYPE and IR5to0 = ALU_JR  ) then 
						-- Send opcode to ALU Controller
						ALUOp <= ALU_JR;
						
						nextState <= S_JUMP_REGISTER_COMPLETION;
						
					-- RTYPE
					 elsif(opcode = RTYPE) then
						nextState <= S_RTYPE_EXECUCTION;
						
					-- BRANCH CONDITIONS
					elsif (opcode = ALU_BEQ or opcode = ALU_BNE) then 
						nextState <= S_BRANCH_CONDITION_EXECUTION;
						
					-- JUMP COMPLETION
					 elsif(opcode = ALU_JTA) then
						nextState <= S_JUMP_COMPLETION;
						
					-- JUMP AND LINK
					 elsif(opcode = ALU_JNL) then
						
						-- Select lower 25 bits
						RegDst <= '0';
						
						-- Select alu output which is PC+4
						MemToReg <= '0';
						
						-- set jump and link 
						JumAndLink <= '1';
						
						nextState <= S_JUMP_AND_LINK_EXCECUTION;
						
					
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
				 	if (opcode = ALU_LW) then 
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
				
					-- Select ALU Output as memory address
					IorD <= '1';
					
					-- Enable Writing to memeory
					MemWrite <= '1';
				 	
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
					
					
					if (IR5to0 = ALU_MULT or IR5to0 = ALU_MUL_UNSGINED) then 
						RegWrite <= '0';
					else 
						-- Enable Writing to register file
						RegWrite <= '1';
					end if;
					
					-- Send a dummy signal to ALU Controller so it disables LAU ouputs registers
					ALUOp <= (others => '1');

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
					
					-- Send a dummy signal to ALU Controller so it disables LAU ouputs registers
					ALUOp <= (others => '1');

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
					
					
					-- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE --
					when S_MOVE_EXECUTION =>
					
						-- Select destination register 15 -11
						RegDst <= '1';
						
						-- Select ALU Mux output 
						MemToReg <= '0';
						
						-- Enable writing to register file 
						RegWrite <= '1';
						
						nextState <= S_INSTRUCTION_FETCH;
					-- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE -- -- MOVE --
					
					
					-- CONDITIONAL BRANCHING --  -- CONDITIONAL BRANCHING -- -- CONDITIONAL BRANCHING -- 
					when S_BRANCH_CONDITION_EXECUTION =>
						
						-- PC = PC + 4 + OFFSET
						-- ALUOp 
						ALUOp <= ALU_ADD_SIGNED;
						
						-- Select PC+4
						ALUSrcA <= "00";
						
						-- Select Offset shift lefted by 2
						ALUSrcB <= "11";
						
						isSigned <= '1';
						
						nextState <= S_BRANCH_CONDITION_COMPLETION;
						
						
					when S_BRANCH_CONDITION_COMPLETION =>
						
						ALUOp <= opcode;
					
						-- Select RegA
						ALUSrcA <= "10";
						
						-- Select RegB
						ALUSrcB <= "00";
					
						-- Set PCWriteConditin
						PCWriteCond <= '1';
						
						-- Select offset shift left by 2
						PCSource <= "01";
						
						nextState <= S_INSTRUCTION_FETCH;
						
					-- CONDITIONAL BRANCHING -- -- CONDITIONAL BRANCHING -- -- CONDITIONAL BRANCHING -- 	
				
					-- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION --
					when S_JUMP_COMPLETION => 
					
					-- Enable PC 
					PCWrite <= '1';
					PCWriteCond <= '1';
					
					-- Select Jump Address
					PCSource <= "11";
					
					nextState <= S_INSTRUCTION_FETCH;
					
					when S_JUMP_AND_LINK_EXCECUTION =>
						
						-- Select lower bits as next PC 
						PCSource <= "10";
						
						-- Enable PC to be updated
						PCWrite <= '1';
						
						nextState <= S_INSTRUCTION_FETCH;
						
					when S_JUMP_AND_LINK_COMPLETION =>
					
						
						nextState <= S_INSTRUCTION_FETCH;
						
					
					when S_JUMP_REGISTER_COMPLETION =>
						
						-- Select RegA
						ALUSrcA <= "10";
						
						-- Select RegB
						ALUSrcB <= "00";
						
						-- Select ALUOuput for PC
						PCSource <= "00";
						
						-- Enable writing to PC
						PCWrite <= '1';
						
						nextState <= S_INSTRUCTION_FETCH;

					
				-- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION -- -- JUMP COMPLETION --
				
				-- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE --
				
				when S_REGISTER_COMPARE_EXECUTION =>
						
						-- Select RegA
						ALUSrcA <= "10";
						
						-- Select RegB
						ALUSrcB <= "00";
						
						if (IR5to0 = ALU_SLT) then
							isSigned <= '1';
						end if;
						
						nextState <= S_REGISTER_COMPARE_COMPLETION;
						
			   when S_REGISTER_COMPARE_COMPLETION => 
						
						-- Save ALU Result in destination register 
						MemToReg <= '0';
						
						-- Select Register destination 15-11
						RegDst <= '1';
						
						-- Enable writing to register file
						RegWrite <= '1';
						
						nextState <= S_INSTRUCTION_FETCH;
						
						
				
				when S_IMMEDIATE_COMPARE_EXECUTION =>
					
						-- Select RegA
						ALUSrcA <= "10";
						
						-- Select Signed Extended
						ALUSrcB <= "10";
						
						if (opcode  = ALU_SLTI) then 
							isSigned <= '1';
						end if;
						
						nextState <= S_IMMEDIATE_COMPARE_COMPLETION;
						
						
				when S_IMMEDIATE_COMPARE_COMPLETION => 
						
						-- Save ALU Result in destination register 
						MemToReg <= '0';
						
						-- Select Register destination 20-16
						RegDst <= '0';
						
						-- Enable writing to register file
						RegWrite <= '1';
						
						nextState <= S_INSTRUCTION_FETCH;
						
			
				
						
				-- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE -- -- COMPARE --
				
				
				when others => null;
				
			
			end case;
		
		end process;
		
		
	 
end STR;
