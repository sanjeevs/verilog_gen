module chip1_router (
  input wire clk,
  output reg vld
);

  fifo_4x64 src_fifo_0(
  );
  fifo_4x64 src_fifo_1(
  );
  rr_arb arb(
    .clk(),
    .cycle(),
    .gnt(),
    .req(),
    .reset()
  );
  router_ctrl #(.WIDTH(64)) router_ctrl(
    .clk(),
    .cycle(),
    .data_in(src_fifo_data),
    .data_out(),
    .empty(src_fifo_empty),
    .full(),
    .gnt(),
    .pop(src_fifo_pop),
    .push(),
    .req(),
    .reset()
  );
  fifo_8x64 dst_fifo(
  );
  mem_16nm_bist_ctrl bist_ctrl_inst(
    .bist_addr_0(),
    .bist_addr_1(),
    .bist_addr_2(),
    .bist_clk(),
    .bist_en_0(),
    .bist_en_1(),
    .bist_en_2(),
    .bist_on(),
    .bist_rd_data_0(),
    .bist_rd_data_1(),
    .bist_rd_data_2(),
    .bist_reset(),
    .bist_wr_data_0(),
    .bist_wr_data_1(),
    .bist_wr_data_2()
  );
endmodule
