`include "rah_var_defs.vh"

module rah_version_check (
	input                               clk,
	input [RAH_PACKET_WIDTH-1:0]        in_data,
    input                               q_empty,

	output reg                          request_data = 0,
	output reg                          w_en = 0,
    output reg [RAH_PACKET_WIDTH-1:0]   out_data = 0,

    output reg                          debug_periplex_wr = 0,
    output reg                          debug_periplex_rd = 0
);

parameter RAH_PACKET_WIDTH = 48;

reg [2:0] state = 0;

always @(posedge clk) begin
    case (state)
        0: begin
            w_en <= 0;
            out_data <= 0;

            if (~q_empty) begin
                state <= 1;
                request_data <= 1;
            end
        end

        1: begin
            request_data <= 0;
            state <= 2;
        end

        2: begin
            state <= 0;

            case (in_data[47:40])
                0: begin
                    out_data <= `VERSION;
                    w_en <= 1;
                end

                3: begin
                    debug_periplex_wr <= in_data[0];
                    debug_periplex_rd <= in_data[1];
                end

                default: begin
                    state <= 0;
                end
            endcase
        end
    endcase
end

endmodule
