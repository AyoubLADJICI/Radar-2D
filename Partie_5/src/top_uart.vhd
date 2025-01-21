library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity TOP_UART is
    port (
        MAX10_CLK1_50 : in std_logic;
        KEY           : in std_logic_vector(1 downto 0);
        SW            : in std_logic_vector(9 downto 0);
        LEDR          : out std_logic_vector(9 downto 0);
        GPIO          : inout std_logic_vector(35 downto 0)
    );
end entity;

architecture RTL of TOP_UART is

signal clk, rst : std_logic;
signal tick_b, tick_hb : std_logic;
signal clear_fdiv : std_logic;
signal tx, tx_busy, rx, rx_dav, rx_err : std_logic; 
signal tx_data, rx_data: std_logic_vector(7 downto 0);
signal ld : std_logic;

begin

clk <= MAX10_CLK1_50;
rst <= not KEY(0);
tx_data <= SW(7 downto 0);
GPIO(5) <= tx;
rx <= GPIO(6);
LEDR(7 downto 0) <= rx_data; 
LEDR(8) <= tx_busy;
LEDR(9) <= rx_err;
ld <= not KEY(1);

FDIV : entity work.FDIV
    generic map(BaudRate => 115200, ClockFrequency => 50E6)
    port map(Clk => clk, Reset => rst, Tick => tick_b, Tick_half => tick_hb);

UART_TX : entity work.uart_tx
    port map(Clk => clk, Reset => rst, LD => ld, Din => tx_data, Tick => tick_b, Tx_Busy => tx_busy, Tx => tx);

UART_RX : entity work.uart_rx
    port map(Clk => clk, Reset => rst, Rx => rx, Tick_halfbit => tick_hb, Clear_fdiv => clear_fdiv, Err => rx_err, DAV => rx_dav, Data => rx_data);

end architecture;
