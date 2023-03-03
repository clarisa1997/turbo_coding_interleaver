library ieee;
use ieee.std_logic_1164.all;

entity DFF_en_tb is
end entity DFF_en_tb;

architecture behavioral of DFF_en_tb is

  -- Dichiarazione dei segnali di ingresso e uscita del testbench
    signal di : std_logic;
    signal do : std_logic;
    signal clock : std_logic := '0';
    signal resetn:  std_logic := '1';
    signal en : std_logic := '1';
    constant clock_period: time := 100 ns;
    signal testing : boolean := true;

  -- Instanziazione del D flip-flop con ingresso di enable
    component DFF_en
        port(
            clock, resetn, en, di: in std_logic;
            do: out std_logic
        );
    end component;

begin

    clock <=  not clock after clock_period/2 when testing else '0';
    resetn <= '0' after 150 ns;


    -- Istanziazione del D flip-flop con ingresso di enable
    dut: DFF_en port map(
        clock => clock, 
        resetn => resetn, 
        en => en, 
        di => di, 
        do => do
        );

    -- Test case 1: abilitazione del flip-flop, ingresso di un valore sul D input
    test_case_1: process
    begin
        en <= '1';
        di <= '0';
        wait for 100 ns;
        assert (do = '0') report "Errore: il segnale di uscita q dovrebbe essere 0" severity error;
        di <= '1';
        wait for 100 ns;
        assert (do = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
        di <= '0';
        wait for 100 ns;
        assert (do = '0') report "Errore: il segnale di uscita q dovrebbe essere 0" severity error;
        di <= '1';
        wait for 100 ns;
        assert (do = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
        en <= '0';
        wait for 100 ns;
        assert (do = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
        wait for 200 ns;
        en <= '0';
        di <= '0';
        wait for 100 ns;
        assert (do = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
        di <= '1';
        wait for 100 ns;
        assert (do = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
        di <= '0';
        wait for 100 ns;
        assert (do = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
        di <= '1';
        testing <= false;
        wait;
    end process;

end behavioral;