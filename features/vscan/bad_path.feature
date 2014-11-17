Feature: Bad Path

  Scenario: print banner
  When I run `vscan does_not_exist.v`
  Then it should fail with:
  """
  error: file does_not_exist.v does not exist.

  """
