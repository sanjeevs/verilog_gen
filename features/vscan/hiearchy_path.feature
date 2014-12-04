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
  class Leaf < VerilogGen::HdlModule
    set_proxy true
    set_file_name "leaf.v"
    set_module_name "leaf"
    add_port "in", direction: "input", type: "wire"
    add_port "out", direction: "output", type: "wire"
  end
  """
  When I run `csh -c '../../bin/vscan subdir1/subdir2/leaf.v > subdir1/subdir2/leaf.rb'`
  Then a file named "subdir1/subdir2/leaf.rb" should exist 
  When I run `hdl_equal expect.rb subdir1/subdir2/leaf.rb`
  Then the exit status should be 0
