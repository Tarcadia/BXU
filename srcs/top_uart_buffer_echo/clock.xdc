
#create_clock -name sys_clk -period 5.000 [get_ports sys_clk_p]
#create_clock -name mgt_clk0 -period 6.734 [get_ports mgt_clk0_p]

set_property PACKAGE_PIN R4 [get_ports {sys_clk_p}]
set_property PACKAGE_PIN T4 [get_ports {sys_clk_n}]
#set_property PACKAGE_PIN F6 [get_ports {mgt_clk0_p}]
#set_property PACKAGE_PIN E6 [get_ports {mgt_clk0_n}]

#set_property PACKAGE_PIN T6 [get_ports {reset_n}]

set_property IOSTANDARD DIFF_SSTL15 [get_ports {sys_clk_p}]
#set_property IOSTANDARD LVCMOS15 [get_ports {sys_clk_p}]
#set_property IOSTANDARD LVCMOS15 [get_ports {sys_clk_n}]
#set_property IOSTANDARD DIFF_SSTL15 [get_ports {mgt_clk0_p}]
#set_property IOSTANDARD LVCMOS15 [get_ports {mgt_clk0_p}]
#set_property IOSTANDARD LVCMOS15 [get_ports {mgt_clk0_n}]

#set_property IOSTANDARD LVCMOS15 [get_ports {reset_n}]