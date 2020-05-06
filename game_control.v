`timescale 1ns / 1ps

//////////////// 2019.12.24 ///////////////////////////
// 1. state transition : wait, open_lid, hand_out, hand_in, close_lid
// 2. only one mode version
// 3. add motor_delay, done_motor, start_motor to check if motor move completely
///////////////////////////////////////////////////////
// Engineer: Lisa LC Chen, Bao BS Haung

module GameControl(
    clk, rst, switch_signal, mode, enable1, enable2 ,direction1, direction2, state, mode4_handout_count
);
    input clk;
    input rst;
    input switch_signal;
    
    output reg enable1;
    output reg enable2;
    output reg direction1;
    output reg direction2;

    output [3-1:0] mode4_handout_count;

    wire [2-1:0] random_mode; 
    reg [5-1:0] random_mode_count;
    wire [5-1:0] next_random_mode_count;

    parameter mode1 = 2'b00; // default
    parameter mode2 = 2'b01; // 
    parameter mode3 = 2'b10; // 
    parameter mode4 = 2'b11; // 

    parameter Wait = 3'b000;
    parameter Open_lid = 3'b001;
    parameter Hand_out = 3'b010;
    parameter Hand_in = 3'b011;
    parameter Close_lid = 3'b100;

    parameter open = 0; 
    parameter close = 1;

    parameter on = 1;
    parameter off = 0;

    output reg [5-1:0] state;
    reg [5-1:0] next_state;
    output reg [2-1:0] mode;
    reg [2-1:0] next_mode;

    reg [3-1:0] mode3_open_count;
    reg [3-1:0] next_mode3_open_count;

    reg [3-1:0] mode4_handout_count;
    reg [3-1:0] next_mode4_handout_count;


    reg start, start_motor, next_start, next_start_motor;
    wire done, done_motor;
    reg [8-1:0] delay, motor_delay;

    reg next_enable1, next_enable2;
    reg next_direction1, next_direction2;

    reg complete, next_complete;

    reg [8-1:0] open_lid_delay, handout_delay, handin_delay, close_lid_delay;

    reg finish_mode3, next_finish_mode3;
    reg finish_mode4, next_finish_mode4;

    counter c(
        clk, rst, start, delay, done
    );
    counter m(
        clk, rst, start_motor, motor_delay, done_motor
    );


    // to generate random number
    always @(posedge clk ) begin
        if (rst == 1) random_mode_count <= 5'b0;
        else random_mode_count <= next_random_mode_count;
    end 
    assign next_random_mode_count = random_mode_count + 1;
    assign random_mode = random_mode_count % 4;

    always @(posedge clk ) begin
        if (rst == 1) begin
            state <= {2'b00, Wait};
            mode <= 2'b00;
        end else begin
            state <= next_state;
            mode <= next_mode;
        end
    end

    always @(posedge clk ) begin
        if (rst == 1) begin
            enable1 <= 0;
            enable2 <= 0;
            direction1 <= 0;
            direction2 <= 0;
            complete <= 0;
            start <= 0;
            start_motor <= 0;
        end else begin
            enable1 <= next_enable1;
            enable2 <= next_enable2;
            direction1 <= next_direction1;
            direction2 <= next_direction2;
            complete <= next_complete;
            start <= next_start;
            start_motor <= next_start_motor;
        end
    end

    

    always@(posedge clk)begin
        if(rst == 1)begin
            finish_mode3 <= 1'b0;
            mode3_open_count <= 3'b000;
        end
        else begin
            finish_mode3 <= next_finish_mode3;
            mode3_open_count <= next_mode3_open_count;
        end
    end

    always @(posedge clk ) begin
        if (rst == 1) begin
            finish_mode4 <= 1'b0;
            mode4_handout_count <= 3'b000;
        end else begin
            finish_mode4 <= next_finish_mode4;
            mode4_handout_count <= next_mode4_handout_count;
        end
    end

    


// --------------------------------------- state transition & counter --------------------------------------- //
    always @(*) begin
        case (state)
            {mode, Wait}: begin
                if (switch_signal == on) begin
                    next_mode = random_mode;
                    next_state = {random_mode, Open_lid};
                    next_start = 0;
                    delay = open_lid_delay;
                end else begin
                    next_mode = mode;
                    next_state = {mode, Wait};
                    next_start = 0;
                end
                next_mode3_open_count = 3'b000;
                next_mode4_handout_count = 3'b000;
                next_finish_mode3 = 0;
                next_finish_mode4 = 0;
            end
            {mode1, Open_lid}: begin
                if (done == 1) begin 
                    next_state = {mode1, Hand_out};
                    next_start = 0;
                end else begin
                    next_state = {mode1, Open_lid};
                    next_start = 1;
                    delay = open_lid_delay;
                end  
                next_mode = mode1;
            end
            {mode1, Hand_out}: begin
                if (done == 1) begin
                    next_state = {mode1, Hand_in};
                    next_start = 0;
                end else begin
                    next_state = {mode1, Hand_out};
                    next_start = 1;
                    delay = handout_delay;
                end
                next_mode = mode1;
            end
            {mode1, Hand_in}: begin
                if (done == 1) begin
                    next_state = {mode1, Close_lid};
                    next_start = 0;
                end else begin
                    next_state = {mode1, Hand_in};
                    next_start = 1;
                    delay = handin_delay;
                end
                next_mode = mode1;
            end
            {mode1, Close_lid}: begin
                if (done == 1) begin // each operation delay: default 30 counts
                    next_state = {mode1, Wait};
                    next_start = 0;
                end else begin
                    next_state = {mode1, Close_lid};
                    next_start = 1;
                    delay = close_lid_delay;
                end
                next_mode = mode1;
            end
            {mode2, Open_lid}: begin
                if (done == 1) begin 
                    next_state = {mode2, Hand_out};
                    next_start = 0;
                end else begin
                    next_state = {mode2, Open_lid};
                    next_start = 1;
                    delay = open_lid_delay;
                end  
                next_mode = mode2;
            end
            {mode2, Hand_out}: begin
                if (done == 1) begin
                    next_state = {mode2, Hand_in};
                    next_start = 0;
                end else begin
                    next_state = {mode2, Hand_out};
                    next_start = 1;
                    delay = handout_delay;
                end
                next_mode = mode2;
            end
            {mode2, Hand_in}: begin
                if (done == 1) begin
                    next_state = {mode2, Close_lid};
                    next_start = 0;
                end else begin
                    next_state = {mode2, Hand_in};
                    next_start = 1;
                    delay = handin_delay;
                end
                next_mode = mode2;
            end
            {mode2, Close_lid}: begin
                if (done == 1) begin // each operation delay: default 30 counts
                    next_state = {mode2, Wait};
                    next_start = 0;
                end else begin
                    next_state = {mode2, Close_lid};
                    next_start = 1;
                    delay = close_lid_delay;
                end
                next_mode = mode2;
            end
            {mode3, Open_lid}: begin
                next_finish_mode3 = 1'b0;
                next_mode = mode3;
                if (done == 1) begin 
                    next_state = ((mode3_open_count == 3'b101) || (mode3_open_count == 3'b100) || (mode3_open_count == 3'b011))? {mode3, Hand_out}: {mode3, Close_lid};
                    next_start = 0;
                    next_mode3_open_count = mode3_open_count + 1;
                end else begin
                    next_state = {mode3, Open_lid};
                    next_start = 1;
                    delay = open_lid_delay;
                end  
            end
            {mode3, Hand_out}: begin
                next_mode3_open_count = 3'b000;
                next_finish_mode3 = 1'b1;
                if (done == 1) begin
                    next_state = {mode3, Hand_in};
                    next_start = 0;
                end else begin
                    next_state = {mode3, Hand_out};
                    next_start = 1;
                    delay = handout_delay;
                end
                next_mode = mode3;
            end
            {mode3, Hand_in}: begin
                next_mode3_open_count = 3'b000;
                next_finish_mode3 = 1'b1;
                if (done == 1) begin
                    next_state = {mode3, Close_lid};
                    next_start = 0;
                end else begin
                    next_state = {mode3, Hand_in};
                    next_start = 1;
                    delay = handin_delay;
                end
                next_mode = mode3;
            end
            {mode3, Close_lid}: begin
                next_finish_mode3 = finish_mode3;
                next_mode3_open_count = mode3_open_count;
                if (done == 1) begin 
                    next_state = (finish_mode3 == 1'b1)? {mode3, Wait}: {mode3, Open_lid};
                    next_start = 0;
                end else begin
                    next_state = {mode3, Close_lid};
                    next_start = 1;
                    delay = close_lid_delay;
                end
                next_mode = mode3;
            end
            {mode4, Open_lid}: begin
                next_mode4_handout_count = 3'b000;
                next_finish_mode4 = 0;
                next_mode = mode4;
                if (done == 1) begin 
                    next_state = {mode4, Hand_out};
                    next_start = 0;
                end else begin
                    next_state = {mode4, Open_lid};
                    next_start = 1;
                    delay = open_lid_delay;
                end  
            end
            {mode4, Hand_out}: begin
                if (done == 1) begin
                    next_mode4_handout_count = mode4_handout_count + 1;
                    next_state = {mode4, Hand_in};
                    next_start = 0;
                    next_finish_mode4 = ((mode4_handout_count == 3'b011) || (mode4_handout_count == 3'b100))? 1'b1 : 1'b0;
                end else begin
                    next_state = {mode4, Hand_out};
                    next_start = 1;
                    delay = handout_delay;
                    next_finish_mode4 = finish_mode4;
                end
                next_mode = mode4;
            end
            {mode4, Hand_in}: begin
                next_mode4_handout_count = mode4_handout_count;
                if (done == 1) begin
                    next_state = (finish_mode4 == 1'b1)? {mode4, Close_lid} : {mode4, Hand_out};                                                                        
                    next_start = 0;
                end else begin
                    next_state = {mode4, Hand_in};
                    next_start = 1;
                    delay = handin_delay;
                end
                next_mode = mode4;
            end
            {mode4, Close_lid}: begin
                next_mode4_handout_count = 3'b000;
                next_finish_mode4 = 1'b0;
                if (done == 1) begin 
                    next_state = {mode4, Wait};
                    next_start = 0;
                end else begin
                    next_state = {mode4, Close_lid};
                    next_start = 1;
                    delay = close_lid_delay;
                end
                next_mode = mode4;
            end
            
            default: begin
                next_mode = mode;
                next_state = state;
                next_start = 0;
                next_mode3_open_count = mode3_open_count;
                next_mode4_handout_count = mode4_handout_count;
                next_finish_mode3 = finish_mode3;
                next_finish_mode4 = finish_mode4;
            end
        endcase
    end


// ------------------------------- update enable1 enable2 direction1 direction2 ------------------------------- //
    always@(*)begin
        case(state)
            {mode, Wait} : begin
                next_enable1 = 1'b0;
                next_enable2 = 1'b0;
                next_direction1 = open;
                next_direction2 = open;
                next_complete = 0;
                next_start_motor = 0;
            end
            {mode1, Open_lid} : begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable1 = 0;
                    next_direction1 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable1 = 1;
                    next_direction1 = open;
                    next_start_motor = 1;
                    motor_delay = 3;
                    next_complete = 0;
                end
                next_enable2 = 1'b0;
                next_direction2 = open;
            end
            {mode1, Hand_out}: begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable2 = 0;
                    next_direction2 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable2 = 1;
                    next_direction2 = open;
                    next_start_motor = 1;
                    motor_delay = 6;
                    next_complete = 0;
                end
                next_enable1 = 0;
                next_direction1 = open;
            end
            {mode1, Hand_in}: begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable2 = 0;
                    next_direction2 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable2 = 1;
                    next_direction2 = close;
                    next_start_motor = 1;
                    motor_delay = 6;
                    next_complete = 0;
                end
                next_enable1 = 0;
                next_direction1 = open;
            end
            {mode1, Close_lid} : begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable1 = 0;
                    next_direction1 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable1 = 1;
                    next_direction1 = close;
                    next_start_motor = 1;
                    motor_delay = 3;
                    next_complete = 0;
                end
                next_enable2 = 1'b0;
                next_direction2 = open;
            end
            {mode2, Open_lid} : begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable1 = 0;
                    next_direction1 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable1 = 1;
                    next_direction1 = open;
                    next_start_motor = 1;
                    motor_delay = 3;
                    next_complete = 0;
                end
                next_enable2 = 1'b0;
                next_direction2 = open;
            end
            {mode2, Hand_out}: begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable2 = 0;
                    next_direction2 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable2 = 1;
                    next_direction2 = open;
                    next_start_motor = 1;
                    motor_delay = 6;
                    next_complete = 0;
                end
                next_enable1 = 0;
                next_direction1 = open;
            end
            {mode2, Hand_in}: begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable2 = 0;
                    next_direction2 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable2 = 1;
                    next_direction2 = close;
                    next_start_motor = 1;
                    motor_delay = 6;
                    next_complete = 0;
                end
                next_enable1 = 0;
                next_direction1 = open;
            end
            {mode2, Close_lid} : begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable1 = 0;
                    next_direction1 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable1 = 1;
                    next_direction1 = close;
                    next_start_motor = 1;
                    motor_delay = 3;
                    next_complete = 0;
                end
                next_enable2 = 1'b0;
                next_direction2 = open;
            end
            {mode3, Open_lid} : begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable1 = 0;
                    next_direction1 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable1 = 1;
                    next_direction1 = open;
                    next_start_motor = 1;
                    motor_delay = 3;
                    next_complete = 0;
                end
                next_enable2 = 1'b0;
                next_direction2 = open;
            end
            {mode3, Hand_out}: begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable2 = 0;
                    next_direction2 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable2 = 1;
                    next_direction2 = open;
                    next_start_motor = 1;
                    motor_delay = 6;
                    next_complete = 0;
                end
                next_enable1 = 0;
                next_direction1 = open;
            end
            {mode3, Hand_in}: begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable2 = 0;
                    next_direction2 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable2 = 1;
                    next_direction2 = close;
                    next_start_motor = 1;
                    motor_delay = 6;
                    next_complete = 0;
                end
                next_enable1 = 0;
                next_direction1 = open;
            end
            {mode3, Close_lid} : begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable1 = 0;
                    next_direction1 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable1 = 1;
                    next_direction1 = close;
                    next_start_motor = 1;
                    motor_delay = 3;
                    next_complete = 0;
                end
                next_enable2 = 1'b0;
                next_direction2 = open;
            end
            {mode4, Open_lid} : begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable1 = 0;
                    next_direction1 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable1 = 1;
                    next_direction1 = open;
                    next_start_motor = 1;
                    motor_delay = 3;
                    next_complete = 0;
                end
                next_enable2 = 1'b0;
                next_direction2 = open;
            end
            {mode4, Hand_out}: begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable2 = 0;
                    next_direction2 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable2 = 1;
                    next_direction2 = open;
                    next_start_motor = 1;
                    motor_delay = 6;
                    next_complete = 0;
                end
                next_enable1 = 0;
                next_direction1 = open;
            end
            {mode4, Hand_in}: begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable2 = 0;
                    next_direction2 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable2 = 1;
                    next_direction2 = close;
                    next_start_motor = 1;
                    motor_delay = 6;
                    next_complete = 0;
                end
                next_enable1 = 0;
                next_direction1 = open;
            end
            {mode4, Close_lid} : begin
                if (done_motor == 1 || complete == 1) begin
                    next_enable1 = 0;
                    next_direction1 = open;
                    next_start_motor = 0;
                    next_complete = (state == next_state)? 1: 0;
                end else begin
                    next_enable1 = 1;
                    next_direction1 = close;
                    next_start_motor = 1;
                    motor_delay = 3;
                    next_complete = 0;
                end
                next_enable2 = 1'b0;
                next_direction2 = open;
            end
            default : begin
                next_enable1 = enable1;
                next_enable2 = enable2;
                next_direction1 = direction1;
                next_direction2 = direction2;
                next_complete = 0;
                next_start_motor = start_motor;
            end
        endcase
    end
    
// ------------------------------- choose delay according to the mode ------------------------------- //
    
    always @(*) begin
        case (mode)
            mode1: begin
                open_lid_delay = 3;
                close_lid_delay = 3;
                handout_delay = 6;
                handin_delay = 6;
            end
            mode2: begin
                open_lid_delay = 15;
                close_lid_delay = 3;
                handout_delay = 10;
                handin_delay = 10;
            end
            mode3: begin
                open_lid_delay = 3;
                close_lid_delay = 3;
                handout_delay = 6;
                handin_delay = 6;
            end
            mode4: begin
                open_lid_delay = 3;
                close_lid_delay = 3;
                handout_delay = 6;
                handin_delay = 6;
            end
            default: begin
                open_lid_delay = 3;
                close_lid_delay = 3;
                handout_delay = 6;
                handin_delay = 6;
            end
        endcase
    end

endmodule // GameControl



