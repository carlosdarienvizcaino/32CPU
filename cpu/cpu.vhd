library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
  generic (WIDTH : positive := 32);
  port (
		-- Inputs
		clock       : in std_logic;
		rst         : in std_logic;
		instruction : in std_logic_vector(WIDTH-1 downto 0);
		
		-- Outputs
		address   : out std_logic_vector(WIDTH-1 downto 0);
		MemRead   : out std_logic;
		MemWrite  : out std_logic;
		output    : out std_logic_vector(WIDTH-1 downto 0)
	 );
end cpu;

architecture STR of cpu is
	
	-- Controller Signals
	signal instruction_opcode : std_logic_vector(5 downto 0);
	
	signal PcWriteCond : std_logic;
	signal PcWrite : std_logic;
	signal IorD : std_logic;
	signal MemToReg : std_logic;
	signal IRWrite : std_logic;
	
	signal JumAndLink : std_logic;
	signal IsSigned : std_logic;
	signal PcSource : std_logic_vector(1 downto 0);
	signal ALUOp : std_logic_vector(5 downto 0);
	signal ALUSrcB : std_logic_vector(1 downto 0);
	signal ALUSrcA :std_logic_vector(1 downto 0);
	signal RegWrite : std_logic;
	signal RegDst : std_logic;
	
	signal MemReadOut : std_logic;
	signal MemWriteOut : std_logic;
	
	-- Instruction Registers
	signal source_register : std_logic_vector(4 downto 0);
	signal target_register : std_logic_vector(4 downto 0);
	signal destination_register : std_logic_vector(5 downto 0);
	signal instruction_lower_bits : std_logic_vector(15 downto 0);
	
	signal data_register_output : std_logic_vector(WIDTH-1 downto 0);
	-- Register file
	signal read_data1_output : std_logic_vector(WIDTH-1 downto 0);
	signal read_data2_output : std_logic_vector(WIDTH-1 downto 0);
	
	-- Singed Extend
	signal signed_extend_output : std_logic_vector(WIDTH-1 downto 0);
	
	-- ALU MUX Input 1
	signal error : std_logic_vector(WIDTH-1 downto 0) := (others => '1');
	signal alu_mux1_output : std_logic_vector(WIDTH-1 downto 0);
	signal alu_mux1_mux_in1: std_logic_vector(WIDTH-1 downto 0);
	signal alu_mux1_mux_in2: std_logic_vector(WIDTH-1 downto 0);
	
	-- ALU MUX Input 2
	signal four : std_logic_vector(WIDTH-1 downto 0) := std_logic_vector(to_unsigned(4, WIDTH));
	signal alu_mux2_output : std_logic_vector(WIDTH-1 downto 0);
	signal alu_mux2_mux_in4 : std_logic_vector(WIDTH-1 downto 0);

	-- ALU Registers
	signal alu_output : std_logic_vector(WIDTH-1 downto 0);
	signal alu_output_Hi : std_logic_vector(WIDTH-1 downto 0);
	signal alu_reg_output : std_logic_vector(WIDTH-1 downto 0); 
	signal alu_low_reg_output : std_logic_vector(WIDTH-1 downto 0);
	signal alu_hi_reg_output : std_logic_vector(WIDTH-1 downto 0);
	signal alu_mux_output : std_logic_vector(WIDTH-1 downto 0);
	signal branchTaken : std_logic;
	
	-- ALU Controller
	signal OpSelect : std_logic_vector(5 downto 0);
	signal HI_en : std_logic;
	signal LO_en : std_logic;
	signal ALU_LO_HI : std_logic_vector(1 downto 0);
	
	-- PC 
	signal pc_enable : std_logic;
	signal pc_output : std_logic_vector(WIDTH-1 downto 0);
	signal pc_mux_mux_in3 : std_logic_vector(WIDTH-1 downto 0);
	signal pc_mux_mux_in4 : std_logic_vector(WIDTH-1 downto 0);
	
	signal write_register_mux_output : std_logic_vector(4 downto 0);
	signal memory_data_mux_output : std_logic_vector(WIDTH-1 downto 0);
	
	signal regA_output : std_logic_vector(WIDTH-1 downto 0);
	signal regB_output : std_logic_vector(WIDTH-1 downto 0);
	signal alu_high_reg_output : std_logic_vector(WIDTH-1 downto 0);
	signal pc_output_mux : std_logic_vector(WIDTH-1 downto 0);
	signal address_output : std_logic_vector(WIDTH-1 downto 0);
	
	signal instr_index : std_logic_vector(25 downto 0);
	

