Feature: Hello World

  Scenario: print banner
  When I run `csh -c '../../bin/vscan -class trunk PARAM1=20 leaf.v fail_arg > leaf.rb'`
  Then it should fail with:
  """
  error: too many command line arguments.

  """
