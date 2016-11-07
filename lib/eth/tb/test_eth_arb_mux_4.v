/*

Copyright (c) 2014-2016 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * Testbench for eth_arb_mux_4
 */
module test_eth_arb_mux_4;

// Inputs
reg clk = 0;
reg rst = 0;
reg [7:0] current_test = 0;

reg input_0_eth_hdr_valid = 0;
reg [47:0] input_0_eth_dest_mac = 0;
reg [47:0] input_0_eth_src_mac = 0;
reg [15:0] input_0_eth_type = 0;
reg [7:0] input_0_eth_payload_tdata = 0;
reg input_0_eth_payload_tvalid = 0;
reg input_0_eth_payload_tlast = 0;
reg input_0_eth_payload_tuser = 0;
reg input_1_eth_hdr_valid = 0;
reg [47:0] input_1_eth_dest_mac = 0;
reg [47:0] input_1_eth_src_mac = 0;
reg [15:0] input_1_eth_type = 0;
reg [7:0] input_1_eth_payload_tdata = 0;
reg input_1_eth_payload_tvalid = 0;
reg input_1_eth_payload_tlast = 0;
reg input_1_eth_payload_tuser = 0;
reg input_2_eth_hdr_valid = 0;
reg [47:0] input_2_eth_dest_mac = 0;
reg [47:0] input_2_eth_src_mac = 0;
reg [15:0] input_2_eth_type = 0;
reg [7:0] input_2_eth_payload_tdata = 0;
reg input_2_eth_payload_tvalid = 0;
reg input_2_eth_payload_tlast = 0;
reg input_2_eth_payload_tuser = 0;
reg input_3_eth_hdr_valid = 0;
reg [47:0] input_3_eth_dest_mac = 0;
reg [47:0] input_3_eth_src_mac = 0;
reg [15:0] input_3_eth_type = 0;
reg [7:0] input_3_eth_payload_tdata = 0;
reg input_3_eth_payload_tvalid = 0;
reg input_3_eth_payload_tlast = 0;
reg input_3_eth_payload_tuser = 0;

reg output_eth_hdr_ready = 0;
reg output_eth_payload_tready = 0;

// Outputs
wire input_0_eth_payload_tready;
wire input_0_eth_hdr_ready;
wire input_1_eth_payload_tready;
wire input_1_eth_hdr_ready;
wire input_2_eth_payload_tready;
wire input_2_eth_hdr_ready;
wire input_3_eth_payload_tready;
wire input_3_eth_hdr_ready;

wire output_eth_hdr_valid;
wire [47:0] output_eth_dest_mac;
wire [47:0] output_eth_src_mac;
wire [15:0] output_eth_type;
wire [7:0] output_eth_payload_tdata;
wire output_eth_payload_tvalid;
wire output_eth_payload_tlast;
wire output_eth_payload_tuser;

initial begin
    // myhdl integration
    $from_myhdl(
        clk,
        rst,
        current_test,
        input_0_eth_hdr_valid,
        input_0_eth_dest_mac,
        input_0_eth_src_mac,
        input_0_eth_type,
        input_0_eth_payload_tdata,
        input_0_eth_payload_tvalid,
        input_0_eth_payload_tlast,
        input_0_eth_payload_tuser,
        input_1_eth_hdr_valid,
        input_1_eth_dest_mac,
        input_1_eth_src_mac,
        input_1_eth_type,
        input_1_eth_payload_tdata,
        input_1_eth_payload_tvalid,
        input_1_eth_payload_tlast,
        input_1_eth_payload_tuser,
        input_2_eth_hdr_valid,
        input_2_eth_dest_mac,
        input_2_eth_src_mac,
        input_2_eth_type,
        input_2_eth_payload_tdata,
        input_2_eth_payload_tvalid,
        input_2_eth_payload_tlast,
        input_2_eth_payload_tuser,
        input_3_eth_hdr_valid,
        input_3_eth_dest_mac,
        input_3_eth_src_mac,
        input_3_eth_type,
        input_3_eth_payload_tdata,
        input_3_eth_payload_tvalid,
        input_3_eth_payload_tlast,
        input_3_eth_payload_tuser,
        output_eth_hdr_ready,
        output_eth_payload_tready
    );
    $to_myhdl(
        input_0_eth_hdr_ready,
        input_0_eth_payload_tready,
        input_1_eth_hdr_ready,
        input_1_eth_payload_tready,
        input_2_eth_hdr_ready,
        input_2_eth_payload_tready,
        input_3_eth_hdr_ready,
        input_3_eth_payload_tready,
        output_eth_hdr_valid,
        output_eth_dest_mac,
        output_eth_src_mac,
        output_eth_type,
        output_eth_payload_tdata,
        output_eth_payload_tvalid,
        output_eth_payload_tlast,
        output_eth_payload_tuser
    );

    // dump file
    $dumpfile("test_eth_arb_mux_4.lxt");
    $dumpvars(0, test_eth_arb_mux_4);
