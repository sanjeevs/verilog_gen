module generic_router (
  input wire clk,
  input wire reset,
  input wire [63:0] mem_rd_data,
  input wire [63:0] mem_wr_data,
  input wire [127:0] data_in,
  output wire [63:0] data_out
);

  fifo_4x64 src_fifo_0(
    .clk(clk),
    .empty(empty[0:0]),
    .full(full),
    .pop(pop[0:0]),
    .push(push),
    .reset(reset),
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
    .mem_rd_data(mem_rd_data[63:0]),
    .mem_wr_data(mem_wr_data[63:0])
  );
endmodule
