Feature: Hello World

  Scenario: print banner
  When I run `vscan`
  Then it should fail with:
  """
  error: you must supply a leaf verilog module.

  """
