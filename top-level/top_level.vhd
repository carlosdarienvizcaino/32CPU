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
	
	signal internalInPort1 : std_logic_vector(WIDTH-1 downto 0) := "000000000000000000000000" & inPort1;
	signal internalInPort2 : std_logic_vector(WIDTH-1 downto 0) := "000000000000000000000000" & inPort2;
	
begin 

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
			clock     => clock,
			rst       => rst,
			instruction => instruction,
			address 	 => address,
			
			-- Outputs
			MemRead   => MemRead,
			MemWrite  => MemWrite,
			output    => cpu_input
		);	

	 
end STR;