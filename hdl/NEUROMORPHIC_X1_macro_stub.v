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

module NEUROMORPHIC_X1_macro (
    DO,
    ScanOutCC,
    AD,
    BEN,
    CLKin,
    DI,
    EN,
    R_WB,
    ScanInCC,
    ScanInDL,
    ScanInDR,
    SM,
    TM,
    RSTin,
    vgnd,
    vnb,
    vpb,
    vpwra,
    vpwrac,
    vpwrm,
    vpwrp,
    vpwrpc
);
    output [31:0] DO;
    output ScanOutCC;
    input [31:0] DI;
    input [31:0] BEN;
    input [31:0] AD;
    input EN;
    input R_WB;
    input CLKin;
    input RSTin;
    input TM;
    input SM;
    input ScanInCC;
    input ScanInDL;
    input ScanInDR;
    input vpwrac;
    input vpwrpc;
    input vgnd;
    input vpwrm;

`ifdef NEUROMORPHIC_X1_PA_SIM
    inout vpwra;
`else
    input vpwra;
`endif

`ifdef NEUROMORPHIC_X1_PA_SIM
    inout vpwrp;
`else
    input vpwrp;
`endif

    input vnb;
    input vpb;

endmodule
