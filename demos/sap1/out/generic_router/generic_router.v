module generic_router (
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
endmodule
