// --------------------------------------------------
//
// Generic round robin arbiter
//
// A generic round robin arbiter with parameterizeable number of clients
//
// --------------------------------------------------

module rr_arb
  #( parameter CLIENTS=2 )
(
  input  wire               clk,
  input  wire               reset,

  input  wire               cycle,
  input  wire [CLIENTS-1:0] req,
  output reg  [CLIENTS-1:0] gnt
);

wire                 active_req;
reg  [CLIENTS-1:0]   previous_winner;
wire [2*CLIENTS-1:0] start_array;

assign active_req = cycle && |req;

integer index;
integer allowed;
assign start_array = {{CLIENTS{1'b0}},previous_winner};
always @ (*) begin
  gnt = 0;
  if( active_req ) begin
    for(allowed=0, index=0; index<2*CLIENTS; index=index+1) begin
      if( start_array[index] == 1 ) begin
        allowed = 1;
      end
      if( (allowed == 1) && (req[index] == 1) ) begin
        allowed = 0;
        gnt[index%CLIENTS] = 1;
      end
    end
  end
end

always @ (posedge clk) begin
  if( reset ) begin
    previous_winner <= #0 1;
  end
  else begin
    if( active_req ) begin
      previous_winner <= #0 gnt;
    end
  end
end

endmodule
