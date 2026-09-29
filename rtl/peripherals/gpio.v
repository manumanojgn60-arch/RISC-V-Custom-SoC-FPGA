module gpio (
    input clk,
    input reset,

    input        write_en,
    input        read_en,

    input [31:0] write_data,

    output [31:0] read_data,

    output [7:0] gpio_out
);

    reg [7:0] gpio_reg;

    always @(posedge clk) begin

        if (reset)

            gpio_reg <= 8'h00;

        else if (write_en)

            gpio_reg <= write_data[7:0];

    end

    assign gpio_out =
        gpio_reg;

    assign read_data =
        {24'd0, gpio_reg};

endmodule