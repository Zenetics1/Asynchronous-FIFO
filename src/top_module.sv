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
    logic                 f_full, f_empty;
    logic [PTR_DEPTH : 0] b_wptr, b_rptr;
    logic [PTR_DEPTH : 0] g_wptr_sync, g_rptr_sync;
    logic [PTR_DEPTH : 0] g_wptr, g_rptr;

    assign full = f_full;
    assign empty = f_empty;

    w_ptr_handler #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .PTR_DEPTH(PTR_DEPTH)) w_ptr_h (
        .wclk(w_clk),
        .wrst_n(wrst_n),
        .w_en(w_en),
        .g_rptr_sync(g_rptr_sync),

        .full(f_full),
        .b_wptr(b_wptr),
        .g_wptr(g_wptr)
    );
    r_ptr_handler #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .PTR_DEPTH(PTR_DEPTH)) r_ptr_h (
        .rclk(r_clk),
        .rrst_n(rrst_n),
        .r_en(r_en),
        .g_wptr_sync(g_wptr_sync),

        .empty(f_empty),
        .b_rptr(b_rptr),
        .g_rptr(g_rptr)
    );

    synchronizer #(.PTR_DEPTH(PTR_DEPTH)) w_sync (
        .ptr_data_i(g_wptr),
        .clk(w_clk),
        .rst_n(wrst_n),
        .ptr_data_o(g_wptr_sync)
    );

    synchronizer #(.PTR_DEPTH(PTR_DEPTH)) r_sync (
        .ptr_data_i(g_rptr),
        .clk(r_clk),
        .rst_n(rrst_n),
        .ptr_data_o(g_rptr_sync)
    );

    memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .PTR_DEPTH(PTR_DEPTH)) mem (
        .i_data(data_in),
        .w_en(w_en),
        .w_clk(w_clk),
        .b_wptr(b_wptr),
        .b_rptr(b_rptr),

        .full(f_full), 
        .empty(f_empty),
        .r_en(r_en),
        .rclk(rclk),
        .o_data(data_out);
    );



endmodule