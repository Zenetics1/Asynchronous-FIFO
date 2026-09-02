module memory #(
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
) (
    input logic [DATA_WIDTH-1 : 0] i_data;
    input logic [ADDR_WIDTH-1 : 0] w_addr;
    input logic                    w_en;
    input logic                    w_clk;

    input logic                     r_en;
    input logic                     rclk;
    input logic  [ADDR_WIDTH-1 : 0] r_addr;
    output logic [DATA_WIDTH-1 : 0] o_data;
);
    
    localparam DEPTH = 1 << ADDR_WIDTH;

    logic [DATA_WIDTH-1 : 0] ram [0 : DEPTH-1];

    always_ff @(posedge w_clk ) begin :
        if (w_en) begin
            ram[w_addr] <= i_data; 
        end
    end


    always_ff @(posedge r_clk ) begin : 
        if (r_en) begin
            o_data <= ram[r_addr];
        end
    end
endmodule