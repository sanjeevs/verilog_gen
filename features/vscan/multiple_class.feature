Feature: Hello World

  Scenario: print banner
  When I run `vscan -class trunk -class leaf leaf.v`
  Then it should fail with:
  """
  error: you can't specify more than one class overide.

  """
