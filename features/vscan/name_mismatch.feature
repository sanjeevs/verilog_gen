Feature: Check that module name and file name match

  Scenario: Mismatched names
  Given a file named "leaf.v" with: 
  """
  module trunk(in, out);
    input in;
    output out;
  endmodule
  """
  When I run `vscan leaf.v`
  Then it should fail with:
  """
  error: can't find module leaf in leaf.v.
  """
