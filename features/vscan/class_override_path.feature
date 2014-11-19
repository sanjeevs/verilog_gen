Feature: Check that class name can be overridden

  Scenario: Class override
  Given a file named "subdir1/leaf.v" with: 
  """
  module leaf (in, out);
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
      module_name = "leaf"
      add_port "in", direction: "input", type: "wire"
      add_port "out", direction: "output", type: "wire"
    end
  end
  """
  When I run `vscan -class trunk subdir1/leaf.v`
  Then a file named "subdir1/trunk.rb" should exist
  When I run `hdl_equal expect.rb subdir1/trunk.rb`
  Then the exit status should be 0
