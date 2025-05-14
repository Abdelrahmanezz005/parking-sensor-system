module clock_divider(
    input clk,         // 50 MHz clock input
    input reset,       // Reset input
    output reg CLK1Hz  // 1 Hz output clock
);

    parameter DIV = 25_000_000;         // Half of 50 million for 0.5 second toggle
    reg [24:0] counter;                 // 25-bit counter to count up to 25 million

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;              // Reset counter to 0
            CLK1Hz <= 0;               // Set output clock to 0
        end else begin
            if (counter == DIV - 1) begin
                counter <= 0;          // Reset counter
                CLK1Hz <= ~CLK1Hz;     // Toggle output clock (0 → 1 or 1 → 0)
            end else begin
                counter <= counter + 1; // Keep counting
            end
        end
    end

endmodule
