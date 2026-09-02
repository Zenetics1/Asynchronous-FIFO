module name #(
    parameter ADDR_DEPTH = 4
) (
    input logic [ADDR_DEPTH-1 : 0]   ptr_data_i,
    input logic                      clk,
    input logic                      rst_n,

    output logic [ADDR_DEPTH-1: 0]   ptr_data_o
);
    logic [ADDR_DEPTH-1: 0] ff_1;

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