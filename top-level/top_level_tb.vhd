library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.alu_lib.all;

entity top_level_tb is
end top_level_tb;

architecture TB of top_level_tb is

    constant WIDTH  : positive                           := 32;
	 constant INPORT_WIDTH : positive := 10;
	 
	 signal clock : std_logic := '0';
	 signal rst : std_logic := '0';
	 
	 signal inPort1_en : std_logic := '0';
	 signal inPort2_en : std_logic := '0';
	 
    signal inPort   : std_logic_vector(9 downto 0) := (others => '0');
	 
	 signal led0     :  std_logic_vector(6 downto 0);
	 signal led1     :  std_logic_vector(6 downto 0);
	 signal led2     :  std_logic_vector(6 downto 0);
	 signal led3     :  std_logic_vector(6 downto 0);
	 
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
		 
		  inPort => inPort,
		 
		  -- Outputs
		 led0     => led0,
		 led1     => led1,
		 led2     => led2,
		 led3     => led3
	 );
	 
    clock <= not clock after 10 ns;

    process
    begin
			
			-- Reset everything
			rst <= '0'; -- reset true
			wait until clock = '1';
			wait for 40 ns;
			rst <= '1';
	 
		-- Disable all enables by setting them to high
			rst <= '0';
			inPort1_en <= '1';
		   inPort2_en <= '1';
			
			-- Add list size
			wait for 40 ns;
			inPort1_en <= '0'; -- enable port 1
			inPort2_en <= '1';
			inPort <= conv_std_logic_vector(3, INPORT_WIDTH);
			
			
			-- Set first entry
			wait for 40 ns;
			inPort1_en <= '1'; -- enable port 2
			inPort2_en <= '0';
			inPort <= conv_std_logic_vector(4, INPORT_WIDTH);
			
			-- Start program
			rst <= '0'; -- reset true
			wait until clock = '1';
			wait for 40 ns;
			rst <= '1';
			
			-- Set second entry
			wait for 2000 ns;
			inPort1_en <= '1'; -- enable port 2
			inPort2_en <= '0';
			inPort <= conv_std_logic_vector(1, INPORT_WIDTH);
			
			-- Set third entry
			wait for 500 ns;
			inPort1_en <= '1'; -- enable port 2
			inPort2_en <= '0';
			inPort <= conv_std_logic_vector(2, INPORT_WIDTH);
	 
		report "SIMULATION FINISHED!";
      wait;
		
    end process;



end TB;