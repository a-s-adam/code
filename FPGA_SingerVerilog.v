`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2019 08:16:01 PM
// Design Name: 
// Module Name: junk
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module junk(
    input wire [31:0] control,
    input wire clk,
    output wire speaker
    );
    
   reg [3:0] piano_1 = 0;
   reg [3:0] piano_2 = 0;
   reg [3:0] piano_3 = 0;
   reg [3:0] piano_4 = 0;
   reg [3:0] r_hush = 0;
   
   wire [7:0] speaker_1;
   wire [7:0] speaker_2;
   wire [7:0] speaker_3;
   wire [7:0] speaker_4; 
   wire [7:0] speaker_samp;
   
// wire [5:0] vocals = 0; 
 
 always@(posedge clk)
    begin
       piano_1[3:0] <= control[3:0];
       piano_2[3:0] <= control[7:4];
       piano_3[3:0] <= control[11:8];
       piano_4[3:0] <= control[15:12];
       r_hush[3:0]  <= control[19:16];
    end
        
    piano my_piano_1 (.clk(clk), .hush(1'b0), .note(piano_1[3:0]), .speaker(speaker_1)); 
    piano my_piano_2 (.clk(clk), .hush(1'b0), .note(piano_2[3:0]), .speaker(speaker_2)); 
    piano my_piano_3 (.clk(clk), .hush(1'b0), .note(piano_3[3:0]), .speaker(speaker_3)); 
    piano my_piano_4 (.clk(clk), .hush(1'b0), .note(piano_4[3:0]), .speaker(speaker_4)); 

// instantiate chatter here


// apply hush functionality
    
    wire [7:0] speak_out_1;
    wire [7:0] speak_out_2;
    wire [7:0] speak_out_3;
    wire [7:0] speak_out_4;
    

   assign speak_out_1 = (r_hush[0]==0) ? speaker_1: 0; 
   assign speak_out_2 = (r_hush[1]==0) ? speaker_2: 0; 
   assign speak_out_3 = (r_hush[2]==0) ? speaker_3: 0; 
   assign speak_out_4 = (r_hush[3]==0) ? speaker_4: 0; 
   
   
   
   
//add all signals together

    assign speaker_samp = (speak_out_1 + speak_out_2 + speak_out_3 + speak_out_4) << 2;  
    
    
   dac dac_inst (
.sample(speaker_samp), 
.hush(1'b0),
 .speaker(speaker),
 .clk(clk)
);
  
 
    
endmodule
