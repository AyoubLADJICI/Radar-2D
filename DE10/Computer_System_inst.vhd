	component Computer_System is
		port (
			avalon_neopixel_0_neopixel_commande_led   : out   std_logic;                                        -- commande_led
			avalon_servomoteur_0_servomoteur_commande : out   std_logic;                                        -- commande
			avalon_telemetre_0_telemetre_trig         : out   std_logic;                                        -- trig
			avalon_telemetre_0_telemetre_echo         : in    std_logic                     := 'X';             -- echo
			avalon_telemetre_0_telemetre_distance     : out   std_logic_vector(9 downto 0);                     -- distance
			hex3_hex0_export                          : out   std_logic_vector(31 downto 0);                    -- export
			hex5_hex4_export                          : out   std_logic_vector(15 downto 0);                    -- export
			leds_export                               : out   std_logic_vector(9 downto 0);                     -- export
			pushbuttons_export                        : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			sdram_addr                                : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                                  : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n                               : out   std_logic;                                        -- cas_n
			sdram_cke                                 : out   std_logic;                                        -- cke
			sdram_cs_n                                : out   std_logic;                                        -- cs_n
			sdram_dq                                  : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_dqm                                 : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ras_n                               : out   std_logic;                                        -- ras_n
			sdram_we_n                                : out   std_logic;                                        -- we_n
			sdram_clk_clk                             : out   std_logic;                                        -- clk
			slider_switches_export                    : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			system_pll_ref_clk_clk                    : in    std_logic                     := 'X';             -- clk
			system_pll_ref_reset_reset                : in    std_logic                     := 'X';             -- reset
			vga_CLK                                   : out   std_logic;                                        -- CLK
			vga_HS                                    : out   std_logic;                                        -- HS
			vga_VS                                    : out   std_logic;                                        -- VS
			vga_BLANK                                 : out   std_logic;                                        -- BLANK
			vga_SYNC                                  : out   std_logic;                                        -- SYNC
			vga_R                                     : out   std_logic_vector(3 downto 0);                     -- R
			vga_G                                     : out   std_logic_vector(3 downto 0);                     -- G
			vga_B                                     : out   std_logic_vector(3 downto 0);                     -- B
			video_pll_ref_clk_clk                     : in    std_logic                     := 'X';             -- clk
			video_pll_ref_reset_reset                 : in    std_logic                     := 'X';             -- reset
			avalon_uart_0_uart_tx                     : out   std_logic;                                        -- tx
			avalon_uart_0_uart_rx                     : in    std_logic                     := 'X'              -- rx
		);
	end component Computer_System;

	u0 : component Computer_System
		port map (
			avalon_neopixel_0_neopixel_commande_led   => CONNECTED_TO_avalon_neopixel_0_neopixel_commande_led,   --       avalon_neopixel_0_neopixel.commande_led
			avalon_servomoteur_0_servomoteur_commande => CONNECTED_TO_avalon_servomoteur_0_servomoteur_commande, -- avalon_servomoteur_0_servomoteur.commande
			avalon_telemetre_0_telemetre_trig         => CONNECTED_TO_avalon_telemetre_0_telemetre_trig,         --     avalon_telemetre_0_telemetre.trig
			avalon_telemetre_0_telemetre_echo         => CONNECTED_TO_avalon_telemetre_0_telemetre_echo,         --                                 .echo
			avalon_telemetre_0_telemetre_distance     => CONNECTED_TO_avalon_telemetre_0_telemetre_distance,     --                                 .distance
			hex3_hex0_export                          => CONNECTED_TO_hex3_hex0_export,                          --                        hex3_hex0.export
			hex5_hex4_export                          => CONNECTED_TO_hex5_hex4_export,                          --                        hex5_hex4.export
			leds_export                               => CONNECTED_TO_leds_export,                               --                             leds.export
			pushbuttons_export                        => CONNECTED_TO_pushbuttons_export,                        --                      pushbuttons.export
			sdram_addr                                => CONNECTED_TO_sdram_addr,                                --                            sdram.addr
			sdram_ba                                  => CONNECTED_TO_sdram_ba,                                  --                                 .ba
			sdram_cas_n                               => CONNECTED_TO_sdram_cas_n,                               --                                 .cas_n
			sdram_cke                                 => CONNECTED_TO_sdram_cke,                                 --                                 .cke
			sdram_cs_n                                => CONNECTED_TO_sdram_cs_n,                                --                                 .cs_n
			sdram_dq                                  => CONNECTED_TO_sdram_dq,                                  --                                 .dq
			sdram_dqm                                 => CONNECTED_TO_sdram_dqm,                                 --                                 .dqm
			sdram_ras_n                               => CONNECTED_TO_sdram_ras_n,                               --                                 .ras_n
			sdram_we_n                                => CONNECTED_TO_sdram_we_n,                                --                                 .we_n
			sdram_clk_clk                             => CONNECTED_TO_sdram_clk_clk,                             --                        sdram_clk.clk
			slider_switches_export                    => CONNECTED_TO_slider_switches_export,                    --                  slider_switches.export
			system_pll_ref_clk_clk                    => CONNECTED_TO_system_pll_ref_clk_clk,                    --               system_pll_ref_clk.clk
			system_pll_ref_reset_reset                => CONNECTED_TO_system_pll_ref_reset_reset,                --             system_pll_ref_reset.reset
			vga_CLK                                   => CONNECTED_TO_vga_CLK,                                   --                              vga.CLK
			vga_HS                                    => CONNECTED_TO_vga_HS,                                    --                                 .HS
			vga_VS                                    => CONNECTED_TO_vga_VS,                                    --                                 .VS
			vga_BLANK                                 => CONNECTED_TO_vga_BLANK,                                 --                                 .BLANK
			vga_SYNC                                  => CONNECTED_TO_vga_SYNC,                                  --                                 .SYNC
			vga_R                                     => CONNECTED_TO_vga_R,                                     --                                 .R
			vga_G                                     => CONNECTED_TO_vga_G,                                     --                                 .G
			vga_B                                     => CONNECTED_TO_vga_B,                                     --                                 .B
			video_pll_ref_clk_clk                     => CONNECTED_TO_video_pll_ref_clk_clk,                     --                video_pll_ref_clk.clk
			video_pll_ref_reset_reset                 => CONNECTED_TO_video_pll_ref_reset_reset,                 --              video_pll_ref_reset.reset
			avalon_uart_0_uart_tx                     => CONNECTED_TO_avalon_uart_0_uart_tx,                     --               avalon_uart_0_uart.tx
			avalon_uart_0_uart_rx                     => CONNECTED_TO_avalon_uart_0_uart_rx                      --                                 .rx
		);

