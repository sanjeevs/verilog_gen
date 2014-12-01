Feature: Hookup a tall thin tree

  Scenario: Single port
  Given a file named "node.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_proxy true 
    add_port "clk"
  end
  class Node1 < VerilogGen::HdlModule
    add_child_instance "leaf", Leaf
  end
  class Node2 < VerilogGen::HdlModule
    add_child_instance "node1", Node1 
  end

  """
  When I run `vgen -t Node2 node.rb`
  Then a file named "node1.v" should exist 
  And a file named "node2.v" should exist 
  And a file named "leaf_module.v" should not exist 
  
