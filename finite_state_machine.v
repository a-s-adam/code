// File: fsm.v
// This is the top level design for EE178 Lab #5.
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).
`timescale 1 ns / 1 ps
// Declare the module and its ports. This is
// using Verilog-2001 syntax.
module fsm (
 input wire restart_from_pin,
 input wire pause_from_pin,
 input wire clk,
 output reg even,
 output reg odd,
 output reg terminal
 );
 localparam [1:0] FIRST = 2'b11;
 localparam [1:0] SECOND = 2'b10;
 localparam [1:0] THIRD = 2'b01;

 reg [1:0] state = FIRST;
 wire restart_from_vio, restart;
 wire pause_from_vio, pause;
 // Begin INSTANTIATION Template from VEO or VHO File
 vio_0 my_vio (
 .clk(clk), // input wire clk
 .probe_in0(restart), // input wire [0 : 0] probe_in0
 .probe_in1(pause), // input wire [0 : 0] probe_in1
 .probe_in2(state), // input wire [1 : 0] probe_in2
 .probe_out0(restart_from_vio), // output wire [0 : 0] probe_out0
 .probe_out1(pause_from_vio) // output wire [0 : 0] probe_out1
 );
 // End INSTANTIATION Template from VEO or VHO File

 assign restart = restart_from_pin || restart_from_vio;
 assign pause = pause_from_pin || pause_from_vio;

 always @(posedge clk)
 begin
 case(state)
 FIRST: if (restart || pause) state <= FIRST;
 else state <= SECOND;
 SECOND: if (restart) state <= FIRST;
 else if (pause) state <= SECOND;
 else state <= THIRD;
 THIRD: if (!restart && pause) state <= THIRD;
 else state <= FIRST;
 default: state <= FIRST;
 endcase
 end
 always @*
 begin
 even = (state == SECOND);
 odd = (state == FIRST) || (state == THIRD);
 terminal = (state == THIRD) && (restart || !pause);
 end
 // Begin INSTANTIATION Template from VEO or VHO File
 ila_0 my_ila (
 .clk(clk), // input wire clk
 .probe0(restart), // input wire [0 : 0] probe0
 .probe1(pause), // input wire [0 : 0] probe1
 .probe2(state), // input wire [1 : 0] probe2
 .probe3(even), // input wire [0 : 0] probe3
 .probe4(odd), // input wire [0 : 0] probe4
 .probe5(terminal) // input wire [0 : 0] probe5
 );
 // End INSTANTIATION Template from VEO or VHO File
endmodule
 