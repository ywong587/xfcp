#!/usr/bin/env python
"""

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

"""

from myhdl import *
import os

import axis_ep
import eth_ep
import gmii_ep

module = 'eth_mac_1g_tx'
testbench = 'test_%s' % module

srcs = []

srcs.append("../rtl/%s.v" % module)
srcs.append("../rtl/lfsr.v")
srcs.append("%s.v" % testbench)

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src)

def bench():

    # Parameters
    ENABLE_PADDING = 1
    MIN_FRAME_LENGTH = 64

    # Inputs
    clk = Signal(bool(0))
    rst = Signal(bool(0))
    current_test = Signal(intbv(0)[8:])

    input_axis_tdata = Signal(intbv(0)[8:])
    input_axis_tvalid = Signal(bool(0))
    input_axis_tlast = Signal(bool(0))
    input_axis_tuser = Signal(bool(0))
    ifg_delay = Signal(intbv(0)[8:])

    # Outputs
    input_axis_tready = Signal(bool(0))
    gmii_txd = Signal(intbv(0)[8:])
    gmii_tx_en = Signal(bool(0))
    gmii_tx_er = Signal(bool(0))

    # sources and sinks
    source_pause = Signal(bool(0))

    source = axis_ep.AXIStreamSource()

    source_logic = source.create_logic(
        clk,
        rst,
        tdata=input_axis_tdata,
        tvalid=input_axis_tvalid,
        tready=input_axis_tready,
        tlast=input_axis_tlast,
        tuser=input_axis_tuser,
        pause=source_pause,
        name='source'
    )

    sink = gmii_ep.GMIISink()

    sink_logic = sink.create_logic(
        clk,
        rst,
        rxd=gmii_txd,
        rx_dv=gmii_tx_en,
        rx_er=gmii_tx_er,
        name='sink'
    )

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        "vvp -m myhdl %s.vvp -lxt2" % testbench,
        clk=clk,
        rst=rst,
        current_test=current_test,

        input_axis_tdata=input_axis_tdata,
        input_axis_tvalid=input_axis_tvalid,
        input_axis_tready=input_axis_tready,
        input_axis_tlast=input_axis_tlast,
        input_axis_tuser=input_axis_tuser,

        gmii_txd=gmii_txd,
        gmii_tx_en=gmii_tx_en,
        gmii_tx_er=gmii_tx_er,

        ifg_delay=ifg_delay
    )

    @always(delay(4))
    def clkgen():
        clk.next = not clk

    @instance
    def check():
        yield delay(100)
        yield clk.posedge
        rst.next = 1
        yield clk.posedge
        rst.next = 0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge

        ifg_delay.next = 12

        # testbench stimulus

        for payload_len in list(range(1,18))+list(range(64,82)):
            yield clk.posedge
            print("test 1: test packet, length %d" % payload_len)
            current_test.next = 1

            test_frame = eth_ep.EthFrame()
            test_frame.eth_dest_mac = 0xDAD1D2D3D4D5
            test_frame.eth_src_mac = 0x5A5152535455
            test_frame.eth_type = 0x8000
            test_frame.payload = bytearray(range(payload_len))
            test_frame.update_fcs()

            axis_frame = test_frame.build_axis()

            source.send(axis_frame)
            yield clk.posedge
            yield clk.posedge

            while gmii_tx_en or input_axis_tvalid:
                yield clk.posedge

            yield clk.posedge
            yield clk.posedge
            yield clk.posedge

            rx_frame = sink.recv()

            assert rx_frame.data[0:8] == bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5')

            eth_frame = eth_ep.EthFrame()
            eth_frame.parse_axis_fcs(rx_frame.data[8:])

            print(hex(eth_frame.eth_fcs))
            print(hex(eth_frame.calc_fcs()))

            assert len(eth_frame.payload.data) == max(payload_len, 46)
            assert eth_frame.eth_fcs == eth_frame.calc_fcs()
            assert eth_frame.eth_dest_mac == test_frame.eth_dest_mac
            assert eth_frame.eth_src_mac == test_frame.eth_src_mac
            assert eth_frame.eth_type == test_frame.eth_type
            assert eth_frame.payload.data.index(test_frame.payload.data) == 0

            assert sink.empty()

            yield delay(100)

            yield clk.posedge
            print("test 2: back-to-back packets, length %d" % payload_len)
            current_test.next = 2

            test_frame1 = eth_ep.EthFrame()
            test_frame1.eth_dest_mac = 0xDAD1D2D3D4D5
            test_frame1.eth_src_mac = 0x5A5152535455
            test_frame1.eth_type = 0x8000
            test_frame1.payload = bytearray(range(payload_len))
            test_frame1.update_fcs()
            test_frame2 = eth_ep.EthFrame()
            test_frame2.eth_dest_mac = 0xDAD1D2D3D4D5
            test_frame2.eth_src_mac = 0x5A5152535455
            test_frame2.eth_type = 0x8000
            test_frame2.payload = bytearray(range(payload_len))
            test_frame2.update_fcs()

            axis_frame1 = test_frame1.build_axis()
            axis_frame2 = test_frame2.build_axis()

            source.send(axis_frame1)
            source.send(axis_frame2)
            yield clk.posedge
            yield clk.posedge

            while gmii_tx_en or input_axis_tvalid:
                yield clk.posedge

            yield clk.posedge
            yield clk.posedge
            yield clk.posedge

            rx_frame = sink.recv()

            assert rx_frame.data[0:8] == bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5')

            eth_frame = eth_ep.EthFrame()
            eth_frame.parse_axis_fcs(rx_frame.data[8:])

            print(hex(eth_frame.eth_fcs))
            print(hex(eth_frame.calc_fcs()))

            assert len(eth_frame.payload.data) == max(payload_len, 46)
            assert eth_frame.eth_fcs == eth_frame.calc_fcs()
            assert eth_frame.eth_dest_mac == test_frame1.eth_dest_mac
            assert eth_frame.eth_src_mac == test_frame1.eth_src_mac
            assert eth_frame.eth_type == test_frame1.eth_type
            assert eth_frame.payload.data.index(test_frame1.payload.data) == 0

            rx_frame = sink.recv()

            assert rx_frame.data[0:8] == bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5')

            eth_frame = eth_ep.EthFrame()
            eth_frame.parse_axis_fcs(rx_frame.data[8:])

            print(hex(eth_frame.eth_fcs))
            print(hex(eth_frame.calc_fcs()))

            assert len(eth_frame.payload.data) == max(payload_len, 46)
            assert eth_frame.eth_fcs == eth_frame.calc_fcs()
            assert eth_frame.eth_dest_mac == test_frame2.eth_dest_mac
            assert eth_frame.eth_src_mac == test_frame2.eth_src_mac
            assert eth_frame.eth_type == test_frame2.eth_type
            assert eth_frame.payload.data.index(test_frame2.payload.data) == 0

            assert sink.empty()

            yield delay(100)

            yield clk.posedge
            print("test 3: tuser assert, length %d" % payload_len)
            current_test.next = 3

            test_frame1 = eth_ep.EthFrame()
            test_frame1.eth_dest_mac = 0xDAD1D2D3D4D5
            test_frame1.eth_src_mac = 0x5A5152535455
            test_frame1.eth_type = 0x8000
            test_frame1.payload = bytearray(range(payload_len))
            test_frame1.update_fcs()
            test_frame2 = eth_ep.EthFrame()
            test_frame2.eth_dest_mac = 0xDAD1D2D3D4D5
            test_frame2.eth_src_mac = 0x5A5152535455
            test_frame2.eth_type = 0x8000
            test_frame2.payload = bytearray(range(payload_len))
            test_frame2.update_fcs()

            axis_frame1 = test_frame1.build_axis()
            axis_frame2 = test_frame2.build_axis()

            axis_frame1.user = 1

            source.send(axis_frame1)
            source.send(axis_frame2)
            yield clk.posedge
            yield clk.posedge

            while gmii_tx_en or input_axis_tvalid:
                yield clk.posedge

            yield clk.posedge
            yield clk.posedge
            yield clk.posedge

            rx_frame = sink.recv()

            assert rx_frame.data[0:8] == bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5')
            assert rx_frame.error[-1]

            # bad packet

            rx_frame = sink.recv()

            assert rx_frame.data[0:8] == bytearray(b'\x55\x55\x55\x55\x55\x55\x55\xD5')

            eth_frame = eth_ep.EthFrame()
            eth_frame.parse_axis_fcs(rx_frame.data[8:])

            print(hex(eth_frame.eth_fcs))
            print(hex(eth_frame.calc_fcs()))

            assert len(eth_frame.payload.data) == max(payload_len, 46)
            assert eth_frame.eth_fcs == eth_frame.calc_fcs()
            assert eth_frame.eth_dest_mac == test_frame2.eth_dest_mac
            assert eth_frame.eth_src_mac == test_frame2.eth_src_mac
            assert eth_frame.eth_type == test_frame2.eth_type
            assert eth_frame.payload.data.index(test_frame2.payload.data) == 0

            assert sink.empty()

            yield delay(100)

        raise StopSimulation

    return dut, source_logic, sink_logic, clkgen, check

def test_bench():
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()
