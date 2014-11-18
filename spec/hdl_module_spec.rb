require 'spec_helper'

module VerilogGen
  class Leaf < HdlModule
    add_port("port1")
    @module_name = "Leaf"
  end
  class Leaf2 < HdlModule; 
    add_instance(Leaf, "leaf1")
  end

  describe HdlModule do
    
    let(:leaf1) { Leaf.new("leaf1") }
    let(:leaf1_same) { Leaf.new("leaf1") }
    let(:port1) { Port.new("port1") }
    let(:leaf2) { Leaf2.new("leaf2") }
    let(:leaf2_same) { Leaf.new("leaf2") }

    it "should have correct instance name" do
      leaf1.instance_name == "leaf1" 
    end

    it "should have correct module name" do
      Leaf.module_name == "Leaf" 
    end

    it "should have port1" do
      Leaf.ports["port1"] = port1
    end

    it "should have proxy false" do
      expect(Leaf.proxy).to eq(false)
    end

    describe "#equal" do
      it "should match instance name" do
        expect(leaf1).to eq(leaf1_same)
      end
    end
    it "should not match another dervied class" do
      expect(leaf1).not_to eq leaf2
    end

    it "should flag duplicate ports" do
      expect { Leaf.add_port("port1") }.to raise_exception
    end

    it "should allow adding new port" do
      expect { Leaf.add_port("port2") }.to change {Leaf.ports.size}.from(1).to(2) 
    end
   
    it "should return the newly added port" do
      expect(Leaf.add_port("port3")).to eq(Port.new("port3"))
    end

    it "should flag duplicate child instance" do
      expect { Leaf2.add_instance(Leaf, "leaf1") }.to raise_exception
    end

    it "should allow different child instance" do
      expect { Leaf2.add_instance(Leaf, "leaf1_2") }.to \
                      change {Leaf2.child_instances.size}.from(1).to(2)
    end
   
    describe "#hash" do
      it "should find the entry" do
        hdl_hash = {}
        hdl_hash[leaf1] = "leaf1"
        expect(hdl_hash[leaf1_same]).to eq("leaf1")
      end
      it "should not find the entry" do
        hdl_hash = {}
        hdl_hash[leaf1] = "leaf1"
        expect(hdl_hash[leaf2]).to eq(nil)
      end
    end

  end
end
