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
 * Testbench for ip_eth_tx_64
 */
module test_ip_eth_tx_64;

// Inputs
reg clk = 0;
reg rst = 0;
reg [7:0] current_test = 0;

reg input_ip_hdr_valid = 0;
reg [47:0] input_eth_dest_mac = 0;
reg [47:0] input_eth_src_mac = 0;
reg [15:0] input_eth_type = 0;
reg [5:0] input_ip_dscp = 0;
reg [1:0] input_ip_ecn = 0;
reg [15:0] input_ip_length = 0;
reg [15:0] input_ip_identification = 0;
reg [2:0] input_ip_flags = 0;
reg [12:0] input_ip_fragment_offset = 0;
reg [7:0] input_ip_ttl = 0;
reg [7:0] input_ip_protocol = 0;
reg [31:0] input_ip_source_ip = 0;
reg [31:0] input_ip_dest_ip = 0;
reg [63:0] input_ip_payload_tdata = 0;
reg [7:0] input_ip_payload_tkeep = 0;
reg input_ip_payload_tvalid = 0;
reg input_ip_payload_tlast = 0;
reg input_ip_payload_tuser = 0;
reg output_eth_hdr_ready = 0;
reg output_eth_payload_tready = 0;

// Outputs
wire input_ip_hdr_ready;
wire input_ip_payload_tready;
wire output_eth_hdr_valid;
wire [47:0] output_eth_dest_mac;
wire [47:0] output_eth_src_mac;
wire [15:0] output_eth_type;
wire [63:0] output_eth_payload_tdata;
wire [7:0] output_eth_payload_tkeep;
wire output_eth_payload_tvalid;
wire output_eth_payload_tlast;
wire output_eth_payload_tuser;
wire busy;
wire error_payload_early_termination;

initial begin
    // myhdl integration
    $from_myhdl(
        clk,
        rst,
        current_test,
        input_ip_hdr_valid,
        input_eth_dest_mac,
        input_eth_src_mac,
        input_eth_type,
        input_ip_dscp,
        input_ip_ecn,
        input_ip_length,
        input_ip_identification,
        input_ip_flags,
        input_ip_fragment_offset,
        input_ip_ttl,
        input_ip_protocol,
        input_ip_source_ip,
        input_ip_dest_ip,
        input_ip_payload_tdata,
        input_ip_payload_tkeep,
        input_ip_payload_tvalid,
        input_ip_payload_tlast,
        input_ip_payload_tuser,
        output_eth_hdr_ready,
        output_eth_payload_tready
    );
    $to_myhdl(
        input_ip_hdr_ready,
        input_ip_payload_tready,
        output_eth_hdr_valid,
        output_eth_dest_mac,
        output_eth_src_mac,
        output_eth_type,
        output_eth_payload_tdata,
        output_eth_payload_tkeep,
        output_eth_payload_tvalid,
        output_eth_payload_tlast,
        output_eth_payload_tuser,
        busy,
        error_payload_early_termination
    );

    // dump file
    $dumpfile("test_ip_eth_tx_64.lxt");
    $dumpvars(0, test_ip_eth_tx_64);
end

ip_eth_tx_64
UUT (
    .clk(clk),
    .rst(rst),
    // IP frame input
    .input_ip_hdr_valid(input_ip_hdr_valid),
    .input_ip_hdr_ready(input_ip_hdr_ready),
    .input_eth_dest_mac(input_eth_dest_mac),
    .input_eth_src_mac(input_eth_src_mac),
    .input_eth_type(input_eth_type),
    .input_ip_dscp(input_ip_dscp),
    .input_ip_ecn(input_ip_ecn),
    .input_ip_length(input_ip_length),
    .input_ip_identification(input_ip_identification),
    .input_ip_flags(input_ip_flags),
    .input_ip_fragment_offset(input_ip_fragment_offset),
    .input_ip_ttl(input_ip_ttl),
    .input_ip_protocol(input_ip_protocol),
    .input_ip_source_ip(input_ip_source_ip),
    .input_ip_dest_ip(input_ip_dest_ip),
    .input_ip_payload_tdata(input_ip_payload_tdata),
    .input_ip_payload_tkeep(input_ip_payload_tkeep),
    .input_ip_payload_tvalid(input_ip_payload_tvalid),
    .input_ip_payload_tready(input_ip_payload_tready),
    .input_ip_payload_tlast(input_ip_payload_tlast),
    .input_ip_payload_tuser(input_ip_payload_tuser),
    // Ethernet frame output
    .output_eth_hdr_valid(output_eth_hdr_valid),
    .output_eth_hdr_ready(output_eth_hdr_ready),
    .output_eth_dest_mac(output_eth_dest_mac),
    .output_eth_src_mac(output_eth_src_mac),
    .output_eth_type(output_eth_type),
    .output_eth_payload_tdata(output_eth_payload_tdata),
    .output_eth_payload_tkeep(output_eth_payload_tkeep),
    .output_eth_payload_tvalid(output_eth_payload_tvalid),
    .output_eth_payload_tready(output_eth_payload_tready),
    .output_eth_payload_tlast(output_eth_payload_tlast),
    .output_eth_payload_tuser(output_eth_payload_tuser),
    // Status signals
    .busy(busy),
    .error_payload_early_termination(error_payload_early_termination)
);

endmodule
