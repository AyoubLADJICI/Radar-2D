library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TX is
    port (
        Clk   : in std_logic;
        Reset : in std_logic;
        LD    : in std_logic;
        Din  : in std_logic_vector(7 downto 0);
        Tick  : in std_logic;
        Tx_Busy  : out std_logic; --registre permettant de savoir si nous sommes en train de transmettre un bit de donnees
        Tx    : out std_logic
    );
end entity;

architecture RTL of UART_TX is
--Creation d'un type enumere
type StateType is (Idle, Start_bit, Next_bit, Transmission, Stop_bit); 
signal State : StateType;

signal tx_reg : std_logic_vector(9 downto 0); --1 bit pour le demarrage, 8 bits pour les donnees et 1 bit pour l'arret
signal index_bit : integer range 0 to 15; --Compteur pour les bits de donnees

begin
    process(Clk, Reset)
    begin
        if Reset = '1' then
            tx_reg <= (others => '0'); 
            index_bit <= 0; 
            State <= Idle; 
            Tx <= '1'; 
            Tx_Busy <= '0'; 
        elsif rising_edge(clk) then
            case State is 
                when Idle => 
                    if LD = '1' then 
                        tx_reg <= '1' & Din & '0'; --Concatène avec le bit de démarrage et le bit de stop
                        Tx_Busy <= '1'; 
                        index_bit <= 0; 
                        State <= Start_bit;
                    else
                        Tx <= '1';
                        Tx_Busy <= '0'; 
                    end if; 
                when Start_bit => 
                    if Tick = '1' then 
                        State <= Next_bit; 
                        Tx <= tx_reg(index_bit); 
                    end if; 
                when Next_bit => 
                    State <= Transmission; 
                    index_bit <= index_bit + 1; 
                when Transmission => 
                    if index_bit = 10 then 
                        State <= Stop_bit; 
                        index_bit <= 0; 
                    elsif Tick = '1' then 
                        State <= Next_bit; 
                        Tx <= tx_reg(index_bit); 
                    end if; 
                when Stop_bit => 
                    if Tick = '1' then  
                        TX_Busy <= '0';
                        State <= Idle; 
                    end if; 
                when others => 
                    State <= Idle; 
                end case; 
        end if;
 end process;
end architecture;