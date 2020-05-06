module Top(
    clk, rst_switch, play_switch, signal_out1, signal_out2, signal_out3, LED, LED_state, mode4_handout_count, LED_switch
);
    input clk, rst_switch, play_switch;
    output [4-1:0] signal_out1, signal_out2, signal_out3;
    output reg [4-1:0] LED;
    output [5-1:0] LED_state;
    output[3-1:0]  mode4_handout_count;
    output LED_switch;

    wire [2-1:0] random_mode;
    wire [2-1:0] mode;
    wire db_rst;
    wire rst;
    wire enable1, enable2 ,direction1, direction2;
    wire play_switch_db;
    
    assign LED_switch = play_switch;

    debounce db(.pb_debounced(db_rst), .pb(rst_switch), .clk(clk));
    onepulse op(.PB_debounced(db_rst), .clk(clk), .PB_one_pulse(rst));

    //debounce db_play(.pb_debounced(play_switch_db), .pb(play_switch), .clk(clk));
    
    GameControl game(
        .clk(clk), .rst(rst), .switch_signal(~play_switch),  .mode(mode), .state(LED_state), .mode4_handout_count(mode4_handout_count),.enable1(enable1), .enable2(enable2) , .direction1(direction1), .direction2(direction2)
    );

    pmod_step_interface_lid_1 lid1(
        .clk(clk), .rst(rst), .direction(~direction1), .en(enable1), .mode(mode), .signal_out(signal_out1)
    );

    pmod_step_interface_lid_2 lid2(
        .clk(clk), .rst(rst), .direction(~direction1), .en(enable1), .mode(mode), .signal_out(signal_out3)
    );

    pmod_step_interface_hand hand(
        .clk(clk), .rst(rst), .direction(direction2), .en(enable2), .mode(mode), .signal_out(signal_out2)
    );

    always@(*)begin
        case(mode)
            2'b00 : LED = 4'b1000;
            2'b01 : LED = 4'b0100;
            2'b10 : LED = 4'b0010;
            2'b11 : LED = 4'b0001;
            default : LED = 4'b1111;
        endcase
    end

endmodule // Top

module debounce(pb_debounced, pb, clk);
    output pb_debounced;
    input pb;
    input clk;

    reg [3:0] DFF;
    always @(posedge clk ) begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end
    assign pb_debounced = &DFF;
endmodule // debounce

module onepulse(PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;
    always @(posedge clk ) begin
        PB_one_pulse <= PB_debounced & (!PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end
endmodule // onepulse