library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_tb is
end entity;

architecture beh of counter_tb is
    constant N: integer := 8;
    constant CLK_PERIOD : time := 100 ns;

    component counter is
    generic( N : natural := 8);
    port (
        increment:  in std_logic_vector(N-1 downto 0);
        cntr_out: out std_logic_vector(N-1 downto 0);
        en      :   in std_logic;
        clk     :   in std_logic;
        rst  :   in  std_logic

    );
    end component;

    signal clk : std_logic := '0';
    signal resetn:  std_logic := '1';
    signal en_ext:  std_logic := '0';
    signal input_ext:   std_logic_vector (N-1 downto 0) := (others => '0');
    signal cntr_out_ext:  std_logic_vector (N-1 downto 0);
    signal testing : boolean := true;

begin
    clk <=  not clk after clk_period/2 when testing else '0';

    dut: counter 
    generic map (N => N)
    port map(
        increment => input_ext,
        clk => clk,
        rst => resetn,
        en => en_ext,
        cntr_out => cntr_out_ext
    );
 
    stimulus : process
    begin
        input_ext <= "11111110";
        en_ext <= '1';
        resetn <= '0';
        wait until rising_edge (clk);
        input_ext <= "00000001";
        en_ext <= '1';
        wait until rising_edge(clk);
        resetn <= '0';
        input_ext <= "00000001";
        wait until rising_edge(clk);
        en_ext <= '0';
        wait until rising_edge(clk);
        en_ext <= '1';
        input_ext <= "00000001";
        wait until rising_edge (clk);
        resetn <= '1';
        wait until rising_edge (clk);
        resetn <= '0';
        input_ext <= "00000001";
        wait for 500 ns;
        testing <= false;
    
    end process;    
end architecture;