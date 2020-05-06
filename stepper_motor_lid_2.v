`timescale 1ns / 1ps

module pmod_step_interface_lid_2(
    input clk,
    input rst,
    input direction,
    input en,
    input [2-1:0] mode,
    output [3:0] signal_out
    );

    wire new_clk_net;

    clock_div_lid_2 div_lid2(
        .clk(clk), 
        .rst(rst),
        .mode(mode),
        .new_clk(new_clk_net)
    );

    pmod_step_driver_lid_2 control_lid2(
        .rst(rst),
        .dir(direction),
        .clk(new_clk_net),
        .en(en),
        .signal(signal_out)
        );    
    
endmodule

module clock_div_lid_2(
    input clk,
    input rst,
    input [2-1:0] mode,
    output reg new_clk
);

    localparam mode1_speed = 26'd300000;
    localparam mode2_speed = 26'd300000;
    localparam mode3_speed = 26'd300000;
    localparam mode4_speed = 26'd300000;

    reg [26-1:0] define_speed;
    reg [26-1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst == 1) begin
            count = {26{1'b0}};
            new_clk = 1'b0;
        end else if (count == define_speed) begin
            count = {26{1'b0}};
            new_clk = ~new_clk;
        end else begin
            count = count + 1'b1;
            new_clk = new_clk;
        end
    end

    always @(*) begin
        case (mode)
            2'b00: define_speed = mode1_speed;
            2'b01: define_speed = mode2_speed;
            2'b10: define_speed = mode3_speed;
            2'b11: define_speed = mode4_speed; 
            default: define_speed = mode1_speed;
        endcase
    end
endmodule // clock_div

module pmod_step_driver_lid_2(
    input rst,
    input dir,
    input clk,
    input en,
    output reg [3:0] signal
    );

    localparam sig4 = 3'b001;
    localparam sig3 = 3'b011;
    localparam sig2 = 3'b010;
    localparam sig1 = 3'b110;
    localparam sig0 = 3'b000;

    reg [2:0] present_state, next_state;

    always @ (present_state, dir, en)begin
        case(present_state)
        sig4 : begin
            if (dir == 1'b0 && en == 1'b1)
                next_state = sig3;
            else if (dir == 1'b1 && en == 1'b1)
                next_state = sig1;
            else 
                next_state = sig0;
        end  
        sig3 : begin
            if (dir == 1'b0&& en == 1'b1)
                next_state = sig2;
            else if (dir == 1'b1 && en == 1'b1)
                next_state = sig4;
            else 
                next_state = sig0;
        end 
        sig2 : begin
            if (dir == 1'b0&& en == 1'b1)
                next_state = sig1;
            else if (dir == 1'b1 && en == 1'b1)
                next_state = sig3;
            else 
                next_state = sig0;
        end 
        sig1 : begin
            if (dir == 1'b0&& en == 1'b1)
                next_state = sig4;
            else if (dir == 1'b1 && en == 1'b1)
                next_state = sig2;
            else 
                next_state = sig0;
        end
        sig0 : begin
            if (en == 1'b1)
                next_state = sig1;
            else 
                next_state = sig0;
        end
        default:
            next_state = sig0; 
        endcase
    end 

    always @ (posedge clk, posedge rst)begin
        if (rst == 1'b1)
            present_state = sig0;
        else 
            present_state = next_state;
    end

    always @ (posedge clk)
    begin
        if (present_state == sig4)
            signal = 4'b1000;
        else if (present_state == sig3)
            signal = 4'b0100;
        else if (present_state == sig2)
            signal = 4'b0010;
        else if (present_state == sig1)
            signal = 4'b0001;
        else
            signal = 4'b0000;
    end
endmodule

