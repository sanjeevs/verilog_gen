Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: Parameters in verilog file not specified
  Given a file named "leaf.v" with: 
  """
  module leaf 
    #( parameter IN1_MSB = 5,
       parameter IN1_LSB = 3,
       parameter IN2_MSB = 7,
       parameter OUT1_MSB = 31,
                 OUT1_LSB = 0)
  (
    input  [IN1_MSB:IN1_LSB]   in1,
    input  [IN2_MSB:IN2_LSB]   in2,
    output [OUT1_MSB:OUT1_LSB] out1,
    output [OUT2_MSB:OUT2_LSB] out2
  );
  endmodule
  """
  When I run `vscan leaf.v`
  Then it should fail with:
  """
  error: I/O declaration using undefined parameter.
  """
