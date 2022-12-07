module DFF (
	input D,
	input CP, 
	output reg Q
	);

always @(posedge CP) begin
	Q <= D;
end

endmodule

//*******************
module DFFSR (
	input D,
	input C, 
	input S, 
	input R, 
	output reg Q
	);

always @(posedge C) begin
	if (R) begin
		// reset
		Q <= 0;
	end
	else if (S) begin
		Q <=1;
	end
	else begin
		Q <= D;
	end
end

endmodule

//*****************
module AND2 (
	input A,
	input B, 
	output Z
	);

assign Z = A & B;

endmodule

//*****************
module OR2 (
	input A,
	input B, 
	output Z
	);

assign Z = A | B;

endmodule

//*****************
module XOR2 (
	input A,
	input B, 
	output Z
	);

assign Z = A ^ B;

endmodule

//*****************
module BIC2 (
	input A,
	input B, 
	output Z
	);

assign Z = A & (~B);

endmodule

//*****************
module ORN2 (
	input A,
	input B, 
	output Z
	);

assign Z = A | (~B);

endmodule

//*****************
module NOT1 (
	input A,
	output Z
	);

assign Z = ~A;

endmodule

//*****************
module BUF1 (
	input A,
	output Z
	);

assign Z = A;

endmodule
