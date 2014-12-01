require 'spec_helper'

module HdlTestRemove
  # Check that the child instances can be replaced

  describe VerilogGen::HdlModule do
    before(:all) do
      class Leaf < VerilogGen::HdlModule
        add_port "clk"
      end

      class Node < VerilogGen::HdlModule; 
        leaf = add_child_instance "leaf", Leaf
        # Connect port 'clk' of instance 'leaf' to net sclk
        leaf.clk.connect "sclk" 
      end

      class NewLeaf < VerilogGen::HdlModule
      end

    end

    it "should have the original hierarchy" do
      expect(Node.leaf.class.name).to eql(Leaf.name)
    end
    describe "change hier" do
      before(:all) do
        class Node < VerilogGen::HdlModule; 
          leaf = replace_child_instance "leaf", NewLeaf
        end
      end
      it "should have the new hierarchy" do
        expect(Node.leaf.class.name).to eql(NewLeaf.name)
      end
    end
  end
end
