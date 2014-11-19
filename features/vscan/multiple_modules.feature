Feature: Check that module name and file name match

  Scenario: Mismatched names
  Given a file named "leaf.v" with: 
  """
  module mod_a (
    input  in_a,
    output out_a
  );
  mod_c mod_c (
    .in  ( in_a  ),
    .out ( out_a ),
  );
  endmodule

  module mod_b (
    input  in_b,
    output out_b
  );
  mod_c mod_c (
    .in  ( in_b  ),
    .out ( out_b ),
  );
  endmodule

  module mod_c (
    input  in,
    output out
  );
  assign out = in;
  endmodule

  """
  And a file named "expect.rb" with:
  """
  class Mod_a < HdlModule
    def initialize
      proxy = true
      file_name = "leaf.v"
      module_name = "mod_a"
      add_port "in_a", direction: "input", type: "wire"
      add_port "out_a", direction: "output", type: "wire"
    end
  end
  class Mod_b < HdlModule
    def initialize
      proxy = true
      file_name = "leaf.v"
      module_name = "mod_b"
      add_port "in_b", direction: "input", type: "wire"
      add_port "out_b", direction: "output", type: "wire"
    end
  end
  class Mod_c < HdlModule
    def initialize
      proxy = true
      file_name = "leaf.v"
      module_name = "mod_c"
      add_port "in_c", direction: "input", type: "wire"
      add_port "out_c", direction: "output", type: "wire"
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
