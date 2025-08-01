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
// FILE NAME     : ReRAM_Wishbone_Interface
// AUTHOR        :
//-------------------------------------------------------------------------------------------------
// Description:
//
//
//-------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module ReRAM_Wishbone_Interface (
  input  logic        wb_clk_i,
  input  logic        wb_rst_i,
  input  logic        wbs_stb_i,
  input  logic        wbs_cyc_i,
  input  logic        wbs_we_i,
  input  logic [3:0]  wbs_sel_i,
  input  logic [31:0] wbs_dat_i,
  input  logic [31:0] wbs_adr_i,
  output logic        wbs_ack_o,
  output logic [31:0] wbs_dat_o
);

  logic do_write, do_read;
  logic [31:0] read_data;
  logic func_ack;

  // Instantiate protocol handler
  wishbone_slave_interface wishbone_if (
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_we_i(wbs_we_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_dat_o(wbs_dat_o),
    .wbs_ack_o(wbs_ack_o),
    .R_WB(R_WB),
    .EN(EN),
    .read_data(read_data),
    .func_ack(func_ack)
  );

  // Instantiate functional logic
  ReRAM_functional functional (
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .EN(EN),
    .R_WB(R_WB),
    .wbs_dat_i(wbs_dat_i),
    .read_data(read_data),
    .func_ack(func_ack)
  );

endmodule
