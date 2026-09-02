module top_module #(
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
) (
    input logic [DATA_WIDTH-1 : 0] data_in,
    input logic                    w_en,
    input logic                    wrst_n,
    input logic                    w_clk,
    input logic                    w_rst,

    input logic                    r_en,
    input logic                    rrst_n,
    input logic                    r_clk,
    input logic                    r_rst,
    output logic [DATA_WIDTH-1 : 0] data_out

    output logic                   flag_empty,
    output logic                   flag_full
);
    
    memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) mem (
        .i_data(data_in),
        // w_addr;
        .w_en(w_en),
        .w_clk(w_clk),

        .r_en(r_en),
        .rclk(rclk),
        //.r_addr(),
        .o_data(data_out);
    );



endmodule