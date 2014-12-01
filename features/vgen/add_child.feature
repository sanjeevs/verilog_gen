Feature: Add a leaf node.

  Scenario: No ports in leaf 
  Given a file named "node.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_module_name  "leaf_module"
    set_proxy true 
  end
  class Node1 < VerilogGen::HdlModule
    set_module_name  "node1_module"
    add_port "in", direction: "input", packed: "[3:0]", type: "wire"
    add_port "out", direction: "output", packed: "[2:0]",type: "reg"
    add_child_instance "leaf", Leaf
  end
  """
  When I run `vgen -t Node1 node.rb`
  Then a file named "node1_module.v" should exist 
  And a file named "leaf_module.v" should not exist 
  
  Scenario: Ports in leaf 
  Given a file named "node.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_module_name  "leaf_module"
    set_proxy true 
    add_port "in", direction: "input", packed: "[3:0]", type: "wire"
    add_port "out", direction: "output", packed: "[2:0]",type: "reg"
  end
  class Node1 < VerilogGen::HdlModule
    set_module_name  "node1_module"
    add_port "in", direction: "input", packed: "[3:0]", type: "wire"
    add_port "out", direction: "output", packed: "[2:0]",type: "reg"
    add_child_instance "leaf", Leaf
  end
  """
  When I run `vgen -t Node1 node.rb`
  Then a file named "node1_module.v" should exist 
  And a file named "leaf_module.v" should not exist 
  
  Scenario: Multiple leaves 
  Given a file named "node.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_module_name  "leaf_module"
    set_proxy true 
    add_port "in", direction: "input", packed: "[3:0]", type: "wire"
    add_port "out", direction: "output", packed: "[2:0]",type: "reg"
  end
  class Node1 < VerilogGen::HdlModule
    set_module_name  "node1_module"
    add_port "in", direction: "input", packed: "[3:0]", type: "wire"
    add_port "out", direction: "output", packed: "[2:0]",type: "reg"
    add_child_instance "leaf0", Leaf
    add_child_instance "leaf1", Leaf
  end
  """
  When I run `vgen -t Node1 node.rb`
  Then a file named "node1_module.v" should exist 
  And a file named "leaf_module.v" should not exist 
