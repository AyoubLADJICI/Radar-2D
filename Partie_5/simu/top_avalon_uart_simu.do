vlib work

vcom -93 ../src/fdiv.vhd
vcom -93 ../src/uart_tx.vhd
vcom -93 ../src/uart_rx.vhd
vcom -93 ../src/top_uart_avalon.vhd
vcom -93 top_uart_avalon_tb.vhd

vsim top_uart_avalon_tb(Bench)

view signals
add wave /top_uart_avalon_tb/clk
add wave /top_uart_avalon_tb/reset
add wave /top_uart_avalon_tb/chipselect
add wave /top_uart_avalon_tb/address
add wave /top_uart_avalon_tb/writedata
add wave /top_uart_avalon_tb/readdata
add wave /top_uart_avalon_tb/tx
add wave /top_uart_avalon_tb/rx
add wave /top_uart_avalon_tb/ok

run -all
wave zoom full
