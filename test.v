`timescale 1ns / 10ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:57:51 06/29/2012
// Design Name:   td4
// Module Name:   /home/psi/Dropbox/src/td4/test.v
// Project Name:  td4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: td4
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg [3:0] IN;
	reg CLK;

	// Outputs
	wire [3:0] OUT;
	wire [3:0] MEM_ADDR;
	
	wire [7:0] MEM_DATA;
	
	integer count;

	// Instantiate the Unit Under Test (UUT)
	td4 uut (
		.IN(IN), 
		.OUT(OUT), 
		.MEM_DATA(MEM_DATA), 
		.MEM_ADDR(MEM_ADDR), 
		.CLK(CLK)
	);
	
	mem memory (MEM_ADDR, MEM_DATA);

	initial begin
		// Initialize Inputs
		IN = 0;
		CLK = 0;

		// Wait 100 ns for global reset to finish
		
		for (count = 0; count < 200; count = count + 1) begin
			#1;
			CLK=1;
			#1;
			CLK=0;
		end
        
		#10 $finish;
	end
      
endmodule

