// --------------------------------------------------
//
// BIST controller for the given implementation
//
// --------------------------------------------------

module mem_16nm_bist_ctrl
(
  input  wire        bist_clk,
  input  wire        bist_reset,
  input  wire        bist_on,

  output reg         bist_en_0,
  output reg  [1:0]  bist_addr_0,
  output reg  [63:0] bist_wr_data_0,
  input  wire [63:0] bist_rd_data_0,

  output reg         bist_en_1,
  output reg  [1:0]  bist_addr_1,
  output reg  [63:0] bist_wr_data_1,
  input  wire [63:0] bist_rd_data_1,

  output reg         bist_en_2,
  output reg  [2:0]  bist_addr_2,
  output reg  [63:0] bist_wr_data_2,
  input  wire [63:0] bist_rd_data_2
);

always @ (posedge clk ) begin
  if( bist_reset ) begin
    bist_en_0 <= #0 1'b0;
    bist_en_1 <= #0 1'b0;
    bist_en_2 <= #0 1'b0;
    bist_addr_0 <= #0 4'd0;
    bist_addr_1 <= #0 4'd1;
    bist_addr_2 <= #0 4'd2;
    bist_wr_data_0 <= #0 64'd0;
    bist_wr_data_1 <= #0 64'd1;
    bist_wr_data_2 <= #0 64'd2;
  end
  else begin
    if( bist_on ) begin
      bist_en_0 <= #0 1'b1;
      bist_en_1 <= #0 1'b1;
      bist_en_2 <= #0 1'b1;
      bist_addr_0 <= #0 bist_addr_0 + 1;
      bist_addr_1 <= #0 bist_addr_1 + 1;
      bist_addr_2 <= #0 bist_addr_2 + 1;
      bist_wr_data_0 <= #0 bist_wr_data_0 + 1;
      bist_wr_data_1 <= #0 bist_wr_data_1 + 1;
      bist_wr_data_2 <= #0 bist_wr_data_2 + 1;
    end
  end
end

endmodule
