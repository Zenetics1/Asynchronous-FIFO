module memory #(
    parameter DATA_DEPTH = 8, 
              ADDR_DEPTH = 8, 
              PTR_DEPTH = 3
) (
    input logic [DATA_DEPTH-1 : 0]  i_data,
    input logic                     w_en,
    input logic                     w_clk,
    input logic [PTR_DEPTH-1 : 0]   b_wptr,
    input logic [PTR_DEPTH-1 : 0]   b_rptr,

    input logic                     full, 
    input logic                     empty,

    input logic                     r_en,
    input logic                     rclk,
    output logic [DATA_DEPTH-1 : 0] o_data
);
    
    logic [DATA_WIDTH-1 : 0] fifo [0 : DEPTH-1];

    always_ff @(posedge w_clk) begin :
        if (w_en & !full) begin
            fifo[b_wptr[PTR_DEPTH-1 : 0]] <= i_data; 
        end
    end


    always_ff @(posedge r_clk) begin : 
        if (r_en & !empty) begin
            o_data <= fifo[b_rptr[PTR_DEPTH-1 : 0]];
        end
    end
endmodule