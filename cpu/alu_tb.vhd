library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.alu_lib.all;

entity alu_tb is
end alu_tb;

architecture TB of alu_tb is

    constant WIDTH  : positive                           := 4;
    signal input1   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal input2   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal opSelect      : std_logic_vector(3 downto 0)       := (others => '0');
    signal output   : std_logic_vector(WIDTH-1 downto 0);
    signal outputHi   : std_logic_vector(WIDTH-1 downto 0);

begin  -- TB

      UUT : entity work.alu
        generic map (WIDTH => WIDTH)
        port map (
            input1   => input1,
            input2   => input2,
            opSelect      => opSelect,
            output   => output,
            outputHi => outputHi);

    process
    begin
	 
		--ADD
		opSelect <= ALU_ADD ;
		input1 <= conv_std_logic_vector(8, input1'length);
		input2 <= conv_std_logic_vector(9, input2'length);
		wait for 40 ns;
		assert (output = conv_std_logic_vector(1, output'length)) report "Error: 'ADD' test 1" severity warning ;
		--assert (overflow = '1' ) report "Error with overloading when 'ADD' was used in test1";
		
		opSelect <= ALU_ADD ;
		input1 <= conv_std_logic_vector(8, input1'length);
		input2 <= conv_std_logic_vector(9, input2'length);
		wait for 40 ns;
		assert (output = conv_std_logic_vector(1, output'length)) report "Error: 'ADD' test 1" severity warning ;
		--assert (overflow = '1' ) report "Error with overloading when 'ADD' was used in test 1";
		
		report "SIMULATION FINISHED!";
      wait;
		
    end process;



end TB;