Feature: Hello World

  Scenario: print banner
  When I run `vscan -class trunk PARAM1=20 leaf.v fail_arg`
  Then it should fail with:
  """
  error: too many command line arguments.

  """
