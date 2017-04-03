library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_register is
  port (
  
		 clk_50MHz  : in  std_logic;
		 rst        : in std_logic;
		 input      : in std_logic_vector(31 downto 0);
		 output_31to26     : out std_logic_vector(5 downto 0);
		 output_25to21     : out std_logic_vector(3 downto 0);
		 output_20to16     : out std_logic_vector(3 downto 0);
		 output_15to0      : out std_logic_vector(15 downto 0)
	 );
end instruction_register;

architecture STR of instruction_register is
	
begin 


	process(clk_50MHz, rst)
	 begin
	 
		if (rst = '1') then
			output_31to26 <= (others => '0');
			output_25to21 <= (others => '0');
		   output_20to16 <= (others => '0');
		   output_15to0  <= (others => '0');
			
		elsif (clk_50MHz'event and clk_50MHz = '1') then
			output_31to26 <= input(31 downto 26);
		   output_25to21 <= input(25 downto 21);
		   output_20to16 <= input(20 downto 16);
		   output_15to0   <= input(15 downto 0);
		end if;
	 end process;
	 
end STR;