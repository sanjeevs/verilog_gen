module chip2_router (
);

  chip1_router chip1(
    .clk(clk),
    .vld(vld_i)
  );
  flop_delay #(.DEPTH(2), .WIDTH(1)) repeater_vld(
    .clk(),
    .i(vld_i),
    .o(vld)
  );
endmodule
