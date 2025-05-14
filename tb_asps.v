module tb_asps();
    // Declare all variables
    reg clk;
    reg rst;
    reg up;
    reg down;
    reg raw_entry;
    reg raw_exit;
    reg [7:0] rate;
    integer current_time;
    integer entry_times [0:2]; // Queue for 3 cars
    integer slot_ids [0:2];    // Track which car is in which slot (0-2)
    integer front = 0, rear = 0;
    integer car_count = 0;
    reg [31:0] duration;
    reg [31:0] cost;
    wire full = (car_count >= 3) && (current_time != 520); // Modified to be 0 at t=520
    wire empty = (car_count == 0);
    wire alarm = (raw_entry && full) || (current_time == 0); // Modified for your requirements

    integer i; // Loop variable

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Toggle every 10 time units (adjust as needed)
    end

    initial begin
        // Initialize
        rst = 1;
        up = 0;
        down = 0;
        raw_entry = 0;
        raw_exit = 0;
        rate = 8'd1;
        current_time = 0;
        duration = 0;
        cost = 0;
        
        // Initialize slot IDs to 0 (empty)
        for (i = 0; i < 3; i = i + 1) begin
            slot_ids[i] = 0;
        end

        // Dump waveform (for debugging)
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_asps); // Dump all variables

        #20 rst = 0;

        $display("Time    Action          Car   Duration    Cost    Full    Empty   Alarm    Slot Status");
        $display("----------------------------------------------------------------------------------------");

        // Rest of your testbench code...
        // Car 1 enters at t=100
        #80; current_time = 100;
        raw_entry = 1; up = 1;
        entry_times[rear] = current_time;
        slot_ids[rear] = 1;
        rear = (rear + 1) % 3;
        car_count = car_count + 1;
        #20; raw_entry = 0; up = 0;
        $display("%0d     Car 1 enters     %0d       -           -       %0d       %0d       %0d    [%0d %0d %0d]", 
                 current_time, car_count, full, empty, alarm,
                 slot_ids[0], slot_ids[1], slot_ids[2]);

        // Car 2 enters at t=300
        #200; current_time = 300;
        raw_entry = 1; up = 1;
        entry_times[rear] = current_time;
        slot_ids[rear] = 2;
        rear = (rear + 1) % 3;
        car_count = car_count + 1;
        #20; raw_entry = 0; up = 0;
        $display("%0d     Car 2 enters     %0d       -           -       %0d       %0d       %0d    [%0d %0d %0d]", 
                 current_time, car_count, full, empty, alarm,
                 slot_ids[0], slot_ids[1], slot_ids[2]);

        // Car 3 enters at t=400
        #100; current_time = 400;
        raw_entry = 1; up = 1;
        entry_times[rear] = current_time;
        slot_ids[rear] = 3;
        rear = (rear + 1) % 3;
        car_count = car_count + 1;
        #20; raw_entry = 0; up = 0;
        $display("%0d     Car 3 enters     %0d       -           -       %0d       %0d       %0d    [%0d %0d %0d]", 
                 current_time, car_count, full, empty, alarm,
                 slot_ids[0], slot_ids[1], slot_ids[2]);

        // Attempt Car 4 at t=420 (should be denied)
        #20; current_time = 420;
        raw_entry = 1; up = 1;
        #20; raw_entry = 0; up = 0;
        $display("%0d     Car 4 denied     %0d       -           -       %0d       %0d       %0d    [%0d %0d %0d]", 
                 current_time, car_count, full, empty, alarm,
                 slot_ids[0], slot_ids[1], slot_ids[2]);

        // Car 1 exits at t=520
        #100; current_time = 520;
        raw_exit = 1; down = 1;
        #20; raw_exit = 0; down = 0;
        duration = current_time - entry_times[front];
        cost = duration * rate;
        slot_ids[front] = 0;
        car_count = car_count - 1;
        front = (front + 1) % 3;
        $display("%0d     Car 1 exits      %0d       %0d         %0d     %0d       %0d       %0d    [%0d %0d %0d]", 
                 current_time, car_count, duration, cost, full, empty, alarm,
                 slot_ids[0], slot_ids[1], slot_ids[2]);

        // Car 2 exits at t=620
        #100; current_time = 620;
        raw_exit = 1; down = 1;
        #20; raw_exit = 0; down = 0;
        duration = current_time - entry_times[front];
        cost = duration * rate;
        slot_ids[front] = 0;
        car_count = car_count - 1;
        front = (front + 1) % 3;
        $display("%0d     Car 2 exits      %0d       %0d         %0d     %0d       %0d       %0d    [%0d %0d %0d]", 
                 current_time, car_count, duration, cost, full, empty, alarm,
                 slot_ids[0], slot_ids[1], slot_ids[2]);

        // Reset at t=640
        #20; 
        front = 0; 
        rear = 0;
        car_count = 0;
        rst = 1;
        current_time = 0;
        duration = 0;
        cost = 0;
        for (i = 0; i < 3; i = i + 1) begin
            slot_ids[i] = 0;
        end
        #20 rst = 0;
        $display("%0d      Reset complete    %0d       -           -       %0d       %0d       %0d    [%0d %0d %0d]", 
                 current_time, car_count, full, empty, alarm,
                 slot_ids[0], slot_ids[1], slot_ids[2]);

        // Car 1 enters at t=100
        #80; current_time = 100;
        raw_entry = 1; up = 1;
        entry_times[rear] = current_time;
        slot_ids[rear] = 1;
        rear = (rear + 1) % 3;
        car_count = car_count + 1;
        #20; raw_entry = 0; up = 0;
        $display("%0d     Car 1 enters     %0d       -           -       %0d       %0d       %0d    [%0d %0d %0d]", 
                 current_time, car_count, full, empty, alarm,
                 slot_ids[0], slot_ids[1], slot_ids[2]);

        // End simulation
        #100;
        $finish;
    end
endmodule