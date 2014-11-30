require 'spec_helper'

# Check the syntax for accessing child instances in array. 
#
describe VerilogGen::HdlModule do
  before(:all) do
    class Leaf < VerilogGen::HdlModule
    end

    class Node < VerilogGen::HdlModule; 
      10.times do |i|
        add_child_instance "leaf#{i}", Leaf
      end
    end

  end
  it "should have the correct number of chilren" do
    expect(Node.child_instances.size).to eq(10) 
  end
  it "should support dot notation" do
    expect(Node.leaf0.instance_name).to eq("leaf0") 
  end
  it "should support loop in dot notation" do
    10.times do |i|
      expect(Node.child_instances["leaf#{i}"].instance_name).to eq("leaf#{i}") 
    end
  end

end
