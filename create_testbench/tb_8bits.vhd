-- Librerie utilizzate
library IEEE;
use IEEE.std_logic_1164.all;
entity tb_8bits is
end tb_8bits;
-- Dichiarazione dell'entità
architecture interleaver_test of tb_8bits is
	component interleaver
   generic(Nbit: POSITIVE := 8);
		port (
			clock		: in std_logic;						-- segnale di clock
			reset	: in std_logic;							-- segnale di reset
			bit_in		: in std_logic;	-- ingresso
			bit_out 	: out std_logic	-- uscita
			);
	end component;
-----------------------------------------------------
--CONSTANT
	CONSTANT clock_period : TIME := 100 ns;
	CONSTANT len : INTEGER := 19;
	--INPUT SIGNALS
	SIGNAL clock_tb : std_logic := '0';
	SIGNAL reset_tb : std_logic := '1';
	SIGNAL bit_in_tb : std_logic := '0';


	--OUTPUT SIGNALS
	SIGNAL bit_out_tb : std_logic := '0';

	SIGNAL testing: Boolean :=True;

	SIGNAL count: INTEGER:= 0;

  SIGNAL count_reset: INTEGER:= 0;

	BEGIN
		I: interleaver
       generic map(Nbit => 8)
       PORT MAP
           (clock => clock_tb, reset => reset_tb, bit_in => bit_in_tb, bit_out =>bit_out_tb);

--Generates clk
	clock_tb <=NOT clock_tb AFTER clock_period/2 WHEN testing ELSE '0';
   --reset_tb <= '0' after 2*clock_Period;

    --Runs simulation for len cycles
    proc_test: process(clock_tb, reset_tb)

    begin

        if(reset_tb = '1') then
				bit_in_tb <= 'Z';
               count <= 0;
               if rising_edge(clock_tb) and (count_reset < 3) then
                   count_reset <= count_reset +1;
               elsif rising_edge(clock_tb) and (count_reset >= 3) then
                   reset_tb <= '0';
               end if;

       elsif rising_edge(clock_tb) then
           CASE count IS
                WHEN 0 => bit_in_tb <= '0';
                WHEN 1 => bit_in_tb <= '0';
                WHEN 2 => bit_in_tb <= '1';
                WHEN 3 => bit_in_tb <= '0';
                WHEN 4 => bit_in_tb <= '0';
                WHEN 5 => bit_in_tb <= '1';
                WHEN 6 => bit_in_tb <= '0';
                WHEN 7 => bit_in_tb <= '0';
               WHEN	OTHERS	=>	NULL;
           END CASE;
           if count >= 8 then
               bit_in_tb <= 'Z';
           end if;
           if count = len then 
               testing <= false;      -- fine test
           end if;
           if (count > len) then 
               reset_tb <= '1';
           end if;
           count <= count + 1;
       end if;


end process proc_test;

end interleaver_test;
