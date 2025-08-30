// SPDX-FileCopyrightText: 2024 BM Labs and its Licensors, All Rights Reserved
// ========================================================================================
//
//  This software is protected by copyright and other intellectual property
//  rights. Therefore, reproduction, modification, translation, compilation, or
//  representation of this software in any manner other than expressly permitted
//  is strictly prohibited.
//
//  You may access and use this software, solely as provided, solely for the purpose of
//  integrating into semiconductor chip designs that you create as a part of the
//  BM Labs production programs (and solely for use and fabrication as a part of
//  BM Labs production purposes and for no other purpose.  You may not modify or
//  convey the software for any other purpose.
//
//  Disclaimer: BM LABS AND ITS LICENSORS MAKE NO WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, WITH REGARD TO THIS MATERIAL, AND EXPRESSLY DISCLAIM
//  ANY AND ALL WARRANTIES OF ANY KIND INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
//  PURPOSE. BM Labs reserves the right to make changes without further
//  notice to the materials described herein. Neither BM Labs nor any of its licensors
//  assume any liability arising out of the application or use of any product or
//  circuit described herein. BM Labs products described herein are
//  not authorized for use as components in life-support devices.
//
//  If you have a separate agreement with BM Labs pertaining to the use of this software
//  then that agreement shall control.

`timescale 1ns / 1ps

module Neuromorphic_X1_wb (
  // Clocks & resets
  input         user_clk,       // user clock
  input         user_rst,       // user reset (Active Low)
  input         wb_clk_i,       // Wishbone clock
  input         wb_rst_i,       // Wishbone reset (Active High)

  // Wishbone inputs
  input         wbs_stb_i,      // Wishbone strobe
  input         wbs_cyc_i,      // Wishbone cycle indicator
  input         wbs_we_i,       // Wishbone write enable
  input  [3:0]  wbs_sel_i,      // Wishbone byte select
  input  [31:0] wbs_dat_i,      // Wishbone write data
  input  [31:0] wbs_adr_i,      // Wishbone address

  // Wishbone outputs
  output [31:0] wbs_dat_o,      // Wishbone read data
  output        wbs_ack_o,      // Wishbone acknowledge

  // Scan/Test Pins
  input         ScanInCC,       // Scan enable
  input         ScanInDL,       // Data scan chain input (user_clk domain)
  input         ScanInDR,       // Data scan chain input (wb_clk domain)
  input         TM,             // Test mode
  output        ScanOutCC,      // Data scan chain output

  // Analog Pins
  input         Iref,           // 100 µA current reference
  input         VSS,            // 0 V analog ground
  input         Vcc_read,       // 0.3 V read rail
  input         Vcomp,          // 0.6 V comparator/reference bias
  input         Bias_comp2,     // 0.6 V comparator bias
  input         Vcc_wl_read,    // 0.7 V wordline read rail
  input         Vcc_wl_set,     // 1.8 V wordline set rail
  input         VDDA,           // 1.8 V analog supply
  input         VDDC,           // 1.8 V analog core digital supply
  input         Vbias,          // 1.8 V analog bias
  input         Vcc_wl_reset,   // 2.6 V wordline reset rail
  input         Vcc_set,        // 3.3 V array set rail
  input         Vcc_reset,      // 3.3 V array reset rail
  input         Vcc_L,          // 5 V level shifter supply
  input         Vcc_Body        // 5 V body-bias supply
);

endmodule

