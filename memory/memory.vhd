library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  generic (WIDTH : positive := 32);
  port (
	 -- Inputs
		clock        : in  std_logic;
		MemRead      : in  std_logic;
		MemWrite     : in  std_logic;
	 
		inPort1_en   : in  std_logic;
		inPort2_en   : in  std_logic;
	 
		inPort1      : in std_logic_vector(WIDTH-1 downto 0);
		inPort2      : in std_logic_vector(WIDTH-1 downto 0);
	 
		address      : in std_logic_vector(WIDTH-1 downto 0);
		cpu_input    : in std_logic_vector(WIDTH-1 downto 0);
	 
		-- Outputs
		instruction  : out std_logic_vector(WIDTH-1 downto 0);
		output       : out std_logic_vector(WIDTH-1 downto 0)
	 );
end memory;

architecture STR of memory is
	
	-- RAM
	signal data_to_ram : std_logic_vector(WIDTH-1 downto 0);
	signal data_from_ram : std_logic_vector(WIDTH-1 downto 0);
	signal ram_write_en : std_logic;
	
	-- IO
	signal inPort1Out : std_logic_vector(WIDTH-1 downto 0);
	signal inPort2Out : std_logic_vector(WIDTH-1 downto 0);
	
	-- IOs or Ram Address Select
	signal address_select : std_logic_vector(1 downto 0);
	
begin 
	
	ram_write_en <= (not MemRead and MemWrite);
	instruction <= data_from_ram;

	RAM: entity work.ram
		port map (
			clock     => clock,
			address 	 => address(7 downto 0),
			data      => data_to_ram,
			q			 => data_from_ram,
			wren      => ram_write_en
		);	
		
	IOPort1 : entity work.ioport
		port map (
			clk    => clock,
			en     => inPort1_en,
			input  => inPort1,
			output => inPort1Out
		);
		
	IOPort2 : entity work.ioport
		port map (
			clk    => clock,
			en     => inPort2_en,
			input  => inPort2,
			output => inPort2Out
		);
	
	IOPortOut : entity work.ioport
		generic map(WIDTH => 32)
		port map (
			clk    => clock,
			en     => MemWrite,
			input  => cpu_input,
			output => output
		);
	 	 
	
end STR;
