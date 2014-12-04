Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: Complex expressions in parameter declaration
  Given a file named "leaf.v" with: 
  """
  module leaf 
    #( parameter IN1_MSB = 5,
       parameter IN1_LSB = 3,
       parameter IN2_MSB = 7,
                 IN2_LSB = 0,
       parameter OUT1_MSB = 31,
                 OUT1_LSB = 0,
                 OUT2_MSB = 8,
                 OUT2_LSB = 3,
       parameter DEPTH = 128,
       parameter AW = $clog2(DEPTH)+3 )
  (
    input  [IN1_MSB-1:IN1_LSB]                     in1,
    input  [IN2_MSB*2+1:IN2_LSB+1]                 in2,
    output [(OUT1_MSB+1)/4-1:OUT1_LSB]             out1,
    output [(OUT2_MSB%2)+10:(2**OUT2_LSB)-1]       out2,
    output [$clog2(DEPTH):$clog2($clog2(32-2)+10)] out3,
    output [AW-1:0]                                out4
  );
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_proxy true
    set_file_name "leaf.v"
    set_module_name "leaf"

    #Default parameters donot need to be given.
    
    add_port "in1", direction: "input", packed: "[4:3]", type: "wire"
    add_port "in2", direction: "input", packed: "[15:1]", type: "wire"
    add_port "out1", direction: "output", packed: "[7:0]", type: "wire"
    add_port "out2", direction: "output", packed: "[10:7]", type: "wire"
    add_port "out3", direction: "output", packed: "[7:4]", type: "wire"
    add_port "out4", direction: "output", packed: "[9:0]", type: "wire"
  end
  """
  When I run `csh -c '../../bin/vscan leaf.v > leaf.rb'`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
