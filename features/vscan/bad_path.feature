Feature: Bad Path

  Scenario: print banner
  When I run `csh -c '../../bin/vscan does_not_exist.v > leaf.rb'`
  Then it should fail with:
  """
  error: file does_not_exist.v does not exist.

  """
