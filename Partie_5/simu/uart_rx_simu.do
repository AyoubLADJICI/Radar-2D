vlib work

vcom -93 ../src/fdiv.vhd
vcom -93 ../src/uart_tx.vhd
vcom -93 ../src/uart_rx.vhd
vcom -93 uart_rx_tb.vhd

vsim uart_rx_tb(Bench)

view signals
add wave -binary /uart_rx_tb/clk
add wave -binary /uart_rx_tb/reset
add wave -binary /uart_rx_tb/go
add wave -binary /uart_rx_tb/dav
add wave -binary /uart_rx_tb/err
add wave -ascii /uart_rx_tb/data
add wave -ascii /uart_rx_tb/dout
add wave -binary /uart_rx_tb/tick
add wave -binary /uart_rx_tb/tick_hb
add wave -binary /uart_rx_tb/tx
add wave -binary /uart_rx_tb/txbusy
add wave -binary /uart_rx_tb/clear_fdiv
add wave -binary /uart_rx_tb/rst
add wave -binary /uart_rx_tb/reg
add wave /uart_rx_tb/ok


run -all
wave zoom full