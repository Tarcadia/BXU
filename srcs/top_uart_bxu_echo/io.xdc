
#set_property PACKAGE_PIN J21 [get_ports {key[1]}]
#set_property PACKAGE_PIN E13 [get_ports {key[2]}]

#set_property IOSTANDARD LVCMOS33 [get_ports key]


#set_property PACKAGE_PIN B13 [get_ports {led[1]}]
#set_property PACKAGE_PIN C13 [get_ports {led[2]}]
#set_property PACKAGE_PIN D14 [get_ports {led[3]}]
#set_property PACKAGE_PIN D15 [get_ports {led[4]}]

#set_property IOSTANDARD LVCMOS33 [get_ports led]
#set_property SLEW SLOW [get_ports led]
#set_property DRIVE 12 [get_ports led]


set_property PACKAGE_PIN N15 [get_ports {uart_tx}]
set_property PACKAGE_PIN P20 [get_ports {uart_rx}]

set_property IOSTANDARD LVCMOS33 [get_ports {uart_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {uart_rx}]

