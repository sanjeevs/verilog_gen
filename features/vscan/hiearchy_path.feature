Feature: convert a verilog 1364 format to ruby.

  Scenario: Long file path
  Given a file named "subdir1/subdir2/leaf.v" with: 
  """
  module leaf(in, out);
    input in;
    output out;
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < HdlModule
    def build
      add_port "in", width: 1, direction: "input"
      add_port "out", width: 1, direction: "output"
    end
  end
  """
  When I run `vscan subdir1/subdir2/leaf.v`
  Then a file named "subdir1/subdir2/leaf.rb" should exist 
  When I run `hdl_equal expect.rb subdir1/subdir2/leaf.rb`
  Then the exit status should be 0
