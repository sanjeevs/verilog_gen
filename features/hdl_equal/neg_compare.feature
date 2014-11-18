Feature: Leaf module with different direction mismcompare 

  Scenario: when expect file is same as input file
  Given a file named "leaf1.rb" with: 
  """
  class Leaf1
  end
  """
  And a file named "leaf2.rb" with: 
  """
  class Leaf2
  end
  """
  When I run `hdl_equal leaf1.rb leaf2.rb `
  Then the exit status should be 0
