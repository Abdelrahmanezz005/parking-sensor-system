module edge_detector(
    input clk,
    input rst,
    input signal_in,
    output reg pulse_out
);
    reg signal_d1, signal_d2;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            signal_d1 <= 0;
            signal_d2 <= 0;
            pulse_out <= 0;
        end else begin
            signal_d1 <= signal_in;
            signal_d2 <= signal_d1;
            pulse_out <= signal_d1 & ~signal_d2; // Rising edge detection
        end
    end
endmodule