Feature: Leaf module with different direction mismcompare 

  Scenario: when expect file has different output port
  Given a file named "leaf1.rb" with: 
  """
  class Leaf < VerilogGen::HdlModule
   add_port "in1", direction: "output" 
  end
  """
  And a file named "leaf2.rb" with: 
  """
  class Leaf < VerilogGen::HdlModule
   add_port "in1", direction: "input" 
  end
  """
  When I run `hdl_equal leaf1.rb leaf2.rb `
  Then the exit status should be 1
