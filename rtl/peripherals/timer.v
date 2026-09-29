module timer (
    input clk,
    input reset,

    input        write_en,
    input [31:0] write_data,

    output [31:0] read_data,

    output reg tick
);

    reg [31:0] counter;
    reg [31:0] period;
    reg enabled;

    always @(posedge clk) begin

        if (reset) begin

            counter <= 32'd0;
            period  <= 32'd1000000;
            enabled <= 1'b0;
            tick    <= 1'b0;

        end

        else begin

            tick <= 1'b0;

            if (write_en) begin

                period  <= write_data;
                enabled <= 1'b1;

            end

            if (enabled) begin

                if (counter >= period) begin

                    counter <= 32'd0;
                    tick    <= 1'b1;

                end
                else begin

                    counter <= counter + 1'b1;

                end

            end

        end

    end

    assign read_data = {
        30'd0,
        enabled,
        tick
    };

endmodule