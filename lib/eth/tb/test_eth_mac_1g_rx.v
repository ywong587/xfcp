/*

Copyright (c) 2015-2016 Alex Forencich

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
 * Testbench for eth_mac_1g_rx
 */
module test_eth_mac_1g_rx;

// Parameters

// Inputs
reg clk = 0;
reg rst = 0;
reg [7:0] current_test = 0;

reg [7:0] gmii_rxd = 0;
reg gmii_rx_dv = 0;
reg gmii_rx_er = 0;

// Outputs
wire [7:0] output_axis_tdata;
wire output_axis_tvalid;
wire output_axis_tlast;
wire output_axis_tuser;
wire error_bad_frame;
wire error_bad_fcs;

initial begin
    // myhdl integration
    $from_myhdl(
        clk,
        rst,
        current_test,
        gmii_rxd,
        gmii_rx_dv,
        gmii_rx_er
    );
    $to_myhdl(
        output_axis_tdata,
        output_axis_tvalid,
        output_axis_tlast,
        output_axis_tuser,
        error_bad_frame,
        error_bad_fcs
    );

    // dump file
    $dumpfile("test_eth_mac_1g_rx.lxt");
    $dumpvars(0, test_eth_mac_1g_rx);
end

eth_mac_1g_rx
UUT (
    .clk(clk),
    .rst(rst),
    .gmii_rxd(gmii_rxd),
    .gmii_rx_dv(gmii_rx_dv),
    .gmii_rx_er(gmii_rx_er),
    .output_axis_tdata(output_axis_tdata),
    .output_axis_tvalid(output_axis_tvalid),
    .output_axis_tlast(output_axis_tlast),
    .output_axis_tuser(output_axis_tuser),
    .error_bad_frame(error_bad_frame),
    .error_bad_fcs(error_bad_fcs)
);

endmodule
