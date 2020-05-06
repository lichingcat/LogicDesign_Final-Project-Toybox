## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
	
#Buttons
#    set_property PACKAGE_PIN U18 [get_ports rst_switch]                        
#        set_property IOSTANDARD LVCMOS33 [get_ports rst_switch]

# Switches
#set_property PACKAGE_PIN R2 [get_ports {play_switch}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {play_switch}]
#set_property PACKAGE_PIN V16 [get_ports {en}]					
#    set_property IOSTANDARD LVCMOS33 [get_ports {en}]
	
##Pmod Header JC
     ##Sch name = JB1
    set_property PACKAGE_PIN A14 [get_ports {rst_switch}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {rst_switch}]

    ##Sch name = JC1
    set_property PACKAGE_PIN K17 [get_ports {play_switch}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {play_switch}]
    ##Sch name = JC2
   # set_property PACKAGE_PIN M18 [get_ports {JC[1]}]                    
    #    set_property IOSTANDARD LVCMOS33 [get_ports {JC[1]}]
    ##Sch name = JC3
    #set_property PACKAGE_PIN N17 [get_ports {JC[2]}]                    
        #set_property IOSTANDARD LVCMOS33 [get_ports {JC[2]}]
    ##Sch name = JC4
    #set_property PACKAGE_PIN P18 [get_ports {JC[3]}]                    
        #set_property IOSTANDARD LVCMOS33 [get_ports {JC[3]}]
    #Sch name = JC7
    set_property PACKAGE_PIN L17 [get_ports {signal_out2[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out2[0]}]
    #Sch name = JC8
    set_property PACKAGE_PIN M19 [get_ports {signal_out2[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out2[1]}]
    #Sch name = JC9
    set_property PACKAGE_PIN P17 [get_ports {signal_out2[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out2[2]}]
    #Sch name = JC10
    set_property PACKAGE_PIN R18 [get_ports {signal_out2[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out2[3]}]

    #Sch name = JB7
    set_property PACKAGE_PIN A15 [get_ports {signal_out3[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out3[0]}]
    #Sch name = JB8
    set_property PACKAGE_PIN A17 [get_ports {signal_out3[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out3[1]}]
    #Sch name = JB9
    set_property PACKAGE_PIN C15 [get_ports {signal_out3[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out3[2]}]
    #Sch name = JB10
    set_property PACKAGE_PIN C16 [get_ports {signal_out3[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out3[3]}]


    #Sch name = JA7
    set_property PACKAGE_PIN H1 [get_ports {signal_out1[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out1[0]}]
    #Sch name = JA8
    set_property PACKAGE_PIN K2 [get_ports {signal_out1[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out1[1]}]
    #Sch name = JA9
    set_property PACKAGE_PIN H2 [get_ports {signal_out1[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out1[2]}]
    #Sch name = JA10
    set_property PACKAGE_PIN G3 [get_ports {signal_out1[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {signal_out1[3]}]
        

    #leds
    set_property PACKAGE_PIN V19 [get_ports {LED[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
    set_property PACKAGE_PIN U19 [get_ports {LED[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
    set_property PACKAGE_PIN E19 [get_ports {LED[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
    set_property PACKAGE_PIN U16 [get_ports {LED[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]

    set_property PACKAGE_PIN L1 [get_ports {LED_state[4]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED_state[4]}]
    set_property PACKAGE_PIN P1 [get_ports {LED_state[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED_state[3]}]
    set_property PACKAGE_PIN N3 [get_ports {LED_state[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED_state[2]}]
    set_property PACKAGE_PIN P3 [get_ports {LED_state[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED_state[1]}]
    set_property PACKAGE_PIN U3 [get_ports {LED_state[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED_state[0]}]
    
    set_property PACKAGE_PIN V3 [get_ports {mode4_handout_count[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {mode4_handout_count[2]}]
    set_property PACKAGE_PIN V13 [get_ports {mode4_handout_count[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {mode4_handout_count[1]}]
    set_property PACKAGE_PIN V14 [get_ports {mode4_handout_count[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {mode4_handout_count[0]}]
        
    set_property PACKAGE_PIN U15 [get_ports {LED_switch}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {LED_switch}]
       
#         #leds
#           set_property PACKAGE_PIN U16 [get_ports {signal_out[0]}]                    
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[0]}]
#           #Sch name = JC8
#           set_property PACKAGE_PIN E19 [get_ports {signal_out[1]}]                    
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[1]}]
#           #Sch name = JC9
#           set_property PACKAGE_PIN U19 [get_ports {signal_out[2]}]                    
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[2]}]
#           #Sch name = JC10
#           set_property PACKAGE_PIN V19 [get_ports {signal_out[3]}]                    
#               set_property IOSTANDARD LVCMOS33 [get_ports {signal_out[3]}]
               
               
               set_property CFGBVS Vcco [current_design]
               set_property config_voltage 3.3 [current_design]
