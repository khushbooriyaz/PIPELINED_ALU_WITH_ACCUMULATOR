`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2026 11:04:40
// Design Name: 
// Module Name: pipelined_alu
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

module pipelined_alu (

    input wire clk,
    input wire rst,

    input wire load_en,
    input wire start,
    input wire acc_en,

    input wire [7:0] data_in,
    input wire [7:0] operand_b,

    input wire [2:0] alu_sel,

    output wire [7:0] alu_result,
    output reg [7:0] accumulator,

    output wire result_valid,

    output wire [7:0] load_reg_out,
    output wire [7:0] operand_reg_out

);

    // ALU operation codes

    localparam ADD    = 3'b000;
    localparam SUB    = 3'b001;
    localparam AND_OP = 3'b010;
    localparam OR_OP  = 3'b011;
    localparam XOR_OP = 3'b100;


    // Load registers

    reg [7:0] load_reg;
    reg [7:0] operand_reg;


    // Pipeline Stage 1

    reg [7:0] a_s1;
    reg [7:0] b_s1;

    reg [2:0] op_s1;

    reg valid_s1;


    // Pipeline Stage 2

    reg [7:0] result_s2;
    reg valid_s2;


    // Combinational ALU output

    reg [7:0] alu_comb;


    // ALU operations

    always @(*) begin

        case (op_s1)

            ADD:
                alu_comb = a_s1 + b_s1;

            SUB:
                alu_comb = a_s1 - b_s1;

            AND_OP:
                alu_comb = a_s1 & b_s1;

            OR_OP:
                alu_comb = a_s1 | b_s1;

            XOR_OP:
                alu_comb = a_s1 ^ b_s1;

            default:
                alu_comb = 8'b00000000;

        endcase

    end


    // Load registers and Pipeline Stage 1

    always @(posedge clk) begin

        if (rst) begin

            load_reg   <= 8'b0;
            operand_reg <= 8'b0;

            a_s1 <= 8'b0;
            b_s1 <= 8'b0;

            op_s1 <= ADD;

            valid_s1 <= 1'b0;

        end

        else begin

            // Load operands

            if (load_en) begin

                load_reg <= data_in;

                operand_reg <= operand_b;

            end


            // Pipeline Stage 1

            if (start) begin

                a_s1 <= load_reg;

                b_s1 <= operand_reg;

                op_s1 <= alu_sel;

                valid_s1 <= 1'b1;

            end

            else begin

                valid_s1 <= 1'b0;

            end

        end

    end


    // Pipeline Stage 2

    always @(posedge clk) begin

        if (rst) begin

            result_s2 <= 8'b0;

            valid_s2 <= 1'b0;

        end

        else begin

            result_s2 <= alu_comb;

            valid_s2 <= valid_s1;

        end

    end


    // Accumulator

    always @(posedge clk) begin

        if (rst) begin

            accumulator <= 8'b0;

        end

        else begin

            if (valid_s2 && acc_en)

                accumulator <= accumulator + result_s2;

        end

    end


    // Output connections

    assign alu_result = result_s2;

    assign result_valid = valid_s2;

    assign load_reg_out = load_reg;

    assign operand_reg_out = operand_reg;


endmodule

   
