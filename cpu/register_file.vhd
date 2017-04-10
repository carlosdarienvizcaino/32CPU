library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity register_file is 
	generic(
		address_width : positive := 5;
		word_width : positive := 32);
	port(
		-- Inputs
		clock : in std_logic;
		rst : in std_logic;
		
		rd_addr0 : in std_logic_vector(address_width-1 downto 0);
		rd_addr1 : in std_logic_vector(address_width-1 downto 0);
		
		wr_addr : in std_logic_vector(address_width-1 downto 0);
		wr_data : in std_logic_vector(word_width-1 downto 0);
		
		wr_en : in std_logic;
		jump_and_link : std_logic;
		
		-- Outputs
		rd_data1 : out std_logic_vector(word_width-1 downto 0);
		rd_data0 : out std_logic_vector(word_width-1 downto 0)
		
		);
		
end register_file;

architecture DEF of register_file is 
	
	type reg_array is array(0 to 2**address_width-1) of std_logic_vector(word_width-1 downto 0);
	signal regs : reg_array;
	signal reg32Address : std_logic_vector(4 downto 0) := "11111";
	
	begin 
		process(clock, rst)
		begin
		
			if(rst = '1') then
			
				for i in 0 to 2**address_width-1 loop
					regs(i) <= (others => '0'); 
					end loop;
					
			elsif(rising_edge(clock)) then
				
				if(wr_en = '1') then
					regs(to_integer(unsigned(wr_addr))) <= wr_data; 
				
				elsif(jump_and_link = '1') then 
					regs(to_integer(unsigned(reg32Address))) <= wr_data; 
				end if;
			end if;
		
		end process;
	
		process(rd_addr0, regs)
		begin 
			rd_data0 <= regs(to_integer(unsigned(rd_addr0)));
		end process;
		
		process(rd_addr1, regs)
		begin
			rd_data1 <= regs(to_integer(unsigned(rd_addr1)));
		end process;
		
end DEF;