module counter(
    clk, rst, start, delay, done
);
    input clk;
    input rst;
    input start;
    input [8-1:0] delay;
    output reg done;

    reg [27-1:0] signal, next_signal;
    reg [8-1:0] count, next_count;

    always@(posedge clk) begin
        if (rst == 1) begin
            signal <= 0;
            count <= 0;
        end
        else begin
            signal <= next_signal;
            count <= next_count;
        end
    end

    always@(*) begin
        next_signal = signal;
        if (start) begin
            if (signal == 27'd100000000) begin
                next_count = count + 1;
                next_signal = 0;
            end
            else begin
                next_count = count;
                next_signal = signal + 1;   
            end
            if (count == delay) done = 1;
            else done = 0;
        end
        else begin
            done = 0;
            next_signal = 0;
            next_count = 0;
        end

    end
endmodule // counter