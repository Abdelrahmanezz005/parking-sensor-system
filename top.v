module top (
    input clk,
    input rst,
    input up,
    input down,
    input raw_entry,
    input raw_exit,
    input [7:0] rate,
    output [6:0] seg_car,
    output [6:0] seg_cost1,
    output [6:0] seg_cost0,
    output full,
    output empty,
    output alarm
);

    wire clk_1Hz;
    clock_divider clk_div_inst(
        .clk(clk),
        .reset(rst),
        .CLK1Hz(clk_1Hz)
    );

    reg [15:0] global_time;
    always @(posedge clk_1Hz or posedge rst) begin
        if (rst) global_time <= 0;
        else global_time <= global_time + 1;
    end

    wire entry_pulse, exit_pulse;
    wire d_up, d_down;
    
    edge_detector entry_ed(
        .clk(clk),
        .rst(rst),
        .signal_in(raw_entry),
        .pulse_out(entry_pulse)
    );
    
    edge_detector exit_ed(
        .clk(clk),
        .rst(rst),
        .signal_in(raw_exit),
        .pulse_out(exit_pulse)
    );
    
    edge_detector u1(
        .clk(clk),
        .rst(rst),
        .signal_in(up),
        .pulse_out(d_up)
    );
    
    edge_detector u2(
        .clk(clk),
        .rst(rst),
        .signal_in(down),
        .pulse_out(d_down)
    );

    wire allow_entry_wire, allow_exit_wire;
    wire [1:0] car_count;
    
    entry_exit_fsm fsm_inst(
        .clk(clk),
        .rst(rst),
        .entry_pulse(entry_pulse),
        .exit_pulse(exit_pulse),
        .count(car_count),
        .allow_entry(allow_entry_wire),
        .allow_exit(allow_exit_wire),
        .alarm(alarm)
    );

    counter car_counter(
        .clk(clk),
        .rst_n(~rst),
        .up(allow_entry_wire),
        .down(allow_exit_wire),
        .count(car_count),
        .full(full),
        .empty(empty)
    );

    wire [15:0] oldest_time;
    timestamp_buffer ts_buffer(
        .clk(clk),
        .rst(rst),
        .entry(allow_entry_wire),
        .exit(allow_exit_wire),
        .global_time(global_time),
        .oldest_time(oldest_time),
        .count()
    );

    wire [15:0] cost;
    wire [15:0] duration;
    cost_calculator calc_inst(
        .global_time(global_time),
        .oldest_time(oldest_time),
        .rate(rate),
        .enable(allow_exit_wire),
        .cost(cost),
        .duration(duration)
    );

    // Extract 4-bit BCD digits
    wire [3:0] car_count_bcd = {2'b00, car_count};
    wire [3:0] cost_tens_bcd = (cost / 10) % 10;
    wire [3:0] cost_units_bcd = cost % 10;

    sevenSegments car_display(
        .bcd(car_count_bcd),
        .dec(seg_car)
    );
    
    sevenSegments cost_tens(
        .bcd(cost_tens_bcd),
        .dec(seg_cost1)
    );
    
    sevenSegments cost_units(
        .bcd(cost_units_bcd),
        .dec(seg_cost0)
    );
endmodule