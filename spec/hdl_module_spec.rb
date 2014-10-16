require 'spec_helper'

module VerilogGen

  describe HdlModule do
    let(:hdl_module) { HdlModule.new("hdl1") }
    it { hdl_module.name == "hdl1" }

    describe "add a port" do
      let(:port1) { Port.new("port1") }
      before { hdl_module.add_port "port1" }
      it "should get it back" do
        expect(hdl_module.ports["port1"]).to eql(port1)
      end
      it "should not be a duplicate" do
        expect{hdl_module.add_port("port1")}.to raise_error(ArgumentError)
      end

      describe "add a second port" do
        let(:port2) { Port.new("port2") }
        before { hdl_module.add_port "port2" }
        it "should get first back" do
          expect(hdl_module.ports["port1"]).to eql(port1)
        end
        it "should get second back" do
          expect(hdl_module.ports).to eql(port2)
        end

        it "should access port hierarically" do
          expect(hdl_module.port1).to eql(port1)
          expect(hdl_module.port2).to eql(port2)
        end
      end

    end

    describe "add a vector port" do
      before { hdl_module.add_port "port1", width: 10 }
      it { expect(hdl_module.port.width).to equal(10) }
    end

    describe "add a hdl module" do
      before do
        class Leaf < HdlModule 
        end
        hdl_module.add_instance Leaf, "child1"
      end
      it "should get it back" do
        expect(hdl_module.child_instances["child1"].name).to eql("child1")
      end

      it "should allow hier get method" do
        expect(hdl_module.child1.name).to eql("child1")
      end
    end

  end
end
