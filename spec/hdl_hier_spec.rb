require 'spec_helper'

module VerilogGen
  class Leaf1 < HdlModule
    (0..5).each do |i|
      add_port("port#{i}")
    end
  end
  class Leaf2 < HdlModule; 
    (6..10).each do |i|
      add_port("port#{i}")
    end
  end

  class Leaf3 < HdlModule
    @ports = Leaf2.ports.clone
    (11..16).each do |i|
      add_port("port#{i}")
    end
  end

  describe HdlModule do
   it "should have unique ports on leaf1" do
    expect(Leaf1.ports.size).to eq(6)
   end
   it "should have unique ports on leaf2" do
    expect(Leaf2.ports.size).to eq(5)
   end
   it "should have copied ports on leaf3" do
    expect(Leaf3.ports.size).to eq(11)
   end
   
   
  end
end
  
