module fifo_4x64 (
  input wire clk,
  output reg [1:0] empty,
  output reg full,
  input wire [1:0] pop,
  input wire push,
  input wire reset,
  input wire bist_en,
  input wire [2:0] bist_addr,
  input wire [63:0] bist_wr_data,
  output wire [63:0] bist_rd_data,
  input wire bist_clk,
  input wire [63:0] mem_rd_data,
  input wire [63:0] mem_wr_data
);

  fifo_ctrl #(.DEPTH(4)) fifo_ctrl_inst(
    .clk(clk),
    .empty(empty[0:0]),
    .full(full),
    .mem_rd_addr(mem_rd_addr[1:0]),
    .mem_rd_en(mem_rd_en),
    .mem_wr_addr(mem_wr_addr[1:0]),
    .mem_wr_en(mem_wr_en),
    .pop(pop[0:0]),
    .push(push),
    .reset(reset)
  );
  mem_16nm_ram4x64 memory_inst(
    .bist_addr(bist_addr_1[1:0]),
    .bist_clk(bist_clk),
    .bist_en(bist_en_1),
    .bist_rd_data(bist_rd_data_1[63:0]),
    .bist_wr_data(bist_wr_data_1[63:0]),
    .clk(clk),
    .mem_rd_addr(mem_rd_addr[1:0]),
    .mem_rd_data(mem_rd_data[63:0]),
    .mem_rd_en(mem_rd_en),
    .mem_wr_addr(mem_wr_addr[1:0]),
    .mem_wr_data(mem_wr_data[63:0]),
    .mem_wr_en(mem_wr_en)
  );
endmodule
