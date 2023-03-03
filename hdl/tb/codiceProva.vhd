   -- test di reset
    process
    begin
        resetn <= '1';
        wait for 10 ns;
        resetn <= '0';
        wait for 5 ns;
        assert cntr_out_ext = "00000000"
            report "Reset fallito" severity error;
        wait;
    end process;


-- testbench DFF con enable

library ieee;
use ieee.std_logic_1164.all;

entity DFF_en_tb is
end entity DFF_en_tb;

architecture behavioral of DFF_en_tb is

  -- Dichiarazione dei segnali di ingresso e uscita del testbench
  signal clk, rst, en, d, q: std_logic;

  -- Instanziazione del D flip-flop con ingresso di enable
  component DFF_enable
    port(
      clk, rst, en, d: in std_logic;
      q: out std_logic
    );
  end component;

  -- Generazione del clock
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean := false;

  -- Processo di generazione del clock
  process
  begin
    while not stop_the_clock loop
      clk <= '0';
      wait for clock_period / 2;
      clk <= '1';
      wait for clock_period / 2;
    end loop;
    wait;
  end process;

  -- Processo di reset
  process
  begin
    rst <= '1';
    wait for 10 ns;
    rst <= '0';
    wait for 10 ns;
    wait;
  end process;

begin

  -- Istanziazione del D flip-flop con ingresso di enable
  dut: dff_enable port map(clk, rst, en, d, q);

  -- Test case 1: abilitazione del flip-flop, ingresso di un valore sul D input
  test_case_1: process
  begin
    en <= '1';
    d <= '0';
    wait for 5 ns;
    assert (q = '0') report "Errore: il segnale di uscita q dovrebbe essere 0" severity error;
    d <= '1';
    wait for 5 ns;
    assert (q = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
    d <= '0';
    wait for 5 ns;
    assert (q = '0') report "Errore: il segnale di uscita q dovrebbe essere 0" severity error;
    d <= '1';
    wait for 5 ns;
    assert (q = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
    en <= '0';
    wait for 5 ns;
    assert (q = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
    wait;
  end process;

  -- Test case 2: disabilitazione del flip-flop, ingresso di un valore sul D input
  test_case_2: process
  begin
    en <= '0';
    d <= '0';
    wait for 5 ns;
    assert (q = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
    d <= '1';
    wait for 5 ns;
    assert (q = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
    d <= '0';
    wait for 5 ns;
    assert (q = '1') report "Errore: il segnale di uscita q dovrebbe essere 1" severity error;
    d <= '1';
    wait