library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.alu_lib.all;

entity top_level_tb is
end top_level_tb;

architecture TB of top_level_tb is

    constant WIDTH  : positive                           := 32;
	 
	 signal clock : std_logic := '0';
	 signal rst : std_logic := '0';
	 
	 signal inPort1_en : std_logic := '0';
	 signal inPort2_en : std_logic := '0';
	 
    signal inPort1   : std_logic_vector(7 downto 0) := (others => '0');
    signal inPort2   : std_logic_vector(7 downto 0) := (others => '0');
	 
    signal output   : std_logic_vector(WIDTH-1 downto 0);
 
begin  -- TB

      UUT : entity work.top_level
        generic map (WIDTH => WIDTH)
        port map (
        -- Inputs
		  clock    => clock,
		  rst   	  => rst,
		 
		  inPort1_en => inPort1_en,
		  inPort2_en => inPort2_en,
		 
		  inPort1 => inPort1,
		  inPort2 => inPort2,
		 
		  -- Outputs
		  output  => output
	 );
	 
    clock <= not clock after 10 ns;

    process
    begin
			
			rst <= '1';
			wait until clock = '1';
			wait for 40 ns;
			rst <= '0';
			
			-- Test read RAM
			for i in 0 to WIDTH-1 loop
					--MemRead <= '1';
					--address <= std_logic_vector(to_unsigned(i, 32));
					wait until clock = '1';
					wait for 40 ns;
			end loop;
	 
		report "SIMULATION FINISHED!";
      wait;
		
    end process;



end TB;