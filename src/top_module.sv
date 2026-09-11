module top_module #(
    parameter DATA_DEPTH = 8, 
              ADDR_DEPTH = 8, 
              PTR_DEPTH = 3
) (
    input logic [DATA_WIDTH-1 : 0]  data_in,
    input logic                     w_en,
    input logic                     wrst_n,
    input logic                     w_clk,
    input logic                     w_rst,

    input logic                     r_en,
    input logic                     rrst_n,
    input logic                     r_clk,
    input logic                     r_rst,
    output logic [DATA_WIDTH-1 : 0] data_out

    output logic                    empty,
    output logic                    full
);
    
    memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .PTR_DEPTH(PTR_DEPTH)) mem (
        .i_data(data_in),
        .w_en(w_en),
        .w_clk(w_clk),
        .b_wptr(),
        .b_rptr(),

        .full(), 
        .empty(),
        .r_en(r_en),
        .rclk(rclk),
        .o_data(data_out);
    );



endmodule