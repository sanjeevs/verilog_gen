Feature: Leaf module with different port width

  Scenario: when expect file has different port width
  Given a file named "leaf1.rb" with: 
  """
  class Leaf < VerilogGen::HdlModule
   add_port "in1", direction: "output", rhs: 3, lhs:5 
  end
  """
  And a file named "leaf2.rb" with: 
  """
  class Leaf < VerilogGen::HdlModule
   add_port "in1", direction: "output", rhs: 4, lhs:5 
  end
  """
  When I run `hdl_equal leaf1.rb leaf2.rb `
  Then the exit status should be 1
