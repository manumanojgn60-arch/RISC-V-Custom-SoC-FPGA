module uart_tx #(
    parameter CLK_DIV = 434
)(
    input clk,
    input reset,

    input       send,
    input [7:0] data,

    output reg tx,
    output reg busy
);

    reg [15:0] baud_counter;

    reg [3:0] bit_count;

    reg [9:0] shift_reg;

    always @(posedge clk) begin

        if (reset) begin

            tx           <= 1'b1;
            busy         <= 1'b0;

            baud_counter <= 16'd0;
            bit_count    <= 4'd0;
            shift_reg    <= 10'b1111111111;

        end

        else begin

            if (send && !busy) begin

                shift_reg <= {
                    1'b1,
                    data,
                    1'b0
                };

                busy         <= 1'b1;
                bit_count    <= 4'd0;
                baud_counter <= 16'd0;

            end

            else if (busy) begin

                if (baud_counter >= CLK_DIV-1) begin

                    baud_counter <= 16'd0;

                    tx <= shift_reg[0];

                    shift_reg <= {
                        1'b1,
                        shift_reg[9:1]
                    };

                    if (bit_count == 4'd9) begin

                        busy      <= 1'b0;
                        bit_count <= 4'd0;
                        tx        <= 1'b1;

                    end
                    else begin

                        bit_count <= bit_count + 1'b1;

                    end

                end
                else begin

                    baud_counter <= baud_counter + 1'b1;

                end

            end

        end

    end

endmodule