library ieee;
use ieee.std_logic_1164.all;


entity DFF_N is
	generic( N : natural := 8);
		
  port( 
		clk     : in std_logic;
		rst : in std_logic;
		en      : in std_logic;
		d       : in std_logic_vector(N - 1 downto 0);
		q       : out std_logic_vector(N - 1 downto 0)
	);
			
end DFF_N;

architecture struct of DFF_N is   
  begin
   
  ddf_n_proc: process(clk, rst)
		begin
			if(rst = '1') then
				q <= (others => '0');
			elsif(rising_edge(clk)) then
				if(en = '1') then
					q <= d;
				end if;
			end if;
		end process;
   
end struct;
    