library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
  generic (WIDTH : positive := 32);
  port (
		 -- Inputs
		 clock      : in  std_logic;
		 rst   		: in  std_logic;
		 
		 inPort1_en : in std_logic;
		 inPort2_en : in std_logic;
		 
		 inPort1 : in std_logic_vector(7 downto 0);
		 inPort2 : in std_logic_vector(7 downto 0);
		 
		 -- Outputs
		 output : out std_logic_vector(WIDTH-1 downto 0)
	 );
end top_level;

architecture STR of top_level is
	
	signal MemRead : std_logic;
	signal MemWrite : std_logic;
	
	signal address : std_logic_vector(WIDTH -1 downto 0);
	signal cpu_input : std_logic_vector(WIDTH -1 downto 0);
	signal instruction : std_logic_vector(WIDTH -1 downto 0);
	
	signal internalInPort1 : std_logic_vector(WIDTH-1 downto 0);
	signal internalInPort2 : std_logic_vector(WIDTH-1 downto 0);
	
	signal cpu_clck : std_logic;
	
	constant CLOCK_FREQUENCY : natural := 500000000;
	
begin 

	CPU_CLOCK : entity work.clk_div
	generic map(
		clk_in_freq  => CLOCK_FREQUENCY,      
      clk_out_freq => CLOCK_FREQUENCY/2
	)
	port map(
		  clk_in  => clock,
        clk_out => cpu_clck,
        rst     => rst
	);

	MEMORY: entity work.memory
		port map (
			-- Inputs
			clock       => clock,
			MemRead     => MemRead,
			MemWrite    => MemWrite,
		 
			inPort1_en  => inPort1_en,
			inPort2_en  => inPort2_en,
		 
		   inPort1     => internalInPort1,
		   inPort2     => internalInPort2,
		 
		   address     => address,
		   cpu_input   => cpu_input,
		 
			-- Outputs
		   instruction  => instruction,
		   output      => output
		);	
		
	CPU: entity work.cpu
		port map (
			-- Inputs
			clock     => cpu_clck,
			rst       => rst,
			instruction => instruction,
			
			-- Outputs
			address 	 => address,
			MemRead   => MemRead,
			MemWrite  => MemWrite,
			output    => cpu_input
		);	

	
	internalInPort1 <= "000000000000000000000000" & inPort1;
	internalInPort2 <= "000000000000000000000000" & inPort2;
	
	 
end STR;
