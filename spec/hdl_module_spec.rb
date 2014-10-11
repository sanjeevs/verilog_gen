require 'spec_helper'

module VerilogGen

  describe HdlModule do
    let(:hdl_module) { HdlModule.new("hdl1") }
    let(:port1) { Port.new("port1") }
    let(:child1) { HdlModule.new("child1") }

    it { hdl_module.name == "hdl1" }

    describe "add a port" do
      before { hdl_module.add(port1) }
      it "should get it back" do
        expect(hdl_module.ports["port1"]).to eql(port1)
      end
      it "should not be a duplicate" do
        expect{hdl_module.add(port1)}.to raise_error(ArgumentError)
      end
      describe "add a second one" do
        let(:port2) { Port.new("port2") }
        before { hdl_module.add(port2) }
        it "should get first back" do
          expect(hdl_module.ports["port1"]).to eql(port1)
        end
        it "should get second back" do
          expect(hdl_module.ports["port2"]).to eql(port2)
        end
      end  
    end

    describe "add a hdl module" do
      before { hdl_module.add(child1) }
      it "should get it back" do
        expect(hdl_module.child_instances[child1.name]).to eql(child1)
      end
      it "should not be a duplicate" do
        expect{hdl_module.add(child1)}.to raise_error(ArgumentError)
      end
    end

  end
end
