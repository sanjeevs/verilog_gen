// --------------------------------------------------
//
// Generic FIFO controller
//
// This module is a generic fifo controller that connects
// to an external memory.  Depth is parameterizeable.  When
// data becomes available after pop is asserted depends on
// the memory implementation details.
//
// --------------------------------------------------

module fifo_ctrl
  #( parameter  DEPTH=8,
     localparam AWIDTH=$clog2(DEPTH) )
(
  input  wire             clk,
  input  wire             reset,

  // Push interface
  output reg              full,
  input  wire             push,

  // Pop interface
  output reg              empty,
  input  wire             pop,

  // Memory interface
  output wire              mem_wr_en,
  output reg  [AWIDTH-1:0] mem_wr_addr,
  output wire              mem_rd_en,
  output reg  [AWIDTH-1:0] mem_rd_addr
);

wire              insert;
wire              delete;
reg  [AWIDTH-1:0] mem_wr_addr_next;
reg  [AWIDTH-1:0] mem_wr_addr_next;

// Internal protected push/pop logic
assign insert = push && !full;
assign delete = pop  && !empty;

// Full, empty logic (registered)
always @ (posedge clk) begin
  if( reset ) begin
    empty <= #0 1'b1;
    full  <= #0 1'b0;
  end
  else begin
    case( {delete, insert} )
      2'b01: begin
        // insert
        empty <= #0 1'b0;
        if( mem_wr_addr_next == mem_rd_addr ) begin
          full <= #0 1'b1;
        end
      end
      2'b10: begin
        // delete
        full <= #0 1'b0;
        if( mem_rd_addr_next == mem_wr_addr ) begin
          empty <= #0 1'b1;
        end
      end
      default;
    endcase
  end
end

// Memory connections
assign mem_wr_en = insert;
assign mem_rd_en = delete;
assign mem_wr_addr_next = (mem_wr_addr == (DEPTH-1)) ? {AWIDTH{1'b0}} :
                                                       mem_wr_addr + 1;
assign mem_rd_addr_next = (mem_rd_addr == (DEPTH-1)) ? {AWIDTH{1'b0}} :
                                                       mem_rd_addr + 1;
always @ (posedge clk) begin
  if( reset ) begin
    mem_wr_addr <= #0 {AWIDTH{1'b0}};
    mem_rd_addr <= #0 {AWIDTH{1'b0}};
  end
  else begin
    if( insert ) begin
      mem_wr_addr <= #0 mem_wr_addr_next;
    end

    if( delete ) begin
      mem_rd_addr <= #0 mem_rd_addr_next;
    end
  end
end

endmodule