end

eth_arb_mux_4
UUT (
    .clk(clk),
    .rst(rst),
    // Ethernet frame inputs
    .input_0_eth_hdr_valid(input_0_eth_hdr_valid),
    .input_0_eth_hdr_ready(input_0_eth_hdr_ready),
    .input_0_eth_dest_mac(input_0_eth_dest_mac),
    .input_0_eth_src_mac(input_0_eth_src_mac),
    .input_0_eth_type(input_0_eth_type),
    .input_0_eth_payload_tdata(input_0_eth_payload_tdata),
    .input_0_eth_payload_tvalid(input_0_eth_payload_tvalid),
    .input_0_eth_payload_tready(input_0_eth_payload_tready),
    .input_0_eth_payload_tlast(input_0_eth_payload_tlast),
    .input_0_eth_payload_tuser(input_0_eth_payload_tuser),
    .input_1_eth_hdr_valid(input_1_eth_hdr_valid),
    .input_1_eth_hdr_ready(input_1_eth_hdr_ready),
    .input_1_eth_dest_mac(input_1_eth_dest_mac),
    .input_1_eth_src_mac(input_1_eth_src_mac),
    .input_1_eth_type(input_1_eth_type),
    .input_1_eth_payload_tdata(input_1_eth_payload_tdata),
    .input_1_eth_payload_tvalid(input_1_eth_payload_tvalid),
    .input_1_eth_payload_tready(input_1_eth_payload_tready),
    .input_1_eth_payload_tlast(input_1_eth_payload_tlast),
    .input_1_eth_payload_tuser(input_1_eth_payload_tuser),
    .input_2_eth_hdr_valid(input_2_eth_hdr_valid),
    .input_2_eth_hdr_ready(input_2_eth_hdr_ready),
    .input_2_eth_dest_mac(input_2_eth_dest_mac),
    .input_2_eth_src_mac(input_2_eth_src_mac),
    .input_2_eth_type(input_2_eth_type),
    .input_2_eth_payload_tdata(input_2_eth_payload_tdata),
    .input_2_eth_payload_tvalid(input_2_eth_payload_tvalid),
    .input_2_eth_payload_tready(input_2_eth_payload_tready),
    .input_2_eth_payload_tlast(input_2_eth_payload_tlast),
    .input_2_eth_payload_tuser(input_2_eth_payload_tuser),
    .input_3_eth_hdr_valid(input_3_eth_hdr_valid),
    .input_3_eth_hdr_ready(input_3_eth_hdr_ready),
    .input_3_eth_dest_mac(input_3_eth_dest_mac),
    .input_3_eth_src_mac(input_3_eth_src_mac),
    .input_3_eth_type(input_3_eth_type),
    .input_3_eth_payload_tdata(input_3_eth_payload_tdata),
    .input_3_eth_payload_tvalid(input_3_eth_payload_tvalid),
    .input_3_eth_payload_tready(input_3_eth_payload_tready),
    .input_3_eth_payload_tlast(input_3_eth_payload_tlast),
    .input_3_eth_payload_tuser(input_3_eth_payload_tuser),
    // Eth frame output
    .output_eth_hdr_valid(output_eth_hdr_valid),
    .output_eth_hdr_ready(output_eth_hdr_ready),
    .output_eth_dest_mac(output_eth_dest_mac),
    .output_eth_src_mac(output_eth_src_mac),
    .output_eth_type(output_eth_type),
    .output_eth_payload_tdata(output_eth_payload_tdata),
    .output_eth_payload_tvalid(output_eth_payload_tvalid),
    .output_eth_payload_tready(output_eth_payload_tready),
    .output_eth_payload_tlast(output_eth_payload_tlast),
    .output_eth_payload_tuser(output_eth_payload_tuser)
);

endmodule
