library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--J'ai ecrit ce code avec l'aide de Vladislav BALAYAN et de ChatGPT, notamment les lignes 116 à 154 qui se ressemblent beaucoup

entity ip_neopixel_avalon is
    port (
        clk         : in  std_logic;       
        reset_n     : in  std_logic;       
        chipselect  : in  std_logic;       
        write_n     : in  std_logic;      
        writedata   : in  std_logic_vector(31 downto 0); 
        commande  : out std_logic       
    );
end entity;

architecture RTL of ip_neopixel_avalon is

signal LED_0 : std_logic_vector(23 downto 0) := x"FF0000"; --Vert
signal LED_1 : std_logic_vector(23 downto 0) := x"00FF00"; --Rouge
signal LED_2 : std_logic_vector(23 downto 0) := x"FFFFFF"; --Blanc
signal LED_3 : std_logic_vector(23 downto 0) := x"0000FF"; --Bleu
signal LED_4 : std_logic_vector(23 downto 0) := x"80FF00"; --Orange
signal LED_5 : std_logic_vector(23 downto 0) := x"FFFF00"; --Jaune
signal LED_6 : std_logic_vector(23 downto 0) := x"203B77"; --Violet
signal LED_7 : std_logic_vector(23 downto 0) := x"18FFFF"; --Rose
signal LED_8 : std_logic_vector(23 downto 0) := x"E040D0"; --Turquoise
signal LED_9 : std_logic_vector(23 downto 0) := x"808080"; --Gris
signal LED_10 : std_logic_vector(23 downto 0) := x"FA2BFA"; --Cyan
signal LED_11 : std_logic_vector(23 downto 0) := x"00FFFF"; --Magenta
signal LED_Reset : std_logic_vector(23 downto 0) := x"000000"; --Noir

signal cnt_ticks : std_logic_vector(15 downto 0) := (others => '0');
signal cnt_bits : std_logic_vector(4 downto 0) := (others => '0'); 
signal led_index   : std_logic_vector(4 downto 0) := (others => '0'); 

signal state_pwm : std_logic := '0'; 
signal reset_done : std_logic := '0'; 
signal current_bit : std_logic := '0'; 
signal nb_led : std_logic_vector(31 downto 0) := (others => '0');
signal data_led : std_logic_vector(23 downto 0); 
signal nb_tour : std_logic_vector(4 downto 0) := (others => '0');

--Dans un premier temps, j'avais teste les constantes avec une horloge de 50 MHz mais cela ne fonctionnait pas
--et sans savoir la raison, cela fonctionne avec une horloge de 100 MHz
--1 tick = 10 ns

constant T0H : unsigned(7 downto 0) := "00100011"; --35 ticks
constant T0L : unsigned(7 downto 0) := "01010000"; --80 ticks
constant T1H : unsigned(7 downto 0) := "01000110"; --70 ticks
constant T1L : unsigned(7 downto 0) := "00111100"; --160 ticks
constant RESET_DURATION : unsigned(15 downto 0) := "0001001110001000"; --5000 ticks 

begin
process(clk, reset_n)
begin
    if reset_n = '0' then
        nb_led <= (others => '0');
    elsif rising_edge(clk) then
        if write_n = '0' and chipselect = '1' then
            nb_led <= writedata;
            --Notre anneau est limite à 12 LEDs
            if nb_led > x"0000000C" then
                nb_led <= x"0000000C";
            end if;
        end if;
    end if;
end process;

process(clk, reset_n)
begin
    if reset_n = '0' then
        nb_tour <= (others => '0');
        current_bit <= '0';
        cnt_ticks <= (others => '0');
        cnt_bits <= (others => '0');
        led_index <= (others => '0');
        state_pwm <= '0';
        reset_done <= '0';
        data_led <= (others => '0');
        commande <= '0';
    elsif rising_edge(clk) then
        case led_index is
            when "00000" => data_led <= LED_0;
            when "00001" => data_led <= LED_1;
            when "00010" => data_led <= LED_2;
            when "00011" => data_led <= LED_3;
            when "00100" => data_led <= LED_4;
            when "00101" => data_led <= LED_5;
            when "00110" => data_led <= LED_6;
            when "00111" => data_led <= LED_7;
            when "01000" => data_led <= LED_8;
            when "01001" => data_led <= LED_9;
            when "01010" => data_led <= LED_10;
            when "01011" => data_led <= LED_11;
            when others => data_led <= LED_Reset;
        end case;

        if reset_done = '0' then
            if unsigned(cnt_ticks) < RESET_DURATION then
                cnt_ticks <= std_logic_vector(unsigned(cnt_ticks) + 1);
                commande <= '0';
            else
                cnt_ticks <= (others => '0');
                reset_done <= '1';
                --Si l'utilisateur ne veut allumer aucune led alors on donne un index en dehors de la plage definie dans notre switchcase
                --Sinon on commence à 0
                if nb_led = x"00000000" then
                    led_index <= "01100";
                else
                    led_index <= "00000";
                end if;
            end if;
        else
            if state_pwm = '0' then
                if current_bit = '1' then
                    if unsigned(cnt_ticks) < T1H then
                        commande <= '1';
                        cnt_ticks <= std_logic_vector(unsigned(cnt_ticks) + 1);
                    else
                        state_pwm <= '1';
                        cnt_ticks <= (others => '0');
                    end if;
                else
                    if unsigned(cnt_ticks) < T0H then
                        commande <= '1';
                        cnt_ticks <= std_logic_vector(unsigned(cnt_ticks) + 1);
                    else
                        state_pwm <= '1';
                        cnt_ticks <= (others => '0');
                    end if;
                end if;
            else
                if current_bit = '1' then
                    if unsigned(cnt_ticks) < T1L then
                        commande <= '0';
                        cnt_ticks <= std_logic_vector(unsigned(cnt_ticks) + 1);
                    else
                        cnt_bits <= std_logic_vector(unsigned(cnt_bits) + 1);
                        cnt_ticks <= (others => '0');
                        state_pwm <= '0';
                    end if;
                else
                    if unsigned(cnt_ticks) < T0L then
                        commande <= '0';
                        cnt_ticks <= std_logic_vector(unsigned(cnt_ticks) + 1);
                    else
                        cnt_bits <= std_logic_vector(unsigned(cnt_bits) + 1);
                        cnt_ticks <= (others => '0');
                        state_pwm <= '0';
                    end if;
                end if;
            end if;

            if unsigned(cnt_bits) < 24 then
                current_bit <= data_led(23 - to_integer(unsigned(cnt_bits)));
            else
                cnt_bits <= (others => '0');
                --On doit parcourir toute les leds de notre anneau
                if unsigned(nb_tour) < 11 then
                    nb_tour <= std_logic_vector(unsigned(nb_tour) + 1);
                    --si on a fini d'allumer toutes les leds demandées
                    --les leds restantes seront eteintes
                    if unsigned(led_index) < unsigned(nb_led) - 1  then
                        led_index <= std_logic_vector(unsigned(led_index) + 1);
                    else
                        led_index <= "01100";
                    end if;
                else
                    nb_tour <= (others => '0');
                    led_index <= (others => '0');
                    reset_done <= '0';
                end if;
            end if;
        end if;
    end if;
end process;
end architecture;