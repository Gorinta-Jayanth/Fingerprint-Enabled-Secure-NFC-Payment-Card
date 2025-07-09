`timescale 1ns / 1ps

module tb;

	// Inputs
	reg clk =0;
	reg start =1;
	reg [3:0] x0;
	reg [3:0] y0;
	reg [3:0] p0;
	reg [3:0] q0;

	// Outputs
	wire Zi;

	// Instantiate the Unit Under Test (UUT)
	MODIFIED_DUALCLCG_USING_CS3A uut (
		.clk(clk), 
		.start(start), 
		.x0(x0), 
		.y0(y0), 
		.p0(p0), 
		.q0(q0), 
		.Zi(Zi)
	);

always #5 clk = !clk ;
	initial begin
		// Initialize Inputs
		#10 start = 0;
		x0 = 1;
		y0 = 2;
		p0 = 3;
		q0 = 4;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule
