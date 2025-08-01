//--------------------------------------------------------------------------------------------------
//  _  __  _       ___    _  __    ___  __   __  ___   _____   ___   __  __   ___
// | |/ / | |     / _ \  | |/ /   / __| \ \ / / / __| |_   _| | __| |  \/  | / __|
// | ' <  | |__  | (_) | | ' <    \__ \  \ V /  \__ \   | |   | _|  | |\/| | \__ \
// |_|\_\ |____|  \___/  |_|\_\   |___/   |_|   |___/   |_|   |___| |_|  |_| |___/
//
// This program is Confidential and Proprietary product of Klok Systems. Any unauthorized use,
// reproduction or transfer of this program is strictly prohibited unless written authorization
// from Klok Systems. (c) 2019 Klok Systems India Private Limited - All Rights Reserved
//-------------------------------------------------------------------------------------------------
// FILE NAME     : tb_ReRAM_Wishbone_Interface
// AUTHOR        :
//-------------------------------------------------------------------------------------------------
// Description:
//
//
//-------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_ReRAM_Wishbone_Interface;

  // DUT signals
  logic         wb_clk_i;
  logic         wb_rst_i;
  logic         wbs_stb_i;
  logic         wbs_cyc_i;
  logic         wbs_we_i;
  logic  [3:0]  wbs_sel_i;
  logic  [31:0] wbs_dat_i;
  logic  [31:0] wbs_adr_i;
  logic         wbs_ack_o;
  logic  [31:0] wbs_dat_o;
	
	logic [4:0] row_addr;
	logic [4:0] col_addr;
	logic [7:0] rand_data;

  // Instantiate DUT
  ReRAM_Wishbone_Interface dut (
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_dat_o(wbs_dat_o)
  );

  // Clock generation
  initial wb_clk_i = 0;
  always #5 wb_clk_i = ~wb_clk_i; // 100 MHz clock

  // Task: Wishbone Write
  task wishbone_write(input [31:0] addr, input [31:0] data);
    begin
      @(posedge wb_clk_i);
      wbs_stb_i <= 1;
      wbs_cyc_i <= 1;
      wbs_we_i  <= 0;
      wbs_adr_i <= addr;
      wbs_dat_i <= data;
      wbs_sel_i <= 4'b0010;
      wait (wbs_ack_o);
      @(posedge wb_clk_i);
      wbs_stb_i <= 0;
      wbs_cyc_i <= 0;
      wbs_dat_i <= 32'hzzzzzzzz;
    end
  endtask
	
	// Task: Wishbone Write
  task wishbone_write_mul(int count);
    begin
		  @(posedge wb_clk_i);
		  for(int i=0; i<count; i++) begin
			  row_addr = $random;
				col_addr = $random;
				rand_data = $random;
        wbs_stb_i = 1;
        wbs_cyc_i = 1;
        wbs_we_i  = 0;
        wbs_adr_i = 32'h3000_000c;
        wbs_sel_i = 4'b0010;
				//#1ps;
				$display($realtime,"row_addr %b, col_addr %b, rand_data %b",row_addr, col_addr, rand_data);
        wbs_dat_i = ({2'b00, row_addr, col_addr, 4'b0000, 8'h00, rand_data});
        // wbs_dat_i = ($random);
				$display($realtime,"wbs_dat_i %h",wbs_dat_i);
        @(posedge wb_clk_i);
        wait (wbs_ack_o);
			end
			wbs_stb_i <= 0;
      wbs_cyc_i <= 0;
    end
  endtask

  // Task: Wishbone Read
  task wishbone_read(input [31:0] addr);
    begin
      @(posedge wb_clk_i);
      wbs_stb_i <= 1;
      wbs_cyc_i <= 1;
      wbs_we_i  <= 1;
      wbs_adr_i <= addr;
      wbs_sel_i <= 4'b0010;
      wait (wbs_ack_o);
      @(posedge wb_clk_i);
      $display("[TB] Read result = %h at time %0t", wbs_dat_o, $time);
      wbs_stb_i <= 0;
      wbs_cyc_i <= 0;
    end
  endtask
	
	// Task: Wishbone Read
  task wishbone_read_mul(int count);
    begin
		  @(posedge wb_clk_i);
		  for(int i=0; i<count; i++) begin
        @(posedge wb_clk_i);
        wbs_stb_i <= 1;
        wbs_cyc_i <= 1;
        wbs_we_i  <= 1;
        wbs_adr_i <= 32'h3000_000c;
        wbs_sel_i <= 4'b0010;
        wait (wbs_ack_o);
			end
			// wbs_stb_i <= 0;
      // wbs_cyc_i <= 0;
      // wbs_we_i  <= 0;
    end
  endtask

  initial begin
    // Initialize
    wb_rst_i = 1;
    wbs_stb_i = 0;
    wbs_cyc_i = 0;
    wbs_we_i  = 0;
    wbs_sel_i = 4'b0000;
    wbs_adr_i = 32'd0;
    wbs_dat_i = 32'd0;

    // Wait and release reset
    #20 wb_rst_i = 0;

    // Write data to array using FIFO-like write
    // Format: {2'b0, row[4:0], col[4:0], 4'd0, data[15:0]}
    //wishbone_write(32'h3000_000c, {2'b00, 5'd2, 5'd3, 4'd0, 16'hBEEF}); // row=2 col=3
    //wishbone_write(32'h3000_000c, {2'b00, 5'd5, 5'd7, 4'd0, 16'hCAFE}); // row=5 col=7
		@(posedge wb_clk_i);
		wishbone_write_mul(32);
		

    // Wait to allow writes to complete and queue to update
    #2000;

    // Read back from the array memory
    // wishbone_read(32'h3000_000c); // should return BEEF
		wishbone_read_mul(5);
    #100;
    //wishbone_read({2'b00, 5'd5, 5'd7, 20'd0}); // should return CAFE

    #7000;
		
		wbs_stb_i = 0;
    wbs_cyc_i = 0;
		
		#100;
		
		@(posedge wb_clk_i);
		wishbone_write_mul(10);
		
		// Wait to allow writes to complete and queue to update
    #1000;
		
		wishbone_read_mul(5);
    #100;
    //wishbone_read({2'b00, 5'd5, 5'd7, 20'd0}); // should return CAFE

    #13000;
		
		wbs_stb_i = 0;
    wbs_cyc_i = 0;
		
		#500;
		
		@(posedge wb_clk_i);
		wishbone_write_mul(25);
		
		#500;
		
		wishbone_read_mul(5);
    #100;
    //wishbone_read({2'b00, 5'd5, 5'd7, 20'd0}); // should return CAFE

    #11000;
		
		
    $finish;
  end

endmodule
