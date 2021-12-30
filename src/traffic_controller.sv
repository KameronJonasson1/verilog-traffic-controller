module traffic_controller(
    // System Clock
    input wire clk,
    // System Reset
    input wire reset_bar, // ACTIVE LOW

    // Input signal for left turn request
    input wire left_turn_request, // Active Low

    // Input signal for walk light request
    input wire walk_NS_request_inp, // Active Low
    input wire walk_EW_request_inp, // Active Low

    // Light control output signals
    // ALL ACTIVE HIGH
    output reg northbound_red,
    output reg northbound_amber,
    output reg northbound_green,
    output reg [5:0] northbound_walk_light,
    output reg eastbound_red,
    output reg eastbound_amber,
    output reg eastbound_green,
    output reg [5:0] eastbound_walk_light,
    output reg southbound_red,
    output reg southbound_amber,
    output reg southbound_green,
    output reg [5:0] southbound_walk_light,
    output reg [1:0] southbound_arrow,
    output reg westbound_red,
    output reg westbound_amber,
    output reg westbound_green,
    output reg [5:0] westbound_walk_light
);

    reg [5:0] timer;

    reg entering_state_1;
    reg entering_state_1w;
    reg entering_state_1fd;
    reg entering_state_1d;
    reg entering_state_2;
    reg entering_state_3;
    reg entering_state_4;
    reg entering_state_4a;
    reg entering_state_4w;
    reg entering_state_4fd;
    reg entering_state_4d;
    reg entering_state_5;
    reg entering_state_6;

    reg staying_in_state_1;
    reg staying_in_state_1w;
    reg staying_in_state_1fd;
    reg staying_in_state_1d;
    reg staying_in_state_2;
    reg staying_in_state_3;
    reg staying_in_state_4;
    reg staying_in_state_4a;
    reg staying_in_state_4w;
    reg staying_in_state_4fd;
    reg staying_in_state_4d;
    reg staying_in_state_5;
    reg staying_in_state_6;

    reg state_1;
    reg state_1w;
    reg state_1fd;
    reg state_1d;
    reg state_2;
    reg state_3;
    reg state_4;
    reg state_4a;
    reg state_4w;
    reg state_4fd;
    reg state_4d;
    reg state_5;
    reg state_6;

    reg state_1_d;
    reg state_1w_d;
    reg state_1fd_d;
    reg state_1d_d;
    reg state_2_d;
    reg state_3_d;
    reg state_4_d;
    reg state_4a_d;
    reg state_4w_d;
    reg state_4fd_d;
    reg state_4d_d;
    reg state_5_d;
    reg state_6_d;

    reg walk_NS_request;
    reg walk_EW_request;

    // ********** Walk Request **********
    // --- FF NS ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            walk_NS_request <= 1'b0;
        else if (walk_NS_request_inp == 1'b0)
            walk_NS_request <= 1'b1;
        else if (((state_4a == 1'b1) && (timer == 6'd1) && (walk_NS_request == 1'b1)) 
        | ((state_3 == 1'b1) && (timer == 6'd1) && (walk_NS_request == 1'b1) && (left_turn_request == 1'b1)))
            walk_NS_request <= 1'b0;
        else
            walk_NS_request <= walk_NS_request;
    // --- FF EW ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            walk_EW_request <= 1'b0;
        else if (walk_EW_request_inp == 1'b0)
            walk_EW_request <= 1'b1;
        else if ( (state_6 == 1'b1) && (timer == 1'd1) && (walk_EW_request == 1'b1))
            walk_EW_request <= 1'b0;
        else
            walk_EW_request <= walk_EW_request;



    // ********** Counter **********
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            timer <= 6'd60; // Time for state 1
        else if (entering_state_1 == 1'b1)
            timer <= 6'd60; // Time for state 1
        else if (entering_state_1w == 1'b1)
            timer <= 6'd10; // Time for state 1w
        else if (entering_state_1fd == 1'b1)
            timer <= 6'd20; // Time for state 1fd
        else if (entering_state_1d == 1'b1)
            timer <= 6'd30; // Time for state 1d
        else if (entering_state_2 == 1'b1)
            timer <= 6'd6 ;// Timer for state 2
        else if (entering_state_3 == 1'b1)
            timer <= 6'd2; // Timer for state 3
        else if (entering_state_4 == 1'b1)
            timer <= 6'd60; // Timer for state 4
        else if (entering_state_4a == 1'b1)
            timer <= 6'd20; // Timer for state 4a
        else if (entering_state_4w == 1'b1)
            timer <= 6'd10; // Timer for state 4w
        else if (entering_state_4fd == 1'b1)
            timer <= 6'd20; // Timer for state 4fd
        else if (entering_state_4d == 1'b1)
            timer <= 6'd30; // Timer for state 4d
        else if (entering_state_5 == 1'b1)
            timer <= 6'd6; // Timer for state 5
        else if (entering_state_6 == 1'b1)
            timer <= 6'd2; // Timer for state 6
        else 
            timer <= timer - 6'd1;



    // ********** STATE 1 **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_1 <= 1'b1;
        else 
            state_1 <= state_1_d;
    // --- Entering State ---
    always @(*)
        if ( (state_6 == 1'b1) && (timer == 1'd1) && (walk_EW_request == 1'b0))
            entering_state_1 <= 1'b1;
        else
            entering_state_1 <=1'b0;
    // --- Staying in State 1 ---
    always @(*)
        if ( (state_1 == 1'b1) && (timer != 1'd1) )
            staying_in_state_1 <= 1'b1;
        else
            staying_in_state_1 <= 1'b0;
    // --- State 1 D-input ---
    always @(*)
        if (entering_state_1 == 1'b1)
            // Enter State 1
            state_1_d <= 1'b1;
        else if  (staying_in_state_1 == 1'b1)
            // Staying in State 1
            state_1_d <= 1'b1;
        else
            // Leaving or not Entering State 1
            state_1_d <= 1'b0;

    // ********** STATE 1w **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_1w <= 1'b0;
        else 
            state_1w <= state_1w_d;
    // --- Entering State ---
    always @(*)
        if ( (state_6 == 1'b1) && (timer == 1'd1) && (walk_EW_request == 1'b1))
            entering_state_1w <= 1'b1;
        else
            entering_state_1w <=1'b0;
    // --- Staying in State 1w ---
    always @(*)
        if ( (state_1w == 1'b1) && (timer != 1'd1) )
            staying_in_state_1w <= 1'b1;
        else
            staying_in_state_1w <= 1'b0;
    // --- State 1w D-input ---
    always @(*)
        if (entering_state_1w == 1'b1)
            // Enter State 1
            state_1w_d <= 1'b1;
        else if  (staying_in_state_1w == 1'b1)
            // Staying in State 1
            state_1w_d <= 1'b1;
        else
            // Leaving or not Entering State 1
            state_1w_d <= 1'b0;

    // ********** STATE 1fd **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_1fd <= 1'b0;
        else 
            state_1fd <= state_1fd_d;
    // --- Entering State ---
    always @(*)
        if ( (state_1w == 1'b1) && (timer == 1'd1) )
            entering_state_1fd <= 1'b1;
        else
            entering_state_1fd <=1'b0;
    // --- Staying in State 1 ---
    always @(*)
        if ( (state_1fd == 1'b1) && (timer != 1'd1) )
            staying_in_state_1fd <= 1'b1;
        else
            staying_in_state_1fd <= 1'b0;
    
    // --- State 1fd D-input ---
    always @(*)
        if (entering_state_1fd == 1'b1)
            // Enter State 1
            state_1fd_d <= 1'b1;
        else if  (staying_in_state_1fd == 1'b1)
            // Staying in State 1
            state_1fd_d <= 1'b1;
        else
            // Leaving or not Entering State 1
            state_1fd_d <= 1'b0;

    // ********** STATE 1d **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_1d <= 1'b0;
        else 
            state_1d <= state_1d_d;
    // --- Entering State ---
    always @(*)
        if ( (state_1fd == 1'b1) && (timer == 1'd1) )
            entering_state_1d <= 1'b1;
        else
            entering_state_1d <=1'b0;
    // --- Staying in State 1d ---
    always @(*)
        if ( (state_1d == 1'b1) && (timer != 1'd1) )
            staying_in_state_1d <= 1'b1;
        else
            staying_in_state_1d <= 1'b0;
    // --- State 1d D-input ---
    always @(*)
        if (entering_state_1d == 1'b1)
            // Enter State 1
            state_1d_d <= 1'b1;
        else if  (staying_in_state_1d == 1'b1)
            // Staying in State 1
            state_1d_d <= 1'b1;
        else
            // Leaving or not Entering State 1
            state_1d_d <= 1'b0;

    // ********** STATE 2 **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_2 <= 1'b0;
        else 
            state_2 <= state_2_d;
    // --- Entering State ---
    always @(*)
        if ( ((state_1 == 1'b1) && (timer == 6'd1)) | ((state_1d == 1'b1) && (timer == 6'd1)) )
            entering_state_2 <= 1'b1;
        else
            entering_state_2 <=1'b0;
    // --- Staying in State 2 ---
    always @(*)
        if ( (state_2 == 1'b1) && (timer != 6'd1) )
            staying_in_state_2 <= 1'b1;
        else
            staying_in_state_2 <= 1'b0;
    // --- State 2 D-input ---
    always @(*)
        if (entering_state_2 == 1'b1)
            // Enter State 2
            state_2_d <= 1'b1;
        else if  (staying_in_state_2 == 1'b1)
            // Staying in State 2
            state_2_d <= 1'b1;
        else
            // Leaving or not Entering State 2
            state_2_d <= 1'b0;

    // ********** STATE 3 **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_3 <= 1'b0;
        else 
            state_3 <= state_3_d;
    // --- Entering State ---
    always @(*)
        if ( ((state_2 == 1'b1) && (timer == 6'd1)) | ((state_1d == 1'b1) && (timer == 6'd1)) )
            entering_state_3 <= 1'b1;
        else
            entering_state_3 <=1'b0;
    // --- Staying in State 3 ---
    always @(*)
        if ( (state_3 == 1'b1) && (timer != 6'd1) )
            staying_in_state_3 <= 1'b1;
        else
            staying_in_state_3 <= 1'b0;
    // --- State 3 D-input ---
    always @(*)
        if (entering_state_3 == 1'b1)
            // Enter State 3
            state_3_d <= 1'b1;
        else if  (staying_in_state_3 == 1'b1)
            // Staying in State 3
            state_3_d <= 1'b1;
        else
            // Leaving or not Entering State 3
            state_3_d <= 1'b0;

    // ********** STATE 4a **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_4a <= 1'b0;
        else 
            state_4a <= state_4a_d;
    // --- Entering State ---
    always @(*)
        if ( (state_3 == 1'b1) && (timer == 6'd1) && (left_turn_request == 1'b0))
            entering_state_4a <= 1'b1;
        else
            entering_state_4a <=1'b0;
    // --- Staying in State 4a ---
    always @(*)
        if ( (state_4a == 1'b1) && (timer != 6'd1) )
            staying_in_state_4a <= 1'b1;
        else
            staying_in_state_4a <= 1'b0;
    // --- State 4a D-input ---
    always @(*)
        if (entering_state_4a == 1'b1)
            // Enter State 4a
            state_4a_d <= 1'b1;
        else if  (staying_in_state_4a == 1'b1)
            // Staying in State 4a
            state_4a_d <= 1'b1;
        else
            // Leaving or not Entering State 4a
            state_4a_d <= 1'b0;

    // ********** STATE 4 **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_4 <= 1'b0;
        else 
            state_4 <= state_4_d;
    // --- Entering State ---
    always @(*)
        if ( ((state_3 == 1'b1) && (timer == 6'd1) && (left_turn_request == 1'b1) && (walk_NS_request == 1'b0)) 
            | ((state_4a == 1'b1) && (timer == 6'd1) && (walk_NS_request == 1'b0)) )
            entering_state_4 <= 1'b1;
        else
            entering_state_4 <=1'b0;
    // --- Staying in State 4 ---
    always @(*)
        if ( (state_4 == 1'b1) && (timer != 6'd1) )
            staying_in_state_4 <= 1'b1;
        else
            staying_in_state_4 <= 1'b0;
    // --- State 4 D-input ---
    always @(*)
        if (entering_state_4 == 1'b1)
            // Enter State 4
            state_4_d <= 1'b1;
        else if  (staying_in_state_4 == 1'b1)
            // Staying in State 4
            state_4_d <= 1'b1;
        else
            // Leaving or not Entering State 4
            state_4_d <= 1'b0;

    // ********** STATE 4w **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_4w <= 1'b0;
        else 
            state_4w <= state_4w_d;
    // --- Entering State ---
    always @(*)
        if (((state_4a == 1'b1) && (timer == 6'd1) && (walk_NS_request == 1'b1)) 
            | ((state_3 == 1'b1) && (timer == 6'd1) && (walk_NS_request == 1'b1) && (left_turn_request == 1'b1)))
            entering_state_4w <= 1'b1;
        else
            entering_state_4w <=1'b0;
    // --- Staying in State 4w ---
    always @(*)
        if ( (state_4w == 1'b1) && (timer != 6'd1) )
            staying_in_state_4w <= 1'b1;
        else
            staying_in_state_4w <= 1'b0;
    // --- State 4w D-input ---
    always @(*)
        if (entering_state_4w == 1'b1)
            // Enter State 4w
            state_4w_d <= 1'b1;
        else if  (staying_in_state_4w == 1'b1)
            // Staying in State 4w
            state_4w_d <= 1'b1;
        else
            // Leaving or not Entering State 4w
            state_4w_d <= 1'b0;
    
    // ********** STATE 4fd **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_4fd <= 1'b0;
        else 
            state_4fd <= state_4fd_d;
    // --- Entering State ---
    always @(*)
        if ( (state_4w == 1'b1) && (timer == 1'd1) )
            entering_state_4fd <= 1'b1;
        else
            entering_state_4fd <=1'b0;
    // --- Staying in State 4fd ---
    always @(*)
        if ( (state_4fd == 1'b1) && (timer != 1'd1) )
            staying_in_state_4fd <= 1'b1;
        else
            staying_in_state_4fd <= 1'b0;
    // --- State 4fd D-input ---
    always @(*)
        if (entering_state_4fd == 1'b1)
            // Enter State 1
            state_4fd_d <= 1'b1;
        else if  (staying_in_state_4fd == 1'b1)
            // Staying in State 1
            state_4fd_d <= 1'b1;
        else
            // Leaving or not Entering State 1
            state_4fd_d <= 1'b0;

    // ********** STATE 4d **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_4d <= 1'b0;
        else 
            state_4d <= state_4d_d;

    // --- Entering State ---
    always @(*)
        if ( (state_4fd == 1'b1) && (timer == 1'd1) )
            entering_state_4d <= 1'b1;
        else
            entering_state_4d <=1'b0;
    // --- Staying in State 4d ---
    always @(*)
        if ( (state_4d == 1'b1) && (timer != 1'd1) )
            staying_in_state_4d <= 1'b1;
        else
            staying_in_state_4d <= 1'b0;
    // --- State 4d D-input ---
    always @(*)
        if (entering_state_4d == 1'b1)
            // Enter State 1
            state_4d_d <= 1'b1;
        else if  (staying_in_state_4d == 1'b1)
            // Staying in State 1
            state_4d_d <= 1'b1;
        else
            // Leaving or not Entering State 1
            state_4d_d <= 1'b0;

    // ********** STATE 5 **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_5 <= 1'b0;
        else 
            state_5 <= state_5_d;
    // --- Entering State ---
    always @(*)
        if ( ((state_4 == 1'b1) && (timer == 6'd1)) | ((state_4d == 1'b1) && (timer == 6'd1)) )
            entering_state_5 <= 1'b1;
        else
            entering_state_5 <=1'b0;
    // --- Staying in State 5 ---
    always @(*)
        if ( (state_5 == 1'b1) && (timer != 6'd1) )
            staying_in_state_5 <= 1'b1;
        else
            staying_in_state_5 <= 1'b0;
    // --- State 5 D-input ---
    always @(*)
        if (entering_state_5 == 1'b1)
            // Enter State 5
            state_5_d <= 1'b1;
        else if  (staying_in_state_5 == 1'b1)
            // Staying in State 5
            state_5_d <= 1'b1;
        else
            // Leaving or not Entering State 5
            state_5_d <= 1'b0;

    // ********** STATE 6 **********
    // --- FF ---
    always @(posedge clk or negedge reset_bar)
        if (reset_bar == 1'b0)
            state_6 <= 1'b0;
        else 
            state_6 <= state_6_d;
    // --- Entering State ---
    always @(*)
        if ( (state_5 == 1'b1) && (timer == 6'd1) )
            entering_state_6 <= 1'b1;
        else
            entering_state_6 <=1'b0;
    // --- Staying in State 6 ---
    always @(*)
        if ( (state_6 == 1'b1) && (timer != 6'd1) )
            staying_in_state_6 <= 1'b1;
        else
            staying_in_state_6 <= 1'b0;
    // --- State 6 D-input ---
    always @(*)
        if (entering_state_6 == 1'b1)
            // Enter State 6
            state_6_d <= 1'b1;
        else if  (staying_in_state_6 == 1'b1)
            // Staying in State 6
            state_6_d <= 1'b1;
        else
            // Leaving or not Entering State 6
            state_6_d <= 1'b0;



    // ********** Car Light Control **********
    // --- North Bound - Red ---
    always @(*)
        if ( (state_1 | state_1w | state_1fd | state_1d | state_2 | state_3 | state_4a | state_6) == 1'b1 )
            northbound_red = 1'b0;
        else 
            northbound_red = 1'b1;
    // --- North Bound - Amber ---
    always @(*)
        if ( (state_5) == 1'b1 )
            northbound_amber = 1'b0;
        else 
            northbound_amber = 1'b1;
    // --- North Bound - Green ---
    always @(*)
        if ( (state_4w | state_4fd | state_4d | state_4) == 1'b1 )
            northbound_green = 1'b0;
        else 
            northbound_green = 1'b1;

    // --- East Bound - Red ---
    always @(*)
        if ( (state_3 | state_4w | state_4fd | state_4d | state_4a | state_4 | state_5 | state_6) == 1'b1 )
            eastbound_red = 1'b0;
        else 
            eastbound_red = 1'b1;
    // --- East Bound - Amber ---
    always @(*)
        if ( (state_2) == 1'b1 )
            eastbound_amber = 1'b0;
        else 
            eastbound_amber = 1'b1;
    // --- East Bound - Green ---
    always @(*)
        if ( (state_1w | state_1fd | state_1d | state_1) == 1'b1 )
            eastbound_green = 1'b0;
        else 
            eastbound_green = 1'b1;

    // --- South Bound - Red ---
    always @(*)
        if ( (state_1w | state_1fd | state_1d | state_1 | state_2 | state_3 | state_6) == 1'b1 )
            southbound_red = 1'b0;
        else 
            southbound_red = 1'b1;
    // --- South Bound - Amber ---
    always @(*)
        if ( (state_5 | state_4a) == 1'b1 )
            southbound_amber = 1'b0;
        else 
            southbound_amber = 1'b1;
    // --- South Bound - Green ---
    always @(*)
        if ( (state_4w | state_4fd | state_4d | state_4) == 1'b1 )
            southbound_green = 1'b0;
        else 
            southbound_green = 1'b1;
    
    // --- West Bound - Red ---
    always @(*)
        if ( (state_3 | state_4w | state_4fd | state_4d | state_4a | state_4 | state_5 | state_6) == 1'b1 )
            westbound_red = 1'b0;
        else 
            westbound_red = 1'b1;
    // --- West Bound - Amber ---
    always @(*)
        if ( (state_2) == 1'b1 )
            westbound_amber = 1'b0;
        else 
            westbound_amber = 1'b1;
    // --- West Bound - Green ---
    always @(*)
        if ( (state_1w | state_1fd | state_1d | state_1) == 1'b1 )
            westbound_green = 1'b0;
        else 
            westbound_green = 1'b1;



    // ********** Walk Light Control **********
    // --- North Bound - Walk ---
    always @(*)
        if ( (state_4w) == 1'b1 )
            northbound_walk_light = 6'b011111;
        else if ( ((state_4fd) == 1'b1) && ((clk) == 1'b1) )
            northbound_walk_light = 6'b111111;
        else
            northbound_walk_light = 6'b100000;
    
    // --- South Bound - Walk ---
    always @(*)
        if ( (state_4w) == 1'b1 )
            southbound_walk_light = 6'b011111;
        else if ( ((state_4fd) == 1'b1) && ((clk) == 1'b1) )
            southbound_walk_light = 6'b111111;
        else
            southbound_walk_light = 6'b100000;

    // --- East Bound - Walk ---
    always @(*)
        if ( (state_1w) == 1'b1 )
            eastbound_walk_light = 6'b011111;
        else if ( ((state_1fd) == 1'b1) && ((clk) == 1'b1) )
            eastbound_walk_light = 6'b111111;
        else
            eastbound_walk_light = 6'b100000;
    
    // --- West Bound - Walk ---
    always @(*)
        if ( (state_1w) == 1'b1 )
            westbound_walk_light = 6'b011111;
        else if ( ((state_1fd) == 1'b1) && ((clk) == 1'b1) )
            westbound_walk_light = 6'b111111;
        else
            westbound_walk_light = 6'b100000;
    

    // ********** Left Turn Control **********
    always @(*)
        if ( (state_4a) == 1'b1 )
            southbound_arrow = 2'b00;
        else
            southbound_arrow = 2'b11;
    
endmodule