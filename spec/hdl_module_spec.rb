require 'spec_helper'

module VerilogGen
  class Leaf < HdlModule
    def initialize(instance_name)
      super
      add_port("port1")
     end
  end
  class Leaf2 < HdlModule; 
    def initialize(instance_name)
      super
      add_instance(Leaf, "leaf1")
    end
  end

  describe HdlModule do
    
    let(:leaf1) { Leaf.new("leaf1") }
    let(:port1) { Port.new("port1") }
    let(:leaf2) { Leaf2.new("leaf2") }

    it "should have correct instance name" do
      leaf1.instance_name == "leaf1" 
    end

    it "should have correct module name" do
      leaf1.module_name == "Leaf" 
    end

    it "should have port1" do
      leaf1.ports["port1"] = port1
    end

    describe "#equal" do
      let(:leaf_same) { Leaf.new("leaf2") }
      it "should not match instance name" do
        expect(leaf1).to eq(leaf_same)
      end
    end
    it "should not match another dervied class" do
      expect(leaf1).not_to eq leaf2
    end

    it "should flag duplicate ports" do
      expect { leaf1.add_port("port1") }.to raise_exception
    end

    it "should allow adding new port" do
      expect { leaf1.add_port("port2") }.to change {leaf1.ports.size}.from(1).to(2) 
    end
    
    it "should flag duplicate child instance" do
      expect { leaf2.add_instance(Leaf, "leaf1") }.to raise_exception
    end

    it "should allow different child instance" do
      expect { leaf2.add_instance(Leaf, "leaf1_2") }.to change {leaf2.child_instances.size}.from(1).to(2)
    end
    
  end
end
