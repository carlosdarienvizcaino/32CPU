library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_div is
    generic(
		clk_in_freq  : natural := 50000000;
      clk_out_freq : natural := 1000
	 );
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic;
        rst     : in  std_logic);
end clk_div;

architecture BHV of clk_div is
	
	signal frequencyRatio : natural := clk_in_freq/clk_out_freq;
	constant COUNTER_WIDTH : integer := integer(ceil(log2(real(frequencyRatio))));
	signal counter : unsigned(COUNTER_WIDTH-1 downto 0);
	
	begin 
	process(rst, clk_in)
	begin
 	
		if (rst = '1') then
			 clk_out <= '0';
			 counter <= to_unsigned(0, COUNTER_WIDTH);
		elsif (clk_in'event and clk_in = '1') then
			 
			 counter <= counter + 1;
			 
			 -- 50% Cycle Duty
			 if (counter < frequencyRatio/2) then
				clk_out <= '1';
			 else 
				clk_out <= '0';
			 end if;
			 
			 -- Reset counter 
			 if (counter = frequencyRatio-1) then
				counter <= to_unsigned(0, COUNTER_WIDTH);
			 end if;
			 
		end if;
		
	end process;
end BHV;
