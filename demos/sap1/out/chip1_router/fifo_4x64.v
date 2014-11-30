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
  mem_16nm_ram4x64 memory_inst(
    .bist_addr(bist_addr_1),
    .bist_clk(),
    .bist_en(bist_en_1),
    .bist_rd_data(bist_rd_data_1),
    .bist_wr_data(bist_wr_data_1),
    .clk(),
    .mem_rd_addr(),
    .mem_rd_data(),
    .mem_rd_en(),
    .mem_wr_addr(),
    .mem_wr_data(),
    .mem_wr_en()
  );
endmodule
