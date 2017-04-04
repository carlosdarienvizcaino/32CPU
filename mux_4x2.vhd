library ieee;
use ieee.std_logic_1164.all;

entity mux_4x2 is
	generic (width : positive := 32);
	port (
		mux_in1 : in std_logic_vector(width-1 downto 0);
		mux_in2 : in std_logic_vector(width-1 downto 0);
		mux_in3 : in std_logic_vector(width-1 downto 0);
		mux_in4 : in std_logic_vector(width-1 downto 0);
		mux_sel : in std_logic_vector(1 downto 0);
		mux_out : out std_logic_vector(width-1 downto 0));
end mux_4x2;

architecture BHV of mux_4x2 is

begin


	process(mux_sel, mux_in1, mux_in2, mux_in3, mux_in4)
	begin
		if (mux_sel = "00") then
			mux_out <= mux_in1;
		
		elsif (mux_sel = "01") then
			mux_out <= mux_in2;
		
		elsif (mux_sel = "10") then
			mux_out <= mux_in3;
		
		else 
		       mux_out <= mux_in4;
		end if;
		
	end process;
end BHV;
