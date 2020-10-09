`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2019 07:48:32 PM
// Design Name: 
// Module Name: piano
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


module piano ( 
input wire clk, 
input wire hush, 
input wire [3:0] note, 
output wire speaker );


reg [16:0] frequency = 0;
reg [16:0] count = 0; //count of 17 bits, 2 to the 17 is fast enough for our frequencies.
reg square = 0;
//assign speaker = (count > frequency) ? frequency : 0; if (hush) square = 0;
assign speaker = square;
always @ (posedge clk) begin
            count <= count +1;
            if (hush) square <= 0;
			else begin if(count >= frequency) begin
			                count <= 0;
			                square <= !square;
			                       end			                
			     end
			            end

/*always @ * begin

case (state)			  
    1'b0: speaker = 0;
    1'b1: speaker = frequency;
        endcase
        end */
        
always @ (*) begin
case (note)
	4'h0:	 frequency = 113635; 
	4'h1:	 frequency = 107257; 
	4'h2:	 frequency = 101237; 
	4'h3:	 frequency = 95555;  
	4'h4:	 frequency = 90192;  
	4'h5:	 frequency = 85130;  
	4'h6:	 frequency = 80352;  
	4'h7:	 frequency = 75842;  
	4'h8:	 frequency = 71585;  
	4'h9:	 frequency = 67568;  
	4'hA:	 frequency = 63775;  
	4'hB:    frequency = 60196;  
	4'hC:	 frequency = 56817;  
	4'hD:	 frequency = 53628;  
	4'hE:	 frequency = 50618;  
	4'hF:	 frequency = 47777;  
		endcase
		
		end

endmodule
