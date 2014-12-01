Feature: Generate a v2k code for a node ruby.

  Scenario: Single node
  Given a file named "node.rb" with:
  """
  class Node1 < VerilogGen::HdlModule
    set_module_name  "node1_module"
    add_port "in", direction: "input", packed: "[3:0]", type: "wire"
    add_port "out", direction: "output", packed: "[2:0]",type: "reg"
  end
  class Node2 < VerilogGen::HdlModule
    set_module_name  "node2_module"
    add_port "in", direction: "input", packed: "[3:0]", type: "wire"
    add_port "out", direction: "output", packed: "[2:0]", type: "reg"
  end
  class Leaf < VerilogGen::HdlModule
    set_module_name  "leaf_module"
    set_proxy true 
  end
  """
  When I run `vgen -t Node1 node.rb`
  Then a file named "node1_module.v" should exist 
  And a file named "node2_module.v" should exist 
  And a file named "leaf_module.v" should not exist 
