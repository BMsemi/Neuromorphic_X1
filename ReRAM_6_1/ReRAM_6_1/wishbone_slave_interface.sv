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
// FILE NAME     : wishbone_slave_interface
// AUTHOR        :
//-------------------------------------------------------------------------------------------------
// Description:
//
//
//-------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module wishbone_slave_interface (
  input  logic        wb_clk_i,
  input  logic        wb_rst_i,
  input  logic        wbs_stb_i,
  input  logic        wbs_cyc_i,
  input  logic        wbs_we_i,
  input  logic [31:0] wbs_adr_i,
  input  logic [31:0] wbs_dat_i,
	input  logic [3:0]  wbs_sel_i,
  output logic [31:0] wbs_dat_o,
  output logic        wbs_ack_o,

  // Connections to functional block
  output logic        R_WB,
  output logic        EN,
  input  logic [31:0] read_data,
  input  logic        func_ack
);

  parameter ADDR_MATCH = 32'h3000_000c;

  assign EN = (wbs_stb_i && wbs_cyc_i && (wbs_adr_i == ADDR_MATCH) && (wbs_sel_i == 4'b0010));
  assign R_WB = wbs_we_i;

  assign wbs_dat_o = read_data;
  assign wbs_ack_o = func_ack;

endmodule