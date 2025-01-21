vlib work

vcom -93 ../src/fdiv.vhd
vcom -93 ../src/uart_tx.vhd
vcom -93 uart_tx_tb.vhd

vsim uart_tx_tb(Bench)

view signals
add wave -binary /uart_tx_tb/clk
add wave -binary /uart_tx_tb/reset
add wave -binary /uart_tx_tb/go
add wave -ascii /uart_tx_tb/data
add wave -binary /uart_tx_tb/tick
add wave -binary /uart_tx_tb/tx
add wave -binary /uart_tx_tb/txbusy
add wave -binary /uart_tx_tb/reg
add wave /uart_tx_tb/ok

run -all
wave zoom full