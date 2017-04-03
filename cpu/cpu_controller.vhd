library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_controller is
  generic (WIDTH : positive := 32);
  port (
		-- Inputs
		clock       : in std_logic;
		rst         : in std_logic;
		opcode      : in  std_logic_vector(5 downto 0);
		
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
			S_INSTRUCTION_FETCH,
			S_INSTRUCTION_DECODE,
			S_MEMORY_ADDRESS,
		   S_RTYPE_EXECUCTION, S_RTYPE_COMPLETION,
			S_BRANCH_COMPLETION,
			S_JUMP_COMPLETION,
			S_ITYPE_EXECUTION
	);
	
	signal currentState, nextState : STATE_TYPE;
	
begin 
		
		process(clock, rst)
		begin 
			
			if( rst = '1') then
				currentState <= S_INSTRUCTION_FETCH;
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
			
				when S_INSTRUCTION_FETCH =>
					
				 MemRead <= '1'; -- enable read from memory
				 IorD    <= '0'; -- select address from pc
				 IRWrite <= '1'; -- enable instruction register
				 PCWrite <= '1'; -- enable pc
				 PCSource <= "00"; -- select alu result
				 
				 ALUSrcA <= "00"; -- select pc address
				 ALUSrcB <= "01"; -- select four 
				 ALUOp <= (others => '0'); -- set op code to R-Type
				 
				 nextState <= S_INSTRUCTION_FETCH;
				
				when S_INSTRUCTION_DECODE =>
				
				 ALUSrcA <= "00"; -- select pc address
				 ALUSrcB <= "11"; -- select four 
				 ALUOp <= (others => '0'); -- set op code to R-Type
				
				 nextState <= S_INSTRUCTION_FETCH;
				
				when others => null;
				
			
			end case;
		
		end process;
		
		
	 
end STR;