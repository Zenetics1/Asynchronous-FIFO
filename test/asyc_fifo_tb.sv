module async_fifo_tb;
    parameter DATA_DEPTH = 8;

    logic [DATA_DEPTH-1 : 0]  data_in,
    logic                     w_en,
    logic                     wrst_n,
    logic                     w_clk,

    logic                     r_en,
    logic                     rrst_n,
    logic                     r_clk,
    logic [DATA_DEPTH-1 : 0]  data_out

    logic                    empty,
    logic                    full


    logic [DATA_DEPTH-1 : 0] w_data_in;
    logic [DATA_DEPTH-1 : 0] w_data_q[$];

    top_module asyc_fifo(
        .data_in(data_in),
        .w_en(w_en),
        .wrst_n(wrst_n),
        .w_clk(w_clk),
        .r_en(r_en),
        .rrst_n(rrst_n),
        .r_clk(r_clk),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );
    //Write clock: 50ns
    always #25ns w_clk = ~w_clk;
    //Read clock: 90ns
    always #45ns r_clk = ~r_clk;

    initial begin
        w_clk = 1'b0;
        wrst_n = 1'b0;
        w_en = 1'b0;
        data_in = '0;

        //Hold processes while Reseting for 9 * 50ns = 450ns 
        repeat(9) @(posedge w_clk);
        wrst_n = 1'b1;

        repeat (2) begin
            for(int i = 0; i < 16; i++) begin
                @(posedge w_clk iff !full);
                w_en = (i%2 == 0) ? 1'b1 : 1'b0;
                if(w_en) begin
                    data_in = $urandom;
                    w_data_q.push_back(data_in);
                end
            end
            repeat(1) @(posedge w_clk);
        end
        
    end

    initial begin
        r_clk = 1'b0;
        rrst_n = 1'b0;
        r_en = 1'b0;
        
        //Hold processes while Reseting for 5 * 90ns = 450ns 
        repeat(5) @(posedge r_clk);
        rrst_n = 1'b1;

        //Allow synchronizer to reset
        repeat(2) @(posedge r_clk);

        //Two data runs to test 
        repeat (2) begin
            for(int i = 0; i < 16; i++) begin
                @(posedge r_clk iff !empty);
                r_en = (i%2 == 0) ? 1'b1 : 1'b0;
                if(r_en) begin
                    w_data_in = w_data_q.pop_front();
                    if(data_out != w_data_in) begin
                        $error("Data mismatch: Expected Output = %h, Given Output = %h", w_data_in, data_out);
                    end else begin
                        $$display("Data Matched: Input = %h ==> Output: %h", w_data_in, data_out);
                    end
                end
            end
            repeat(1) @(posedge r_clk);
        end
    end
    $dumpfile("dump.vcd"); 
    $dumpvars;
endmodule