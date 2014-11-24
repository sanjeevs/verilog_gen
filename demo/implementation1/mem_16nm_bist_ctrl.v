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
  output reg         bist_en      [2:0],
  output reg  [3:0]  bist_addr    [2:0],
  output reg  [72:0] bist_wr_data [2:0],
  input  wire [72:0] bist_rd_data [2:0]
);

always @ (posedge clk ) begin
  if( bist_reset ) begin
    bist_en[0] <= #0 1'b0;
    bist_en[1] <= #0 1'b0;
    bist_en[2] <= #0 1'b0;
    bist_addr[0] <= #0 4'd0;
    bist_addr[1] <= #0 4'd1;
    bist_addr[2] <= #0 4'd2;
    bist_wr_data[0] <= #0 73'd0;
    bist_wr_data[1] <= #0 73'd1;
    bist_wr_data[2] <= #0 73'd2;
  end
  else begin
    if( bist_on ) begin
      bist_en[0] <= #0 1'b1;
      bist_en[1] <= #0 1'b1;
      bist_en[2] <= #0 1'b1;
      bist_addr[0] <= #0 bist_addr[0] + 1;
      bist_addr[1] <= #0 bist_addr[1] + 1;
      bist_addr[2] <= #0 bist_addr[2] + 1;
      bist_wr_data[0] <= #0 bist_wr_data[0] + 1;
      bist_wr_data[1] <= #0 bist_wr_data[1] + 1;
      bist_wr_data[2] <= #0 bist_wr_data[2] + 1;
    end
  end
end

endmodule
