library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ip_neopixel_avalon is
end entity;

architecture Behavioral of tb_ip_neopixel_avalon is
signal clk         : std_logic := '0';
signal reset_n     : std_logic := '0';
signal chipselect  : std_logic := '0';
signal write_n     : std_logic := '1';
signal writedata   : std_logic_vector(31 downto 0) := (others => '0');
signal commande      : std_logic := '0';
signal OK : boolean := TRUE;

begin
    Inst_ip_neopixel_avalon: entity work.ip_neopixel_avalon
        port map (clk => clk, reset_n => reset_n, chipselect => chipselect, write_n => write_n, writedata => writedata, commande => commande);

    clk_process : process
    begin
        while now < 3 ms loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    process
        variable pulse_start, pulse_end : time := 0 ns;
    begin
        report "Debut de la simulation";
        reset_n <= '0';
        wait for 150 ns;
        reset_n <= '1';
        
        --Mesure de la durée du RESET
        report "Mesure de la duree du RESET";
        pulse_start := now;
        wait until commande = '0';
        --Ecriture du nombre de LEDs (0 LED)
        report "Test avec 0 LED allumee";
        chipselect <= '1';
        write_n <= '0';
        writedata <= x"00000000";
        wait until rising_edge(clk);
        chipselect <= '0';
        write_n <= '1';
        wait until commande = '1';
        pulse_end := now;
        if (pulse_end - pulse_start) >= 100 us then
            report "Test de la duree du RESET valide (>=100 us)" severity note;
        else
            report "Test de la duree du RESET echoue (<100 us)" severity error;
            OK <= FALSE;
        end if;

        wait for 700 us;
      
        --Ecriture du nombre de LEDs (9 LEDs)
        report "Test avec 9 LEDs allumees";
        chipselect <= '1';
        write_n <= '0';
        writedata <= x"00000009";
        wait until rising_edge(clk);
        write_n <= '1';
        chipselect <= '0';

        wait for 800 us;

        --Ecriture du nombre de LEDs (3 LEDs)
        report "Test avec 3 LEDs allumees";
        chipselect <= '1';
        write_n <= '0';
        writedata <= x"00000003";
        wait until rising_edge(clk);
        write_n <= '1';
        chipselect <= '0';

        wait for 800 us;

        --Ecriture du nombre de LEDs 
        report "Test avec 0 LEDs allumees";
        chipselect <= '1';
        write_n <= '0';
        writedata <= x"00000000";
        wait until rising_edge(clk);
        write_n <= '1';
        chipselect <= '0';
        wait for 1 ms;

        if (OK) then
            report "Tous les tests ont ete reussis !" severity note;
        else
            report "Certains tests ont echoue." severity error;
        end if;

        report "Fin de la simulation";
        wait;
    end process;
end Behavioral;
