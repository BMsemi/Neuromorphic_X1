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
// FILE NAME     : ReRAM_functional
// AUTHOR        :
//-------------------------------------------------------------------------------------------------
// Description:
//
//
//-------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module ReRAM_functional (
  input  logic        wb_clk_i,
  input  logic        wb_rst_i,
  input  logic        EN,
  input  logic        R_WB,
  input  logic [31:0] wbs_dat_i,
  output logic [31:0] read_data,
  output logic        func_ack
);

  parameter RD_Dly       = 44;
  parameter WR_Dly       = 0;
  parameter RD_Data_hold = 1;

  logic [31:0] ip_queue_data [$];
  logic [31:0] array_mem_queue [$];
  logic [31:0] ip_reg, op_reg, op_reg_1;
  logic [15:0] array_mem [0:31][0:31];
  int          count = 0;

  always @(posedge wb_clk_i or posedge wb_rst_i) begin
    if (wb_rst_i) begin
      func_ack <= 0;
      read_data <= 32'd0;
      ip_queue_data.delete();
      array_mem_queue.delete();
    end else begin
      func_ack <= 0;

      if (EN && !R_WB && count < 32) begin
        ip_queue_data.push_front(wbs_dat_i);
        count++;
        func_ack <= 1;

        if (ip_queue_data.size() > 0) begin
          ip_reg = ip_queue_data.pop_back();
          array_mem_queue.push_front(ip_reg);
          array_mem[ip_reg[29:25]][ip_reg[24:20]] = ip_reg[15:0];
        end

        $display("[WRITE] @%0t: Pushed %h | Count = %0d", $realtime, wbs_dat_i, count);

      end else if (EN && R_WB && array_mem_queue.size() > 0) begin
        read_sequence: begin
          for (int i = 0; i < RD_Dly; i++) begin
            if (!EN) begin
              $display("[READ] Aborted early @%0t", $realtime);
              disable read_sequence;
            end
            @(posedge wb_clk_i);
          end

          op_reg   = array_mem_queue.pop_back();
          op_reg_1 = {16'd0, array_mem[op_reg[29:25]][op_reg[24:20]]};
          read_data <= op_reg_1;
          func_ack <= 1;
          count--;
          $display("[READ] @%0t: Popped %h | Count = %0d", $realtime, op_reg_1, count);

          for (int j = 0; j < RD_Data_hold; j++) @(posedge wb_clk_i);
          func_ack <= 0;
        end
      end
    end
  end

endmodule
