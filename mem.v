`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:49:59 06/29/2012 
// Design Name: 
// Module Name:    mem 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mem(
    input [3:0] ADDR,
    output [7:0] DATA
    );

	reg [7:0] inst [0:15];
	
	initial begin
		$readmemb("prog.txt", inst,  0,  15);
	end

	assign DATA = inst[ADDR];

endmodule
