Feature: Leaf module with different direction mismcompare 

  Scenario: when expect file is same as input file
  Given a file named "leaf1.rb" with: 
  """
  class Leaf1 < HdlModule
    def build 
      add_port "out", width: 10, direction: "output"
    end
  end
  """
  And a file named "leaf2.rb" with: 
  """
  class Leaf2 < HdlModule
    def build
      # Port direction is changed to input. 
      add_port "out", width: 10, direction: "input"
    end
  end
  """
  When I run `hdl_equal leaf1.rb leaf2.rb `
  Then the exit status should be 1
