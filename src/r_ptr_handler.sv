module r_ptr_handler #(
    parameter PTR_DEPTH = 3
) (
    input logic                  rclk,
    input logic                  rrst_n,
    input logic                  r_en,
    input logic  [PTR_DEPTH : 0] g_wptr_sync,

    output logic                 empty,
    output logic [PTR_DEPTH : 0] b_rptr,
    output logic [PTR_DEPTH : 0] g_rptr,
);
    
    logic [PTR_DEPTH : 0] b_rptr_next;
    logic [PTR_DEPTH : 0] g_rptr_next;
    logic                 rempty;

    assign b_rptr_next = b_rptr + (r_en & !empty);
    assign g_rptr_next = (b_rptr_next >> 1) ^ b_rptr_next;

    assign rempty = (g_wptr_sync == g_rptr_next);

    always_ff @(posedge rclk or negedge rrst_n ) begin        
        if (!rrst_n) begin
            b_rptr <= '0;
            g_rptr <= '0;
        end else begin
            b_rptr <= b_rptr_next;
            g_rptr <= g_gptr_next;
        end
    end

    always_ff @(posedge rclk or negedge rrst_n) begin
        if(!rrst_n) begin
            empty <= 1'b1;
        end else begin
            empty <= rempty;
        end
    end


endmodule