// --------------------------------------------------
//
// Generic memory
//
// This module is a generic memory with write/read enables and 
// read data is available registered (next clock cycle).  The
// Width and Depth of the memory are parameterizeable.
//
// --------------------------------------------------

module generic_mem
  #( parameter  DEPTH=8,
     parameter  WIDTH=32,
     localparam AWIDTH=$clog2(DEPTH) )
(
  input wire              clk,
  input wire              mem_wr_en,
  input wire [AWIDTH-1:0] mem_wr_addr,
  input wire [WIDTH-1:0]  mem_wr_data,
  input wire              mem_rd_en,
  input wire [AWIDTH-1:0] mem_rd_addr,
  input wire [WIDTH-1:0]  mem_rd_data
);

// The memory declaration
reg [WIDTH-1:0] generic_memory [DEPTH-1:0];

always @ (posedge clk) begin
  if( mem_wr_en ) begin
    generic_memory[mem_wr_addr] <= #0 mem_wr_data;
  end

  if( mem_rd_en ) begin
    mem_rd_data <= #0 generic_memory[mem_rd_addr];
  end
end

endmodule
