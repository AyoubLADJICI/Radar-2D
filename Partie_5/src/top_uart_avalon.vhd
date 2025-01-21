library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_UART_Avalon is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        chipselect  : in std_logic;
        address     : in std_logic_vector(3 downto 0);
        writedata   : in std_logic_vector(31 downto 0);
        readdata    : out std_logic_vector(31 downto 0);
        write_n     : in std_logic;
        read_n      : in std_logic;
        tx          : out std_logic;
        rx          : in std_logic
    );
end entity;

architecture RTL of TOP_UART_Avalon is

signal tick_b, tick_hb : std_logic;
signal tx_data : std_logic_vector(7 downto 0) := (others => '0');
signal rx_data : std_logic_vector(7 downto 0) := (others => '0');
signal status_reg  : std_logic_vector(7 downto 0) := (others => '0');
signal tx_busy     : std_logic := '0';
signal rx_dav      : std_logic := '0';
signal rx_err      : std_logic := '0';
signal ld : std_logic := '0';

begin

    process(clk, reset)
    begin
        if reset = '1' then
            readdata <= (others => '0');
			tx_data <= (others => '0');
            ld <= '0';
        elsif rising_edge(clk) then
            if chipselect = '1' then
                if write_n = '0' then
                    ld <= '1';
                    tx_data <= writedata(7 downto 0);
                else
                    ld <= '0';
                end if;

                if read_n = '0' then
                    case address is
                        when "0000" => readdata <= (31 downto 8 => '0') & tx_data;
                        when "0001" => readdata <= (31 downto 8 => '0') & rx_data;
                        when "0010" => readdata <= (31 downto 3 => '0') & rx_err & rx_dav & tx_busy;
                        when others  => readdata <= (others => '0');
                    end case;
                end if;                
            end if;
        end if;
    end process;

inst_FDIV: entity work.FDIV generic map(BaudRate => 115200, ClockFrequency => 50E6)
port map(Clk => clk, Reset => reset, Tick => tick_b, Tick_half => tick_hb);
    
UART_TX: entity work.UART_TX
port map (Clk => clk, Reset => reset, LD => ld, Din => tx_data, Tick => tick_b, Tx_Busy => tx_busy, Tx => tx);

UART_RX: entity work.UART_RX
port map (Clk => clk, Reset => reset, Rx => rx, Tick_halfbit => tick_hb, Clear_fdiv => open, Err => rx_err, DAV => rx_dav, Data => rx_data);

end RTL;
