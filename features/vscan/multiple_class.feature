Feature: Hello World

  Scenario: print banner
  When I run `csh -c '../../bin/vscan -class trunk -class leaf leaf.v > leaf.rb'`
  Then it should fail with:
  """
  error: you can't specify more than one class overide.

  """
