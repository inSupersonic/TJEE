module smg(
    input clk,
    output [2:0] out_LED3_NS,
    output [2:0] out_LED3_WE,
    output [7:0] sm_duan,
    output [3:0] sm_wei
);

    wire [15:0] data;
    wire [1:0] Stage;

    // Instantiate traffic light control module
    test traffic_ctrl (
        .clk(clk),
        .data(data),
        .out_LED3_NS(out_LED3_NS),
        .out_LED3_WE(out_LED3_WE),
        .Stage(Stage)
    );

    // Instantiate segment display module
    smg_ip_model display (
        .clk(clk),
        .data(data),
        .Stage(Stage),
        .duan(sm_duan),
        .wei(sm_wei)
    );

endmodule