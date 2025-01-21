puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/ip_neopixel_avalon.vhd
vcom -93 tb_ip_neopixel_avalon.vhd

vsim tb_ip_neopixel_avalon
view signals
add wave -binary /tb_ip_neopixel_avalon/Inst_ip_neopixel_avalon/clk
add wave -binary /tb_ip_neopixel_avalon/Inst_ip_neopixel_avalon/reset_n
add wave -binary /tb_ip_neopixel_avalon/Inst_ip_neopixel_avalon/chipselect
add wave -binary /tb_ip_neopixel_avalon/Inst_ip_neopixel_avalon/write_n
add wave -decimal /tb_ip_neopixel_avalon/Inst_ip_neopixel_avalon/writedata
add wave -decimal /tb_ip_neopixel_avalon/Inst_ip_neopixel_avalon/nb_led
add wave -decimal /tb_ip_neopixel_avalon/Inst_ip_neopixel_avalon/nb_tour
add wave -unsigned /tb_ip_neopixel_avalon/Inst_ip_neopixel_avalon/led_index
add wave -binary /tb_ip_neopixel_avalon/Inst_ip_neopixel_avalon/commande
add wave OK

run -a