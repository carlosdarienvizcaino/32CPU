library ieee;
use ieee.std_logic_1164.all;

entity mux_2x1 is
	generic (width : positive := 32);
	port (
		mux_in1 : in std_logic_vector(width-1 downto 0);
		mux_in2 : in std_logic_vector(width-1 downto 0);
		mux_sel : in std_logic;
		mux_out : out std_logic_vector(width-1 downto 0));
end mux_2x1;

architecture BHV of mux_2x1 is

begin

	process(mux_sel, mux_in1, mux_in2)
	begin
		if (mux_sel = '0') then
			mux_out <= mux_in1;
		else 
			mux_out <= mux_in2;
		end if;
		
	end process;
end BHV;