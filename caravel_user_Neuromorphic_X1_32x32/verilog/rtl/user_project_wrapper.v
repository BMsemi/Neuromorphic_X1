`default_nettype none
module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1, inout vdda2,
    inout vssa1, inout vssa2,
    inout vccd1, inout vccd2,
    inout vssd1, inout vssd2,
`endif

    // Wishbone
    input         wb_clk_i,
    input         wb_rst_i,
    input         wbs_stb_i,
    input         wbs_cyc_i,
    input         wbs_we_i,
    input  [3:0]  wbs_sel_i,
    input  [31:0] wbs_dat_i,
    input  [31:0] wbs_adr_i,
    output        wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // Digital IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog IOs (analog_io[k] <-> GPIO pad k+7)
    inout  [`MPRJ_IO_PADS-10:0] analog_io,

    // Extra user clock
    input   user_clock2,

    // IRQs
    output [2:0] user_irq
);

    // -----------------------------
    // Scan/Test pins (inactive)
    // -----------------------------
    wire ScanInCC = 1'b0;
    wire ScanInDL = 1'b0;
    wire ScanInDR = 1'b0;
    wire TM       = 1'b0;
    wire ScanOutCC; // unused


    // ==========================================================
    // PAD analog_io[] mapping (index = PAD - 7)
    // Edit these PAD numbers to move pins to other GPIO pads.
    // ==========================================================
    localparam integer IREF_PAD         = 7;
    localparam integer VCC_READ_PAD     = 8;
    localparam integer VCOMP_PAD        = 9;
    localparam integer BIAS_COMP2_PAD   = 10;
    localparam integer VCC_WL_READ_PAD  = 11;
    localparam integer VCC_WL_SET_PAD   = 12;
    localparam integer VBIAS_PAD        = 13;
    localparam integer VCC_WL_RESET_PAD = 14;
    localparam integer VCC_SET_PAD      = 15;
    localparam integer VCC_RESET_PAD    = 16;
    localparam integer VCC_L_PAD        = 17;
    localparam integer VCC_BODY_PAD     = 18;

    // Compute analog_io indices from pad numbers
    localparam integer IREF_IDX         = IREF_PAD         - 7;
    localparam integer VCC_READ_IDX     = VCC_READ_PAD     - 7;
    localparam integer VCOMP_IDX        = VCOMP_PAD        - 7;
    localparam integer BIAS_COMP2_IDX   = BIAS_COMP2_PAD   - 7;
    localparam integer VCC_WL_READ_IDX  = VCC_WL_READ_PAD  - 7;
    localparam integer VCC_WL_SET_IDX   = VCC_WL_SET_PAD   - 7;
    localparam integer VBIAS_IDX        = VBIAS_PAD        - 7;
    localparam integer VCC_WL_RESET_IDX = VCC_WL_RESET_PAD - 7;
    localparam integer VCC_SET_IDX      = VCC_SET_PAD      - 7;
    localparam integer VCC_RESET_IDX    = VCC_RESET_PAD    - 7;
    localparam integer VCC_L_IDX        = VCC_L_PAD        - 7;
    localparam integer VCC_BODY_IDX     = VCC_BODY_PAD     - 7;

    // Wires from analog_io bus (inputs to the macro)
    wire Iref         = analog_io[IREF_IDX];
    wire Vcc_read     = analog_io[VCC_READ_IDX];
    wire Vcomp        = analog_io[VCOMP_IDX];
    wire Bias_comp2   = analog_io[BIAS_COMP2_IDX];
    wire Vcc_wl_read  = analog_io[VCC_WL_READ_IDX];
    wire Vcc_wl_set   = analog_io[VCC_WL_SET_IDX];
    wire Vbias        = analog_io[VBIAS_IDX];
    wire Vcc_wl_reset = analog_io[VCC_WL_RESET_IDX];
    wire Vcc_set      = analog_io[VCC_SET_IDX];
    wire Vcc_reset    = analog_io[VCC_RESET_IDX];
    wire Vcc_L        = analog_io[VCC_L_IDX];
    wire Vcc_Body     = analog_io[VCC_BODY_IDX];

    // Keep unused buses quiet
    assign la_data_out = 128'b0;
    assign io_out      = {`MPRJ_IO_PADS{1'b0}};
    assign io_oeb      = {`MPRJ_IO_PADS{1'b1}}; // all digital IOs as inputs
    assign user_irq    = 3'b000;

    // -----------------------------
    // Instantiate your hard macro
    // -----------------------------
   Neuromorphic_X1_wb i_core (
`ifdef USE_POWER_PINS
  .VDDC (vccd1),
  .VDDA (vdda1),
  .VSS  (vssa1),
`endif

  // Clocks / resets
  .user_clk (wb_clk_i),
  .user_rst (wb_rst_i),
  .wb_clk_i (wb_clk_i),
  .wb_rst_i (wb_rst_i),

  // Wishbone
  .wbs_stb_i (wbs_stb_i),
  .wbs_cyc_i (wbs_cyc_i),
  .wbs_we_i  (wbs_we_i),
  .wbs_sel_i (wbs_sel_i),
  .wbs_dat_i (wbs_dat_i),
  .wbs_adr_i (wbs_adr_i),
  .wbs_dat_o (wbs_dat_o),
  .wbs_ack_o (wbs_ack_o),

  // Scan/Test
  .ScanInCC  (1'b0),
  .ScanInDL  (1'b0),
  .ScanInDR  (1'b0),
  .TM        (1'b0),
  .ScanOutCC (/* unconnected */),

  // Analog / bias pins (drive from analog_io[] wires you already built)
  .Iref          (Iref),
  .Vcc_read      (Vcc_read),
  .Vcomp         (Vcomp),
  .Bias_comp2    (Bias_comp2),
  .Vcc_wl_read   (Vcc_wl_read),
  .Vcc_wl_set    (Vcc_wl_set),
  .Vbias         (Vbias),
  .Vcc_wl_reset  (Vcc_wl_reset),
  .Vcc_set       (Vcc_set),
  .Vcc_reset     (Vcc_reset),
  .Vcc_L         (Vcc_L),
  .Vcc_Body      (Vcc_Body)
);
endmodule
`default_nettype wire

