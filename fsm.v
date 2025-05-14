module entry_exit_fsm(
    input clk,
    input rst,
    input entry_pulse,
    input exit_pulse,
    input [1:0] count,
    output reg allow_entry,
    output reg allow_exit,
    output reg alarm
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            allow_entry <= 0;
            allow_exit <= 0;
            alarm <= 0;
        end else begin
            allow_entry <= 0;
            allow_exit <= 0;
            alarm <= 0;

            if (entry_pulse) begin
                if (count < 3) allow_entry <= 1;
                else alarm <= 1;
            end

            if (exit_pulse) begin
                if (count > 0) allow_exit <= 1;
                else alarm <= 1;
            end
        end
    end
endmodule
