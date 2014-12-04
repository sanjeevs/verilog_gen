Feature: Hello World

  Scenario: print banner
  When I run `csh -c '../../bin/vscan > leaf.rb'`
  Then it should fail with:
  """
  error: you must supply a leaf verilog module.

  """
