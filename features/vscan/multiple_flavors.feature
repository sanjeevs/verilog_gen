Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: Parameterized ports, with class override into multiple flavors
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
       parameter DEPTH = 7,
                 WIDTH = 128 )
  (
    input  [IN1_MSB:IN1_LSB]   in1,
    input  [IN2_MSB:IN2_LSB]   in2,
    output [OUT1_MSB:OUT1_LSB] out1,
    output [OUT2_MSB:OUT2_LSB] out2
  );
  endmodule
  """
  And a file named "expect_wide.rb" with:
  """
  class Leaf_wide < VerilogGen::HdlModule
    set_proxy  true
    set_file_name  "leaf.v"
    set_module_name "leaf"

    set_parameter OUT2_MSB: 10
    set_parameter OUT2_LSB:  5
    set_parameter WIDTH:  256

    add_port "in1", direction: "input", packed: "[5:3]", type: "wire"
    add_port "in2", direction: "input", packed: "[7:0]", type: "wire"
    add_port "out1", direction: "output", packed: "[31:0]", type: "wire"
    add_port "out2", direction: "output", packed: "[10:5]", type: "wire"
  end
  """
  And a file named "expect_narrow.rb" with:
  """
  class Leaf_narrow < VerilogGen::HdlModule
    set_proxy  true
    set_file_name  "leaf.v"
    set_module_name  "leaf"
    set_parameter OUT1_MSB: 4
    set_parameter OUT1_LSB: 2
    set_parameter WIDTH: 32
    add_port "in1", direction: "input", packed: "[5:3]", type: "wire"
    add_port "in2", direction: "input", packed: "[7:0]", type: "wire"
    add_port "out1", direction: "output", packed: "[4:2]", type: "wire"
    add_port "out2", direction: "output", packed: "[8:3]", type: "wire"
  end
  """
  When I run `csh -c '../../bin/vscan OUT2_MSB=10 OUT2_LSB=5 WIDTH=256 -class leaf_wide leaf.v > leaf_wide.rb'`
  And I run `csh -c '../../bin/vscan OUT1_MSB=4 OUT1_LSB=2 WIDTH=32 -class leaf_narrow leaf.v > leaf_narrow.rb'`
  Then a file named "leaf_wide.rb" should exist 
  And a file named "leaf_narrow.rb" should exist 
  When I run `hdl_equal expect_wide.rb leaf_wide.rb`
  Then the exit status should be 0
  When I run `hdl_equal expect_narrow.rb leaf_narrow.rb`
  Then the exit status should be 0
