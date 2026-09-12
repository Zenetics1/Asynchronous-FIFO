module name #(
    parameter PTR_DEPTH = 3
) (
    input logic [PTR_DEPTH : 0]   ptr_data_i,
    input logic                   clk,
    input logic                   rst_n,

    output logic [PTR_DEPTH : 0]  ptr_data_o
);
    logic [PTR_DEPTH-1: 0] ff_1;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            ff_1 <= '0;
            ptr_data_o <= '0;
        end
        else begin
            ff_1 <= ptr_data_i;
            ptr_data_o <= ff_1;
        end
    end

endmodule