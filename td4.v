`timescale 1ns / 1ps

//74HC153 * 2相当
module Selector(
	input [3:0] A,
	input [3:0] B,
	input [3:0] C,
	input [3:0] D,
	input [1:0] SEL,
	output [3:0] OUT
);
	assign OUT=sel(A,B,C,D,SEL);
	function [3:0] sel;
		input [3:0] _A, _B, _C, _D;
		input [1:0] _SEL;
		begin
			sel =
				_SEL == 2'b00 ? _A :
				_SEL == 2'b01 ? _B :
				_SEL == 2'b10 ? _C :
				_SEL == 2'b11 ? _D : 0;
		end
	endfunction
endmodule

//命令デコーダー
module Decoder(
	input [3:0] OPCODE,
	input CARRY,
	output [1:0] SEL,
	output LOAD_A,
	output LOAD_B,
	output LOAD_C,
	output LOAD_D
);
	assign SEL[1] = OPCODE[1];
	assign SEL[0] = OPCODE[0] | OPCODE[3];
	
	assign LOAD_A = OPCODE[2] | OPCODE[3];
	assign LOAD_B = !OPCODE[2] | OPCODE[3];
	assign LOAD_C = OPCODE[2] | !OPCODE[3];
	assign LOAD_D = !OPCODE[2] | !OPCODE[3] | (!OPCODE[0] & CARRY);

endmodule

//加算器
module ALU(
	input [3:0] A,
	input [3:0] B,
	output [3:0] OUT,
	output CARRY
);

	assign {CARRY, OUT}=A+B;
endmodule

//レジスタ一個分
module Register(
	input [3:0] IN,
	output [3:0] OUT,
	input LOAD,
	input COUNTUP,
	input CLK
);
	reg [3:0] val;
	assign OUT=val;
	initial begin
		val <= 0;
	end
	always @ (posedge CLK) begin
		if (!LOAD) val <= IN;
		else if (COUNTUP) val <= val + 1;
	end
endmodule

//キャリーフラグを保持するためのフリップフロップ
module FlipFlop(
	input IN,
	output OUT,
	input LOAD,
	input CLK);
	reg val;
	assign OUT=val;
	initial begin
		val <= 0;
	end
	always @ (posedge CLK) begin
		if (!LOAD) val <= IN;
	end
endmodule

//メインモジュール
module td4(
    input [3:0] IN,
    output [3:0] OUT, 
	input [7:0] MEM_DATA,
	output [3:0] MEM_ADDR,
	input CLK
    );
	supply0 [3:0] ZERO;
	supply1 [3:0] ONE;
	
	wire [3:0] aluOut;
	wire [3:0] regAOut;
	wire [3:0] regBOut;
	wire [1:0] selReg;
	wire [3:0] selOut;

	/* Aレジスタ */
	Register regA (aluOut, regAOut, loadA, ZERO, CLK);

	/* Bレジスタ */
	Register regB (aluOut, regBOut, loadB, ZERO, CLK);

	/* OUTレジスタ */
	Register out (aluOut, OUT, loadC, ZERO, CLK);

	/* プログラムカウンタ */
	Register pc (aluOut, MEM_ADDR, loadD, ONE, CLK);

	/* データセレクタ */
	Selector dataSelector (regAOut, regBOut, IN, ZERO, selReg, selOut);
	
	/* キャリー */
	FlipFlop carry(carryIn, carryOut, ZERO[3:0], CLK);

	/* デーコーダ */
	Decoder decoder (MEM_DATA[7:4], carryOut, selReg, loadA, loadB, loadC, loadD);
	
	/* ALU */
	ALU alu(selOut, MEM_DATA[3:0], aluOut, carryIn);
	
endmodule
