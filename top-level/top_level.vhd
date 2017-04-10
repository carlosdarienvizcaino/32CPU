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
		 
		 inPort : in std_logic_vector(9 downto 0);
		
		 
		 -- Outputs
		 led0     : out std_logic_vector(6 downto 0);
		 led1     : out std_logic_vector(6 downto 0);
		 led2     : out std_logic_vector(6 downto 0);
		 led3     : out std_logic_vector(6 downto 0)
	 );
end top_level;

architecture STR of top_level is
	
	signal MemRead : std_logic;
	signal MemWrite : std_logic;
	
	signal address : std_logic_vector(WIDTH -1 downto 0);
	signal cpu_input : std_logic_vector(WIDTH -1 downto 0);
	signal instruction : std_logic_vector(WIDTH -1 downto 0);
	
	signal internalInPort : std_logic_vector(WIDTH-1 downto 0);
	
	signal memory_output : std_logic_vector(WIDTH-1 downto 0);
	
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
		 
		   inPort1     => internalInPort,
		   inPort2     => internalInPort,
		 
		   address     => address,
		   cpu_input   => cpu_input,
		 
			-- Outputs
		   instruction  => instruction,
		   output      => memory_output
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
	
	NIBBLE1: entity work.decoder7seg
		port map(
				input  => memory_output(3 downto 0),
            output => led0
			);
			
	NIBBLE2: entity work.decoder7seg
		port map(
				input  => memory_output(7 downto 4),
            output => led1
			);
	
	NIBBLE3: entity work.decoder7seg
		port map(
				input  => memory_output(11 downto 8),
            output => led2
			);
			
	NIBBLE4: entity work.decoder7seg
		port map(
				input  => memory_output(15 downto 12),
				output => led3
			);
	
	internalInPort <= "0000000000000000000000" & inPort;

end STR;
