Feature: Check that class name can be overridden
  Scenario: Class override
  Given a file named "leaf.v" with: 
  """
  module leaf (in, out);
    input in;
    output out;
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Trunk < VerilogGen::HdlModule
    @proxy = true
    @file_name = "leaf.v"
    @module_name = "leaf"
    add_port "in", direction: "input", type: "wire"
    add_port "out", direction: "output", type: "wire"
  end
  """
  When I run `vscan -class trunk leaf.v`
  Then a file named "trunk.rb" should exist
  When I run `hdl_equal expect.rb trunk.rb`
  Then the exit status should be 0
