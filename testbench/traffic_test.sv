module traffic_test(
    input wire clk,

    input wire SW,

    input wire KEY[3:0],

    output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7

);

traffic_controller letg (
    // Starts at 0
    .clk_27(clk),

    // ACTIVE LOW
    .reset_bar(KEY[0]),

    // ALL ACTIVE LOW
    .left_turn_request(KEY[1]),
    .walk_NS_request_inp(KEY[2]),
    .walk_EW_request_inp(KEY[3]),

    // ALL ACTIVE HIGH
    .northbound_red(HEX7[0]),
    .northbound_amber(HEX7[6]),
    .northbound_green(HEX7[3]),
    .northbound_walk_light({HEX6[5], HEX6[6], HEX6[4:1]}),
    .eastbound_red(HEX3[0]),
    .eastbound_amber(HEX3[6]),
    .eastbound_green(HEX3[3]),
    .eastbound_walk_light({HEX2[5], HEX2[6], HEX2[4:1]}),
    .southbound_red(HEX5[0]),
    .southbound_amber(HEX5[6]),
    .southbound_green(HEX5[3]),
    .southbound_walk_light({HEX4[5], HEX4[6], HEX4[4:1]}),
    .southbound_arrow(HEX5[2:1]),
    .westbound_red(HEX1[0]),
    .westbound_amber(HEX1[6]),
    .westbound_green(HEX1[3]),
    .westbound_walk_light({HEX0[5], HEX0[6], HEX0[4:1]})
);

assign HEX0[0] = 1'b1;
assign HEX2[0] = 1'b1;
assign HEX6[0] = 1'b1;
assign HEX4[0] = 1'b1;
assign HEX7[5:4] = 2'd3;
assign HEX7[2:1] = 2'd3;
assign HEX1[5:4] = 2'd3;
assign HEX1[2:1] = 2'd3;
assign HEX3[5:4] = 2'd3;
assign HEX3[2:1] = 2'd3;
assign HEX5[5:4] = 2'd3;

endmodule