Feature: Leaf module are equivalent

  Scenario: when expect file is same as input file
  Given a file named "leaf.rb" with: 
  """
  class Leaf 
  end
  """
  When I run `hdl_equal leaf.rb leaf.rb `
  Then the exit status should be 0
