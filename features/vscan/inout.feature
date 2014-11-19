Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: Port list contains inout types
  Given a file named "leaf.v" with: 
  """
  module leaf (
    inout  tri_state_sig
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
      add_port "tri_state_sig", direction: "inout", type: "wire"
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
