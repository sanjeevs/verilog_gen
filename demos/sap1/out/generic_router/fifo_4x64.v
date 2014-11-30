module fifo_4x64 (
);

  fifo_ctrl #(.DEPTH(4)) fifo_ctrl_inst(
    .clk(),
    .empty(),
    .full(),
    .mem_rd_addr(),
    .mem_rd_en(),
    .mem_wr_addr(),
    .mem_wr_en(),
    .pop(),
    .push(),
    .reset()
  );
  generic_mem #(.DEPTH(4), .WIDTH(64)) memory_inst(
    .clk(),
    .mem_rd_addr(),
    .mem_rd_data(),
    .mem_rd_en(),
    .mem_wr_addr(),
    .mem_wr_data(),
    .mem_wr_en()
  );
endmodule
