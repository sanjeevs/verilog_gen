Feature: Hello World

  Scenario: print banner
  When I run `hdl_equal`
  Then it should fail with:
  """
  error: you must specify 2 ruby hdl modules to compare.

  """
