Feature: Should be able to specify the destination folder

  Scenario: Output directory does not exist
  Given a file named "node.rb" with:
  """
  class Node1 < VerilogGen::HdlModule
    set_proxy false 
  end
  class Node2 < VerilogGen::HdlModule
    set_proxy false 
  end
  class Node3 < VerilogGen::HdlModule
    set_proxy false 
  end
  """
  When I run `vgen -t Node1 -o out  node.rb`
  Then a file named "out/node1.v" should exist 
  And a file named "out/node2.v" should exist 
  And a file named "out/node3.v" should exist 