begin 

	address <= address_output;
	output <= regB_output; 
	MemRead <= MemReadOut;
	MemWrite <= MemWriteOut;

	CONTROLLER: entity work.cpu_controller
		port map (
		-- Inputs
		clock       => clock,
		rst         => rst,
		opcode      => instruction_opcode,
		IR5To0 => instruction_lower_bits(5 downto 0),
		
		-- Outputs
		PcWriteCond   => PcWriteCond,
		PcWrite => PcWrite,
		IorD => IorD,
		MemRead => MemReadOut,
		MemWrite => MemWriteOut,
		MemToReg => MemToReg,
		IRWrite => IRWrite,
		
		JumAndLink => JumAndLink,
		IsSigned => IsSigned,
		PcSource => PcSource,
		ALUOp => ALUOp,
		ALUSrcB => ALUSrcB,
		ALUSrcA => ALUSrcA,
		RegWrite => RegWrite,
		RegDst => RegDst
		);
	
	INSTRUCTION_REGISTER: entity work.instruction_register
		port map (
		 -- Inputs
		 clock 		=> clock,  
		 rst        => rst,
		 input      => instruction,
		 IRWrite    => IRWrite,
		 
		 -- Outputs
		 output_25to0      => instr_index,
		 output_31to26     => instruction_opcode,
		 output_25to21     => source_register,
		 output_20to16     => target_register,
		 output_15to0      => instruction_lower_bits
		);
		
	REGISTER_FILE: entity work.register_file
		port map (
		 -- Inputs
		clock  => clock,
		rst  => rst,
		rd_addr0  => source_register,
		rd_addr1  => target_register,
		
		wr_addr  => write_register_mux_output,
		wr_data  => memory_data_mux_output,
		
		wr_en  => RegWrite,
		jump_and_link => JumAndLink,
		
		-- Outputs
		rd_data0  => read_data1_output,
		rd_data1  => read_data2_output
		);
		
	ALU: entity work.alu
		generic map(WIDTH => WIDTH)
		port map(
		-- Inputs
		input1   => alu_mux1_output,
		input2   => alu_mux2_output,
		opSelect => opSelect,
		
		-- Outputs
		output => alu_output,
		outputHi => alu_output_Hi,
		branchTaken => branchTaken
		);
	
	ALU_CONTROLLER: entity work.alu_controller
		port map(
			-- Inputs
			IR5To0 => instruction_lower_bits(5 downto 0),
			ALUOp => ALUOp,
			
			-- Outputs
			OpSelect => OpSelect,
			HI_en => HI_en,
			LO_en => LO_en,
			ALU_LO_HI => ALU_LO_HI
		);
		
	MEMORY_DATA: entity work.data_register
		generic map( WIDTH => 32)
		port map(
			-- Inputs
			rst => rst,
			clock => clock,
			input => instruction,
			
			-- Outputs
			output => data_register_output	
		);
		
	REGA: entity work.data_register
		generic map( WIDTH => 32)
		port map(
			-- Inputs
			rst => rst,
			clock => clock,
			input => read_data1_output,
			
			-- Outputs
			output => regA_output	
		);
		
	REGB: entity work.data_register
		generic map( WIDTH => 32)
		port map(
			-- Inputs
			rst => rst,
			clock => clock,
			input => read_data2_output,
			
			-- Outputs
			output => regB_output	
		);
	
	-- ALU REGISTERS -- -- ALU REGISTERS -- -- ALU REGISTERS --
	ALU_OUTPUT_REG: entity work.data_register
		generic map( WIDTH => 32)
		port map(
			-- Inputs
			rst => rst,
			clock => clock,
			input => alu_output,
			
			-- Outputs
			output => alu_reg_output	
		);
		
	ALU_LOW_REG: entity work.enable_data_register
		generic map( WIDTH => 32)
		port map(
			-- Inputs
			rst => rst,
			clock => clock,
			input => alu_output,
			enable => LO_en,
			
			-- Outputs
			output => alu_low_reg_output	
		);
		
	ALU_HI_REG: entity work.enable_data_register
		generic map( WIDTH => WIDTH)
		port map(
			-- Inputs
			rst => rst,
			clock => clock,
			input => alu_output_Hi,
			enable => HI_en,
			
			-- Outputs
			output => alu_high_reg_output	
		);
		
	-- PC -- 	-- PC --  	-- PC -- 
	PC: entity work.enable_data_register
		generic map( WIDTH => WIDTH)
		port map(
			-- Inputs
			rst => rst,
			clock => clock,
			input => pc_output_mux,
			enable => pc_enable,
			
			-- Outputs
			output => pc_output	
		);
		
		
	SIGNED_EXTEND: entity work.signed_extend
		port map(
			-- Inputs
			rst => rst,
			clock => clock,
			input => instruction_lower_bits,
			isSigned => isSigned,
			
			-- Outputs
			output => signed_extend_output
		);
	
	-- MUXES -- -- MUXES -- -- MUXES -- -- MUXES --
	ADDRESS_MUX: entity work.mux_2x1
	   generic map(WIDTH => WIDTH)
		port map (
		-- Inports
		mux_in1  => pc_output,
		mux_in2  => alu_reg_output,
		mux_sel  => IorD,
		
		-- Outputs
		mux_out  => address_output
		);
	
	WRITE_REGISTER_MUX: entity work.mux_2x1
		generic map(WIDTH => 5)
		port map (
		-- Inports
		mux_in1  => target_register,
		mux_in2  => instruction_lower_bits(15 downto 11),

		mux_sel  => RegDst,
		
		-- Outputs
		mux_out  => write_register_mux_output
		);
		
	MEMORY_DATA_MUX: entity work.mux_2x1
		port map (
		-- Inports
		mux_in1  => alu_mux_output,
		mux_in2  => data_register_output,
		mux_sel  => MemToReg,
		
		-- Outputs
		mux_out  => memory_data_mux_output
		);
		
		
	 ALU_MUX1: entity work.mux_4x2
	   generic map(WIDTH => WIDTH)
		port map (
		-- Inports
		mux_in1  => pc_output,
		mux_in2  => alu_mux1_mux_in2,
		mux_in3  => regA_output,
		mux_in4  => error,
		mux_sel  => ALUSrcA,
		
		-- Outputs
		mux_out  => alu_mux1_output
		);
		
	 ALU_MUX2: entity work.mux_4x2
	   generic map(WIDTH => WIDTH)
		port map (
		-- Inports
		mux_in1  => regB_output,
		mux_in2  => four,
		mux_in3  => signed_extend_output,
		mux_in4  => alu_mux2_mux_in4, 
		mux_sel  => ALUSrcB,
		
		
		-- Outputs
		mux_out  => alu_mux2_output
		);
		
	ALU_OUTPUT_MUX: entity work.mux_4x2
	   generic map(WIDTH => WIDTH)
		port map (
		-- Inports
		mux_in1  => alu_reg_output,
		mux_in2  => alu_low_reg_output,
		mux_in3  => alu_high_reg_output,
		mux_in4  => error,
		mux_sel  => ALU_LO_HI,
		
		-- Outputs
		mux_out  => alu_mux_output
		);
		
	PC_MUX: entity work.mux_4x2
	   generic map(WIDTH => WIDTH)
		port map (
		-- Inports
		mux_in1  => alu_output,
		mux_in2  => alu_reg_output,
		mux_in3  => pc_mux_mux_in3, 
		mux_in4  => pc_mux_mux_in4,
		mux_sel  => PCSource,
		
		-- Outputs
		mux_out  => pc_output_mux
		);-- MUXES -- -- MUXES -- -- MUXES -- -- MUXES --
	
		
		MemRead <= MemReadOut;
		MemWrite <= MemWriteOut;
		pc_enable <= (branchTaken and PCWriteCond) or PCWrite;

		alu_mux1_mux_in1 <= "0000000000000000000000000000" & pc_output(31 downto 28);
		alu_mux1_mux_in2 <= "000000000000000000000000000" & instruction_lower_bits(10 downto 6);


		alu_mux2_mux_in4  <= std_logic_vector(shift_left( unsigned(signed_extend_output), 2 ));
		pc_mux_mux_in3    <= "00000000000000" & instruction_lower_bits & "00";
		pc_mux_mux_in4   <=  "0000" & instr_index & "00";
		
end STR;
