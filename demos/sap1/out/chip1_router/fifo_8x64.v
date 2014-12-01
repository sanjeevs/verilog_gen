module fifo_8x64 (
  input wire clk,
  output reg empty,
  output reg full,
  input wire pop,
  input wire push,
  input wire reset,
  input wire [2:0] bist_addr,
  input wire bist_clk,
  input wire bist_en,
  output wire [63:0] bist_rd_data,
  input wire [63:0] bist_wr_data,
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
  mem_16nm_ram8x64 memory_inst(
    .bist_addr(bist_addr[2:0]),
    .bist_clk(bist_clk),
    .bist_en(bist_en),
    .bist_rd_data(bist_rd_data[63:0]),
    .bist_wr_data(bist_wr_data[63:0]),
    .clk(clk),
    .mem_rd_addr(mem_rd_addr[2:0]),
    .mem_rd_data(mem_rd_data[63:0]),
    .mem_rd_en(mem_rd_en),
    .mem_wr_addr(mem_wr_addr[2:0]),
    .mem_wr_data(mem_wr_data[63:0]),
    .mem_wr_en(mem_wr_en)
  );
endmodule
