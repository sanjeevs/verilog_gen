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
    def build
      add_port "in1", width: 2, direction: "input"
      add_port "in2", width: 15, direction: "input"
      add_port "out1", width: 8, direction: "output"
      add_port "out2", width: 4, direction: "output"
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
