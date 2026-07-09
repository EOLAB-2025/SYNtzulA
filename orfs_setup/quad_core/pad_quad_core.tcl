make_io_sites -horizontal_site sg13g2_ioSite \
    -vertical_site sg13g2_ioSite \
    -corner_site sg13g2_ioSite \
    -offset 70 \
    -rotation_horizontal R0 \
    -rotation_vertical R0 \
    -rotation_corner R0

set padD    180; # pad depth (edge to core)
set padW     80; # pad width (beachfront)

set chipH  2735; # left/right (height)
set chipW  2485; # top/bottom (width)


# set offset 285;
set offset 535
set width 80;
set space_between_pad 10;

set width_corner 180;
set width_filler_100000 50;

place_pad -row IO_NORTH  -location [expr          70 + 180 + 50 + 0*(80)]    "pad_vssio0"  -master sg13g2_IOPadIOVss
place_pad -row IO_NORTH  -location [expr          70 + 180 + 50 + 1*(80)]    "pad_vddio0"  -master sg13g2_IOPadIOVdd 
place_pad -row IO_NORTH  -location [expr $chipH - 70 - 180 - 80    - 50]     "pad_vss0"    -master sg13g2_IOPadVss 
place_pad -row IO_NORTH  -location [expr $chipH - 70 - 180 - 80*2  - 50]     "pad_vdd0"    -master sg13g2_IOPadVdd 

place_pad -row IO_SOUTH  -location [expr          70 + 180 + 50 + 0*(80)]    "pad_vssio1"  -master sg13g2_IOPadIOVss    
place_pad -row IO_SOUTH  -location [expr          70 + 180 + 50 + 1*(80)]    "pad_vddio1"  -master sg13g2_IOPadIOVdd    
place_pad -row IO_SOUTH  -location [expr $chipH - 70 - 180 - 80    - 50]     "pad_vss1"    -master sg13g2_IOPadVss      
place_pad -row IO_SOUTH  -location [expr $chipH - 70 - 180 - 80*2  - 50]     "pad_vdd1"    -master sg13g2_IOPadVdd 


place_pad -row IO_EAST  -location [expr $offset  + 12*($width + $space_between_pad)]                 "pad_buttons_2" ; 
place_pad -row IO_EAST  -location [expr $offset  + 11*($width + $space_between_pad)]                 "pad_buttons_1" ;
place_pad -row IO_EAST  -location [expr $offset  + 10*($width + $space_between_pad)]                 "pad_buttons_0" ; 
place_pad -row IO_EAST  -location [expr $offset  + 9*($width + $space_between_pad)]                  "pad_timer_clk" ;
place_pad -row IO_EAST  -location [expr $offset  + 8*($width + $space_between_pad)]                  "pad_wb_rst" ;
place_pad -row IO_EAST  -location [expr $offset  + 7*($width + $space_between_pad)]                  "pad_uart_rx" ;
place_pad -row IO_EAST  -location [expr $offset  + 6*($width + $space_between_pad)]                  "pad_o_txd" ;
place_pad -row IO_EAST  -location [expr $offset  + 5*($width + $space_between_pad)]                  "pad_wb_clk" ; 
place_pad -row IO_EAST  -location [expr $offset  + 4*($width + $space_between_pad)]                 "pad_i_flash_miso" ; 
place_pad -row IO_EAST  -location [expr $offset  + 3*($width + $space_between_pad)]                  "pad_o_flash_ss" ; 
place_pad -row IO_EAST  -location [expr $offset  + 2*($width + $space_between_pad)]                  "pad_o_flash_sck" ; 
place_pad -row IO_EAST  -location [expr $offset  + 1*($width + $space_between_pad)]                  "pad_o_flash_mosi" ;

place_pad -row IO_WEST  -location [expr $offset  + 4*($width + $space_between_pad)]                  "pad_output_buffer_wr_en_debug" ;
place_pad -row IO_WEST  -location [expr $offset  + 5*($width + $space_between_pad)]                 "pad_enb_debug" ;




set iocorner sg13g2_Corner
set iofill [ list sg13g2_Filler10000 sg13g2_Filler4000 sg13g2_Filler2000 sg13g2_Filler1000 sg13g2_Filler400 sg13g2_Filler200 ]

place_corners $iocorner

place_io_fill -row IO_NORTH {*}$iofill
place_io_fill -row IO_SOUTH {*}$iofill
place_io_fill -row IO_WEST  {*}$iofill
place_io_fill -row IO_EAST  {*}$iofill

connect_by_abutment
place_bondpad -bond bondpad_70x70 -offset {5.0 -70.0} pad_*
#place_io_terminals pad_*/pad
remove_io_rows
