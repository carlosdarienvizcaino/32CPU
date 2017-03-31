library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_tb is
end memory_tb;

architecture TB of memory_tb is

    constant WIDTH  : positive                           := 32;
    signal clk  : std_logic := '0';
	 signal MemRead   : std_logic;
	 signal MemWrite   : std_logic;
		 
	 signal inPort1_en : std_logic;
	 signal inPort2_en : std_logic;
		 
	 signal inPort1 :  std_logic_vector(7 downto 0);
	 signal inPort2 :  std_logic_vector(7 downto 0);
		 
	 signal address:  std_logic_vector(WIDTH-1 downto 0);
	 signal Reg_B: std_logic_vector(WIDTH-1 downto 0);
		 
	 signal instructionRegisterOutput : std_logic_vector(WIDTH-1 downto 0);
	 signal output : std_logic_vector(WIDTH-1 downto 0);

begin  -- TB

      UUT : entity work.memory
        generic map (WIDTH => WIDTH)
        port map (
            clk_50MHz  => clk,
				
				MemRead   => MemRead,
				MemWrite   => MemWrite,
		 
				inPort1_en => inPort1_en,
				inPort2_en => inPort2_en,
		 
				inPort1    => inPort1,
				inPort2    => inPort2,
		 
				address    => address,
				Reg_B      => Reg_B,
		 
				instructionRegisterOutput => instructionRegisterOutput,
				output  => output
			);
			
			clk <= not clk after 10 ns;
			
    process
    begin
	 
		-- Test Load and Read input 1
			inPort1_en <= '1';
			inPort1 <= std_logic_vector(to_unsigned(2, 8));
			address <= to_stdlogicvector(x"0000FFF8");
			wait until clk = '1';
			wait for 40 ns;
			assert(output = inPort1) report "Error inport 1 is not been loaded";
			
		-- Test Load and Read input 2
			inPort2_en <= '1';
			inPort2 <= std_logic_vector(to_unsigned(2, 8));
			address <= to_stdlogicvector(x"0000FFFC");
			wait until clk = '1';
			wait for 40 ns;
			assert(output = inPort1) report "Error inport 2 is not been loaded";
			
		-- Test read RAM
			for i in 0 to WIDTH-1 loop
					MemRead <= '1';
					address <= std_logic_vector(to_unsigned(i, 32));
					wait until clk = '1';
					wait for 40 ns;
			end loop;
		
		-- Given MemRead is enableand address is 0
		-- When Clock rises 
		-- Then Then output is not
	
	 
		
		report "SIMULATION FINISHED!";
      wait;
		
    end process;



end TB;