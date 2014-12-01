module fifo_8x64 (
  input wire clk,
  output reg empty,
  output reg full,
  input wire pop,
  input wire push,
  input wire reset,
  input wire [63:0] mem_rd_data,
  input wire [63:0] mem_wr_data
);

  fifo_ctrl #(.DEPTH(8)) fifo_ctrl_inst(
    .clk(clk),
    .empty(empty),
    .full(full),
    .mem_rd_addr(mem_rd_addr[2:0]),
    .mem_rd_en(mem_rd_en),
    .mem_wr_addr(mem_wr_addr[2:0]),
    .mem_wr_en(mem_wr_en),
    .pop(pop),
    .push(push),
    .reset(reset)
  );
  generic_mem #(.DEPTH(8), .WIDTH(64)) memory_inst(
    .clk(clk),
    .mem_rd_addr(mem_rd_addr[2:0]),
    .mem_rd_data(mem_rd_data[63:0]),
    .mem_rd_en(mem_rd_en),
    .mem_wr_addr(mem_wr_addr[2:0]),
    .mem_wr_data(mem_wr_data[63:0]),
    .mem_wr_en(mem_wr_en)
  );
endmodule
