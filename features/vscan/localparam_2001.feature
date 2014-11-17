Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: Parameterized ports, not externally changeable
  Given a file named "leaf.v" with: 
  """
  module leaf 
    #( localparam IN1_MSB = 5,
       localparam IN1_LSB = 3,
       localparam IN2_MSB = 7,
                  IN2_LSB = 0,
       localparam OUT1_MSB = 31,
                  OUT1_LSB = 0,
                  OUT2_MSB = 8,
                  OUT2_LSB = 3 )
  (
    input  [IN1_MSB:IN1_LSB]   in1,
    input  [IN2_MSB:IN2_LSB]   in2,
    output [OUT1_MSB:OUT1_LSB] out1,
    output [OUT2_MSB:OUT2_LSB] out2
  );
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < HdlModule
    def initialize
      proxy = true
      file_name = "leaf.v"
      module_name = "leaf"
      add_port "in1", direction: "input", lhs: 5, rhs: 3
      add_port "in2", direction: "input", lhs: 7, rhs: 0
      add_port "out1", direction: "output", lhs: 31, rhs: 0
      add_port "out2", direction: "output", lhs: 8, rhs: 3
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0