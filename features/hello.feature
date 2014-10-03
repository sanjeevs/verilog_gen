Feature: Hello World

  Scenario: print banner
  When I run `vgen`
  Then it should pass with:
  """
  Verilog Rtl Generator
  """
