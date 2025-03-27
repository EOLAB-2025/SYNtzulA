`timescale 1ns / 1ps
`default_nettype none
module servant_tb;

   parameter memfile = "firmware/exe.hex";
   parameter memsize = 8192;
   parameter with_csr = 1;

   reg wb_clk = 1'b0;
   reg wb_rst = 1'b1;

   wire q;
   reg [2:0] buttons = 15;

   //always  #31 wb_clk <= !wb_clk;
   //always  #12.5 wb_clk <= !wb_clk;	// 40 MHz
   always    #22.5 wb_clk <= !wb_clk;	// 22 MHz   
   
   initial #62 wb_rst <= 1'b0;

   //vlog_tb_utils vtu();

   uart_decoder #(57600) uart_decoder (q);

   servant_sim
     #(.memfile  (memfile),
       .memsize  (memsize),
       .with_csr (with_csr))
   servant_sim_i
     (.wb_clk (wb_clk),
      .wb_rst (wb_rst),
      .pc_adr (),
      .pc_vld (),
      .q      (q),
      .buttons(buttons));


parameter OUTPUT_FILE_TARGET = {"sim/results/",`PATH,"/snn_inference.txt"};
parameter TARGET_FILE = {"sim/target/",`PATH,"/snn_inference.txt"};
parameter TARGET_FILE_BINNING= {"sim/target/",`PATH,"/encoded_input.txt"};
parameter OUTPUT_FILE_BINNING = {"sim/results/",`PATH,"/encoded_input.txt"};

parameter MAX_ERRORS = 1000;

integer i,j,k;
integer f_in, f_out_spikes,f_t;
integer f_t_bin, f_out_bin;
integer f_out_target, f_out;
integer f_out_snn_L1, f_t_L1;
integer f_out_snn_L2, f_t_L2;
integer f_out_snn_L3, f_t_L3;



initial begin
 
	`ifdef SIM_RTL   
		$dumpfile("tb_rtl.vcd"); 
	`endif
	

	$dumpvars(0, servant_tb); 
	

        f_out_target =  $fopen(TARGET_FILE,"r");
        f_out =         $fopen(OUTPUT_FILE_TARGET,"w");
    
	f_t_bin =       $fopen(TARGET_FILE_BINNING,"r");
	f_out_bin =     $fopen(OUTPUT_FILE_BINNING,"w");

    //wait(dut.control_i.state == 11);
	#20000
	buttons = 0;
	#700000000; 

	//$fclose(f_out_spikes);
        $fclose(f_out);
	$fclose(f_out_target);
	$fclose(f_out_bin);	
	$fclose(f_t_bin);	

    //$finish;

end


	/*
	  ___        __                              
	 |_ _|_ __  / _| ___ _ __ ___ _ __   ___ ___ 
	  | || '_ \| |_ / _ \ '__/ _ \ '_ \ / __/ _ \
	  | || | | |  _|  __/ | |  __/ | | | (_|  __/
	 |___|_| |_|_|  \___|_|  \___|_| |_|\___\___|
		                                         
	*/

	reg signed [25:0] prediction_snn;
	reg signed [25:0] target_prediction_snn;
	integer ll = 0;
	integer errors_snn_inference = 0; integer n;
	integer dummy;

	wire signed [15:0] p1;
	wire signed [15:0] p2;
	wire valid_snn;
	wire [31:0] N4;
	
`ifndef QUAD	
	assign N4        = servant_sim_i.service_ihp_top.NEURON_4/2;
`else
	assign N4        = servant_sim_i.service_ihp_top.NEURON_4/4;
`endif

`ifndef PROVA_TB	
	assign valid_snn = servant_sim_i.service_ihp_top.service_ihp_chip.service_ihp.output_buffer_wr_en_debug;
	assign p1        = servant_sim_i.service_ihp_top.service_ihp_chip.service_ihp.p1;
	assign p2        = servant_sim_i.service_ihp_top.service_ihp_chip.service_ihp.p2;
`else


	assign p1[15] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[15] ;
	assign p1[14] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[14] ;
	assign p1[13] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[13] ;
	assign p1[12] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[12] ;
	assign p1[11] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[11] ;
	assign p1[10] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[10] ;
	assign p1[9]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[9]  ;
	assign p1[8]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[8]  ;
	assign p1[7]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[7]  ;
	assign p1[6]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[6]  ;
	assign p1[5]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[5]  ;
	assign p1[4]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[4]  ;
	assign p1[3]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[3]  ;
	assign p1[2]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[2]  ;
	assign p1[1]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[1]  ;
	assign p1[0]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p1[0]  ;
	
	assign p2[15] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[15] ;
	assign p2[14] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[14] ;
	assign p2[13] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[13] ;
	assign p2[12] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[12] ;
	assign p2[11] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[11] ;
	assign p2[10] = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[10] ;
	assign p2[9]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[9]  ;
	assign p2[8]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[8]  ;
	assign p2[7]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[7]  ;
	assign p2[6]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[6]  ;
	assign p2[5]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[5]  ;
	assign p2[4]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[4]  ;
	assign p2[3]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[3]  ;
	assign p2[2]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[2]  ;
	assign p2[1]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[1]  ;
	assign p2[0]  = servant_sim_i.service_ihp_top.service_ihp_chip. \service_ihp.mosquito.p2[0]  ;	
	
	//assign valid_snn  = servant_sim_i.service_ihp_top.service_ihp_chip._12528_;
	
	`ifdef QUAD
		//assign valid_snn  = servant_sim_i.service_ihp_top.service_ihp_chip._18198_;
		assign valid_snn  = servant_sim_i.service_ihp_top.service_ihp_chip._18350_;
	`endif


`endif


	  always begin
	      #1000000;  // wait 1 ms 
	      $display("Time: %d ms", $time / 1000000);
	  end



	reg [31:0] wr_cnt;	
	initial wr_cnt = 0; 

	always @(posedge wb_clk) begin
		if (valid_snn) begin
			ll <= ll + 1;			
			if(ll == wr_cnt) begin	
				wr_cnt <= wr_cnt + N4; 				
				$fwrite(f_out,"[%d,%d],\n", $signed(p1),$signed(p2));
		
				$display("Inference #%d: [%d, %d]",ll/N4,$signed(p1),$signed(p2));

				prediction_snn = p1;
				dummy = $fscanf(f_out_target, "%d,\n", target_prediction_snn);

					if(target_prediction_snn != prediction_snn) begin
						errors_snn_inference = errors_snn_inference + 1;
						$display("#SNN inference error detected @%d\n",ll+1);
						$display("target_inference = %d, inference = %d\n",target_prediction_snn,prediction_snn);
						if(errors_snn_inference > MAX_ERRORS) begin
						    $display("Exiting from L4 error checks\n");
						    $fclose(f_out_target);
						    $fclose(f_out);
							$fclose(f_out_bin);	
							$fclose(f_t_bin);	
						    #0.2
						    $finish;
						    
						end
					end
				
			end
		end
	end


endmodule
