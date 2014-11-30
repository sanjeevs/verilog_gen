Feature: Hello World

  Scenario: print banner
  When I run `vgen`
  Then it should fail with:
  """
  error: you must supply the top level class name.

  """
