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
	signal ram_write_en : std_logic := '0';
	
	-- IO
	signal inPort1Out : std_logic_vector(WIDTH-1 downto 0);
	signal inPort2Out : std_logic_vector(WIDTH-1 downto 0);
	
	-- IOs or Ram Address Select
	signal address_select : std_logic_vector(1 downto 0);
	
begin 

	RAM: entity work.ram
		port map (
			clock     => clock,
			address 	 => address(9 downto 2),
			data      => data_to_ram,
			q			 => data_from_ram,
			wren      => ram_write_en
		);	
		
   READ_ADDRESS_MAPPER: entity work.address_mapper
		port map(
			input_address => address,
			output => address_select
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
	 	 
	 process(address)
	 begin
		
		instruction <= std_logic_vector(to_unsigned(4, 32));
		
		if( address = to_stdlogicvector(x"0000FFF8")) then 
				instruction <= inPort1Out;
				
		elsif (address = to_stdlogicvector(x"0000FFFC")) then
				instruction <= inPort2Out;
				
		else 
				instruction <= data_from_ram;
		
		end if;
	 end process;
	 
	 process(MemRead, MemWrite)
	 begin
		
		if (MemRead = '1') then
			ram_write_en <= '0';
			
		elsif (MemWrite = '1') then
			ram_write_en <= '1';
			
		end if;
	 end process;
	
end STR;