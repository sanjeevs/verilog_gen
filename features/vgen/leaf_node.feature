Feature: Should not output leaf nodes.

  Scenario: Leaf node
  Given a file named "leaf.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_proxy true 
  end
  class Node < VerilogGen::HdlModule
    set_proxy false 
  end
  """
  When I run `vgen -t Leaf leaf.rb`
  Then a file named "leaf_module.v" should not exist 
  And a file named "node.v" should exist 
