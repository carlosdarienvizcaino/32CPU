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
	
	signal outport_enable : std_logic;
	
begin 
	
	ram_write_en <= (not MemRead and MemWrite);
	data_to_ram <= cpu_input;
	
	-- Output Port
	process(ram_write_en, address)
	begin 
		
		if (ram_write_en = '1' and address = std_logic_vector(to_unsigned(16#FFFC#, WIDTH))) then
			outport_enable <= '1';
		else
			outport_enable <= '0';
		end if;
	
	end process;
	
	process(address, data_from_ram, inPort1Out, inPort2Out ) 
	begin 
	
		-- IN PORT 1
		if(address = std_logic_vector(to_unsigned(16#FFF8#, WIDTH))) then
			instruction <= inPort1Out;
		-- IN PORT 2
		elsif (address = std_logic_vector(to_unsigned(16#FFFC#, WIDTH))) then
			instruction <= inPort2Out;
		-- RAM
		else 
			instruction <= data_from_ram;
		end if;
	
	end process;

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
			en     => outport_enable,
			input  => cpu_input,
			output => output
		);
	 	 
	
end STR;
