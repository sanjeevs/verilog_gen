Feature: Hello World

  Scenario: print banner
  When I run `vgen`
  Then it should fail with:
  """
  error: you must supply a list of hdl modules in ruby format

  """
