library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--Code écrit par ChatGPT

entity TOP_UART_Avalon_tb is
end TOP_UART_Avalon_tb;

architecture Bench of TOP_UART_Avalon_tb is
    -- Signals
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal chipselect  : std_logic := '0';
    signal address     : std_logic_vector(3 downto 0) := (others => '0');
    signal writedata   : std_logic_vector(31 downto 0) := (others => '0');
    signal readdata    : std_logic_vector(31 downto 0);
    signal write_n     : std_logic := '1';
    signal read_n      : std_logic := '1';
    signal tx          : std_logic;
    signal rx          : std_logic := '1'; 

    signal OK : boolean := true;

begin
    -- Clock generation
    clk_process : process
    begin
        while now <= 1 ms loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    -- DUT instantiation
    DUT: entity work.TOP_UART_Avalon
        port map (
            clk         => clk,
            reset       => reset,
            chipselect  => chipselect,
            address     => address,
            writedata   => writedata,
            readdata    => readdata,
            write_n     => write_n,
            read_n      => read_n,
            tx          => tx,
            rx          => rx
        );

    -- Test process
    process
    begin
        report "Starting TOP_UART_Avalon testbench...";

        -- Reset the design
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- Test 1: Write and read data from UART TX
        report "Test 1: Write data to UART TX...";
        chipselect <= '1';
        address <= "0000"; -- TX data register
        writedata <= (31 downto 8 => '0') & "01000001"; -- Sending ASCII 'A'
        write_n <= '0';
        wait for 20 ns;
        write_n <= '1';

        -- Read back TX data
        report "Reading back TX data...";
        read_n <= '0';
        wait for 20 ns;
        if readdata(7 downto 0) /= x"41" then
            report "Error: TX data mismatch!" severity error;
            OK <= false;
        end if;
        read_n <= '1';

        -- Test 2: Simulate UART RX reception
        report "Test 2: Simulating UART RX reception...";
        chipselect <= '1';
        address <= "0001"; -- RX data register
        -- Simulate receiving 'B' (ASCII 66)
        rx <= '0'; -- Start bit
        wait for 8680 ns; -- One bit period at 115200 baud
        rx <= '1'; -- Bit 0
        wait for 8680 ns;
        rx <= '0'; -- Bit 1
        wait for 8680 ns;
        rx <= '0'; -- Bit 2
        wait for 8680 ns;
        rx <= '0'; -- Bit 3
        wait for 8680 ns;
        rx <= '0'; -- Bit 4
        wait for 8680 ns;
        rx <= '0'; -- Bit 5
        wait for 8680 ns;
        rx <= '1'; -- Bit 6
        wait for 8680 ns;
        rx <= '0'; -- Bit 7
        wait for 8680 ns;
        rx <= '1'; -- Stop bit
        wait for 8680 ns;

        -- Check RX data
        report "Checking RX data...";
        read_n <= '0';
        wait for 20 ns;
        if readdata(7 downto 0) /= "01000010" then
            report "Error: RX data mismatch!" severity error;
            OK <= false;
        end if;
        read_n <= '1';

        -- Final check
        if OK then
            report "All tests passed successfully!" severity note;
        else
            report "Some tests failed." severity error;
        end if;

        wait;
    end process;

end Bench;
