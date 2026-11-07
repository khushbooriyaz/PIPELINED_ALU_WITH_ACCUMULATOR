`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2026 11:09:10
// Design Name: 
// Module Name: tb_pipeline_alu
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
`timescale 1ns / 1ps

module tb_pipelined_alu;

reg clk;
reg rst;

reg load_en;
reg start;
reg acc_en;

reg [7:0] data_in;
reg [7:0] operand_b;

reg [2:0] alu_sel;

wire [7:0] alu_result;
wire [7:0] accumulator;

wire result_valid;

wire [7:0] load_reg_out;
wire [7:0] operand_reg_out;


// DUT

pipelined_alu DUT (

    .clk(clk),
    .rst(rst),

    .load_en(load_en),
    .start(start),
    .acc_en(acc_en),

    .data_in(data_in),
    .operand_b(operand_b),

    .alu_sel(alu_sel),

    .alu_result(alu_result),
    .accumulator(accumulator),

    .result_valid(result_valid),

    .load_reg_out(load_reg_out),
    .operand_reg_out(operand_reg_out)

);


// Clock

always #5 clk = ~clk;


// Test sequence

initial begin

    clk = 0;
    rst = 1;

    load_en = 0;
    start = 0;
    acc_en = 1;

    data_in = 0;
    operand_b = 0;
    alu_sel = 0;

    // Reset
    #20;
    rst = 0;

    // Load operands A=10, B=5
    @(negedge clk);

    load_en = 1;
    data_in = 10;
    operand_b = 5;

    @(negedge clk);

    load_en = 0;

    // ADD
    alu_sel = 3'b000;
    start = 1;

    @(negedge clk);

    start = 0;

    // Wait for result
    repeat(3) @(posedge clk);

    #1;

    $display("ADD Result = %d", alu_result);
    $display("Accumulator = %d", accumulator);

    // SUB
    @(negedge clk);

    alu_sel = 3'b001;
    start = 1;

    @(negedge clk);

    start = 0;

    repeat(3) @(posedge clk);

    #1;

    $display("SUB Result = %d", alu_result);  
    $display("Accumulator = %d", accumulator);

    // AND
    @(negedge clk);

    alu_sel = 3'b010;
    start = 1;

    @(negedge clk);

    start = 0;

    repeat(3) @(posedge clk);

    #1;

    $display("AND Result = %d", alu_result);

    // OR
    @(negedge clk);

    alu_sel = 3'b011;
    start = 1;

    @(negedge clk);

    start = 0;

    repeat(3) @(posedge clk);

    #1;

    $display("OR Result = %d", alu_result);

    // XOR
    @(negedge clk);

    alu_sel = 3'b100;
    start = 1;

    @(negedge clk);

    start = 0;

    repeat(3) @(posedge clk);

    #1;

    $display("XOR Result = %d", alu_result);

    #20;

    $finish;

end

endmodule

    
