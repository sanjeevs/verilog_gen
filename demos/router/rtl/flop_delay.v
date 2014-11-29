// --------------------------------------------------
//
// Generic Flip-Flop delay element
//
// This module is a generic flip-flop delay element with
// parameterizeable width and delay.  If depth is set to
// 0, then the delay element degenerates to a wire.
//
// --------------------------------------------------

module flop_delay
  #( parameter WIDTH=1,
     parameter DEPTH=1 )
(
  input  wire             clk,

  // signal interface
  input  wire [WIDTH-1:0] i,
  output wire [WIDTH-1:0] o
);

reg [WIDTH-1:0] delay_chain [DEPTH:0];

always @ (*) begin
  delay_chain[0] = i;
end

integer index;
always @ (posedge clk) begin
  for( index=1; index<=DEPTH; index=index+1 ) begin
    delay_chain[index] <= #0 delay_chain[index-1];
  end
end

assign o = delay_chain[DEPTH];

endmodule
