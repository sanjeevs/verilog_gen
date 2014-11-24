// --------------------------------------------------
//
// Fake implementation specific memory
//
// Sample implementation specific memory with test ports
// and 2-clock delay on output after read-enable asserted.
//
// --------------------------------------------------

module mem_16nm_proc_16x73
(
  input  wire        clk,
  input  wire        mem_wr_en,
  input  wire [3:0]  mem_wr_addr,
  input  wire [72:0] mem_wr_data,
  input  wire        mem_rd_en,
  input  wire [3:0]  mem_rd_addr,
  input  wire [72:0] mem_rd_data,

  input  wire        bist_clk,
  input  wire        bist_en,
  input  wire [3:0]  bist_addr,
  input  wire [72:0] bist_wr_data,
  output wire [72:0] bist_rd_data
);

// The memory declaration
reg [72:0] memory [15:0];
reg [72:0] mem_rd_data_i;

always @ (posedge clk) begin
  if( mem_wr_en ) begin
    memory[mem_wr_addr] <= #0 mem_wr_data;
  end

  if( mem_rd_en ) begin
    mem_rd_data_i <= #0 memory[mem_rd_addr];
  end
end

always @ (posedge clk) begin
  mem_rd_data <= #0 mem_rd_data_i;
end

// Bist fake logic
always @ (posedge bist_clk ) begin
  bist_rd_data <= #0 bist_wr_data;
end

endmodule
