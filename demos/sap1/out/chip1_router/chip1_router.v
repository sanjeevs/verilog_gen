module chip1_router (
  input wire clk,
  input wire reset,
  input wire bist_en,
  input wire [2:0] bist_addr,
  input wire [63:0] bist_wr_data,
  output wire [63:0] bist_rd_data,
  input wire bist_clk,
  input wire [63:0] mem_rd_data,
  input wire [63:0] mem_wr_data,
  input wire [127:0] data_in,
  output wire [63:0] data_out,
  output reg [1:0] bist_addr_0,
  output reg [1:0] bist_addr_1,
  output reg [2:0] bist_addr_2,
  output reg bist_en_0,
  output reg bist_en_1,
  output reg bist_en_2,
  input wire bist_on,
  input wire [63:0] bist_rd_data_0,
  input wire [63:0] bist_rd_data_1,
  input wire [63:0] bist_rd_data_2,
  input wire bist_reset,
  output reg [63:0] bist_wr_data_0,
  output reg [63:0] bist_wr_data_1,
  output reg [63:0] bist_wr_data_2
);

  fifo_4x64 src_fifo_0(
    .clk(clk),
    .empty(empty[0:0]),
    .full(full),
    .pop(pop[0:0]),
    .push(push),
    .reset(reset),
    .bist_en(bist_en),
    .bist_addr(bist_addr[1:0]),
    .bist_wr_data(bist_wr_data[63:0]),
    .bist_rd_data(bist_rd_data[63:0]),
    .bist_clk(bist_clk),
    .mem_rd_data(mem_rd_data[63:0]),
    .mem_wr_data(mem_wr_data[63:0])
  );
  fifo_4x64 src_fifo_1(
    .clk(clk),
    .empty(empty[0:0]),
    .full(full),
    .pop(pop[0:0]),
    .push(push),
    .reset(reset),
    .bist_en(bist_en),
    .bist_addr(bist_addr[1:0]),
    .bist_wr_data(bist_wr_data[63:0]),
    .bist_rd_data(bist_rd_data[63:0]),
    .bist_clk(bist_clk),
    .mem_rd_data(mem_rd_data[63:0]),
    .mem_wr_data(mem_wr_data[63:0])
  );
  rr_arb arb(
    .clk(clk),
    .cycle(cycle),
    .gnt(gnt[1:0]),
    .req(req[1:0]),
    .reset(reset)
  );
  router_ctrl #(.WIDTH(64)) router_ctrl(
    .clk(clk),
    .cycle(cycle),
    .data_in(src_fifo_data[127:0]),
    .data_out(data_out[63:0]),
    .empty(src_fifo_empty[1:0]),
    .full(full),
    .gnt(gnt[1:0]),
    .pop(src_fifo_pop[1:0]),
    .push(push),
    .req(req[1:0]),
    .reset(reset)
  );
  fifo_8x64 dst_fifo(
    .clk(clk),
    .empty(empty),
    .full(full),
    .pop(pop),
    .push(push),
    .reset(reset),
    .bist_addr(bist_addr[2:0]),
    .bist_clk(bist_clk),
    .bist_en(bist_en),
    .bist_rd_data(bist_rd_data[63:0]),
    .bist_wr_data(bist_wr_data[63:0]),
    .mem_rd_data(mem_rd_data[63:0]),
    .mem_wr_data(mem_wr_data[63:0])
  );
  mem_16nm_bist_ctrl bist_ctrl_inst(
    .bist_addr_0(bist_addr_0[1:0]),
    .bist_addr_1(bist_addr_1[1:0]),
    .bist_addr_2(bist_addr_2[2:0]),
    .bist_clk(bist_clk),
    .bist_en_0(bist_en_0),
    .bist_en_1(bist_en_1),
    .bist_en_2(bist_en_2),
    .bist_on(bist_on),
    .bist_rd_data_0(bist_rd_data_0[63:0]),
    .bist_rd_data_1(bist_rd_data_1[63:0]),
    .bist_rd_data_2(bist_rd_data_2[63:0]),
    .bist_reset(bist_reset),
    .bist_wr_data_0(bist_wr_data_0[63:0]),
    .bist_wr_data_1(bist_wr_data_1[63:0]),
    .bist_wr_data_2(bist_wr_data_2[63:0])
  );
endmodule
