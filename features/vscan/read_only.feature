Feature: Check that output file can be written

  Scenario: Read only directory error
  Given a file named "subdir1/leaf.v" with: 
  """
  module leaf(in, out);
    input in;
    output out;
  endmodule
  """
  And a directory named "subdir1" with mode "0555"
  When I run `vscan subdir1/leaf.v`
  Then it should fail with:
  """
  error: can't write file subdir1/leaf.rb: Permission denied
  """
