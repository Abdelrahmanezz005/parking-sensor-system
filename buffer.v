module timestamp_buffer #(
    parameter TIME_WIDTH = 16
)(
    input wire clk,
    input wire rst,
    input wire entry,
    input wire exit,
    input wire [TIME_WIDTH-1:0] global_time,
    output reg [TIME_WIDTH-1:0] oldest_time,
    output reg [1:0] count
);
    reg [TIME_WIDTH-1:0] buffer [2:0];
    reg [1:0] head, tail;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            oldest_time <= 0;
        end else begin
            if (entry && count < 3) begin
                buffer[tail] <= global_time;
                tail <= (tail + 1) % 3;
                count <= count + 1;
            end
            if (exit && count > 0) begin
                oldest_time <= buffer[head];
                head <= (head + 1) % 3;
                count <= count - 1;
            end
        end
    end
endmodule
module cost_calculator #(
    parameter TIME_WIDTH = 16,
    parameter COST_WIDTH = 16
)(
    input wire [TIME_WIDTH-1:0] global_time,
    input wire [TIME_WIDTH-1:0] oldest_time,
    input wire [7:0] rate,
    input wire enable,
    output reg [COST_WIDTH-1:0] cost,
    output reg [TIME_WIDTH-1:0] duration
);
    always @(*) begin
        if (enable) begin
            if (global_time >= oldest_time) begin
                duration = global_time - oldest_time;
                cost = duration * rate;
            end else begin
                duration = 0;
                cost = 0;
            end
        end else begin
            duration = 0;
            cost = 0;
        end
    end
endmodule