Feature: Leaf module are same

  Scenario: when expect file is same as input file
  Given a file named "leaf.rb" with: 
  """
  class Leaf < VerilogGen::HdlModule
    add_port("port1")
  end
  """
  When I run `hdl_equal leaf.rb leaf.rb `
  Then the exit status should be 0
