Feature: Check that module name and file name match

  Scenario: Mismatched names
  Given a file named "leaf.v" with: 
  """
  module trunk(in, out);
    input in;
    output out;
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Trunk < HdlModule
    def initialize
      proxy = true
      file_name = "leaf.v"
      module_name = "trunk"
      add_port "in", direction: "input", type: "wire"
      add_port "out", direction: "output", type: "wire"
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
