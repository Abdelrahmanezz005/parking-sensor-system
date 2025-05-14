module counter (
    input clk,
    input rst_n,
    input up,
    input down,
    output full,
    output empty,
    output reg [1:0] count  // 2-bit counter (0-3 cars)
);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    count <= 2'b00;
  else if (up && !down && count < 2'b11)  // Prevent overflow beyond 3
    count <= count + 1'b1;
  else if (down && !up && count > 2'b00)  // Prevent underflow below 0
    count <= count - 1'b1;
end

assign full = (count == 2'b11);  // Full at 3 cars (binary 11)
assign empty = (count == 2'b00); // Empty at 0 cars

endmodule