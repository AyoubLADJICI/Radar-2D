library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--code source : Moodle 2023 Solution de l'UART
entity UART_TX_tb is
end UART_TX_tb;

architecture Bench of UART_TX_tb is
    signal Clk         : std_logic := '0';
    signal Reset       : std_logic := '0';
    signal Go          : std_logic := '0';
    signal Data        : std_logic_vector(7 downto 0) := (others => '0');
    signal Tick        : std_logic := '0';
    signal Tx, TxBusy  : std_logic;
    signal Reg         : std_logic_vector(9 downto 0) := (others => '0');
    signal OK          : boolean := TRUE;

begin

process
begin
    while (now <= 540 us) loop
        Clk <= '0';
        wait for 10 ns;
        Clk <= '1';
        wait for 10 ns;
    end loop;
    wait;
end process;

    Reg <= '1' & Data & '0';

process
begin
    report "Starting UART Tx testbench...";

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    report "Test 1 : Transmission du caractere 'A' ";
    Data <= "01000001";
    Go <= '1';

    wait until Tick = '1';
    wait for 30 ns;

    Go <= '0';

    for i in 0 to Reg'length - 1 loop
        if (Tx /= Reg(i)) then
            report "There is a problem with the Tx waveform" severity error;
            OK <= FALSE;
        end if;
        wait for 8680.6 ns;
    end loop;

    if (OK) then
        report "Test 1 valide" severity note;
    else
        report "Test 1 echoue" severity error;
    end if;

    wait for 10 us; 

    report "Test 2 : Transmission du caractere 'Y' ";
    Data <= "01011001";
    Go <= '1';

    wait until Tick = '1';
    wait for 30 ns;

    Go <= '0';

    for i in 0 to Reg'length - 1 loop
        if (Tx /= Reg(i)) then
            report "There is a problem with the Tx waveform" severity error;
            OK <= FALSE;
        end if;
        wait for 8680.6 ns;
    end loop;

    if (OK) then
        report "Test 2 valide" severity note;
    else
        report "Test 2 echoue" severity error;
    end if;

    wait for 10 us; 
    
    report "Test 3 : Transmission du caractere 'O' ";
    Data <= "01001111";
    Go <= '1';

    wait until Tick = '1';
    wait for 30 ns;

    Go <= '0';

    for i in 0 to Reg'length - 1 loop
        if (Tx /= Reg(i)) then
            report "There is a problem with the Tx waveform" severity error;
            OK <= FALSE;
        end if;
        wait for 8680.6 ns;
    end loop;

    if (OK) then
        report "Test 3 valide" severity note;
    else
        report "Test 3 echoue" severity error;
    end if;

    wait for 10 us;
    
    report "Test 4 : Transmission du caractere 'U' ";
    Data <= "01010101";
    Go <= '1';

    wait until Tick = '1';
    wait for 30 ns;

    Go <= '0';

    for i in 0 to Reg'length - 1 loop
        if (Tx /= Reg(i)) then
            report "There is a problem with the Tx waveform" severity error;
            OK <= FALSE;
        end if;
        wait for 8680.6 ns;
    end loop;

    if (OK) then
        report "Test 4 valide" severity note;
    else
        report "Test 4 echoue" severity error;
    end if;

    report "Test 5 : Transmission du caractere 'B' ";
    Data <= "01000010";
    Go <= '1';

    wait until Tick = '1';
    wait for 30 ns;

    Go <= '0';

    for i in 0 to Reg'length - 1 loop
        if (Tx /= Reg(i)) then
            report "There is a problem with the Tx waveform" severity error;
            OK <= FALSE;
        end if;
        wait for 8680.6 ns;
    end loop;

    if (OK) then
        report "Test 5 valide" severity note;
    else
        report "Test 5 echoue" severity error;
    end if;

    report "Fin de la simulation" severity note;

    wait;
end process;

fdiv: entity work.FDIV
    port map (
        Clk       => Clk,
        Reset     => Reset,
        Tick      => Tick,
        Tick_half => open
    );

UART_TX: entity work.UART_TX
    port map (
        Clk   => Clk,
        Reset => Reset,
        LD    => Go,
        Din  => Data,
        Tick  => Tick,
        Tx_Busy => TxBusy, 
        Tx    => Tx
    );

end Bench;