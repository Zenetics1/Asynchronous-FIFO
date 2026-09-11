module w_ptr_handler #(
    PTR_DEPTH = 3
) (
    input logic                  wclk,
    input logic                  wrst_n,
    input logic                  w_en,
    input logic  [PTR_DEPTH : 0] g_rptr_sync,

    output logic                 full,
    output logic [PTR_DEPTH : 0] b_wptr,
    output logic [PTR_DEPTH : 0] g_wptr,
);
    logic [PTR_DEPTH : 0] b_wptr_next;
    logic [PTR_DEPTH : 0] g_wptr_next;

    logic wfull;

    assign b_wptr_next = b_wptr + (w_en & !full);
    assign g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;

    always_ff @(posedge wclk or negedge wrst_n) begin :
        if(!wrst_n) begin
            b_wptr <= '0;
            g_wptr <= '0;
        end else begin
            b_wptr <= b_wptr_next;
            g_wptr <= g_wptr_next;
        end
    end 

    assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_DEPTH : PTR_DEPTH-1], g_rptr_sync[PTR_DEPTH-2 : 0]});

    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) begin
            full <= '0;
        end else begin
            full <= wfull;
        end
    end
endmodule