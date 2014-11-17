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
                 OUT2_LSB = 3 )
  (
    input  [IN1_MSB-1:IN1_LSB]               in1,
    input  [IN2_MSB*2+1:IN2_LSB+1]           in2,
    output [(OUT1_MSB+1)/4-1:OUT1_LSB]       out1,
    output [(OUT2_MSB%2)+10:(2**OUT2_LSB)-1] out2
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
      add_port "in1", direction: "input", lhs: 4, rhs: 3
      add_port "in2", direction: "input", lhs: 15, rhs: 1
      add_port "out1", direction: "output", lhs: 7, rhs: 0
      add_port "out2", direction: "output", lhs: 10, rhs: 7
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
