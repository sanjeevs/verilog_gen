require 'spec_helper'

module VerilogGenTest

  describe VerilogGen::Port do
    let(:port) { VerilogGen::Port.new("in1") }

    it "should have correct name" do
      expect(port.name).to eql "in1"
    end

    it "should be input by default" do
      expect(port.direction).to eql "input"
    end

    it "should be single bit by default" do
      expect(port.scalar?).to eql true 
    end

    describe "equal" do
      let(:same_port) { VerilogGen::Port.new("in1") }
      it "should be equal for single bit input" do
        expect(same_port).to be == port
      end
      it "should have the same hash" do
        expect(same_port.hash).to be == port.hash
      end
      it "should be well behaved hash key" do
        hash1 = {}
        hash1[port] = "Hello"
        expect(hash1[same_port]).to equal(hash1[port])
      end 
    end

    describe "not equal" do
      let(:diff_port) { VerilogGen::Port.new("in2") }
      it "should no be equal for different name" do
        expect(diff_port).not_to equal port
      end
      it "should be well behaved hash key" do
        hash1 = {}
        hash1[port] = "Hello"
        expect(hash1[diff_port]).not_to be == (hash1[port])
      end 
    end

    describe "vector port" do
      let(:port) { VerilogGen::Port.new("port", lhs: 9, rhs: 0,  direction: "output") }
      it "should have the correct width" do
        expect(port.width).to equal(10)
      end
      it "should have the correct lhs" do
        expect(port.lhs).to equal(9)
      end
      it "should have the correct rhs" do
        expect(port.rhs).to equal(0)
      end
      it "should have the correct direction" do
        expect(port.direction).to eq("output")
      end
    end

    describe "invalid attribute" do
      it "should flag an attribute failure" do
        expect { VerilogGen::Port.new("invalid_attribute", 
                        invalid_attribute: "value") }.to raise_exception
      end
    end
  end

  describe "create" do
    before(:all) do
       @p = VerilogGen::Port.new("port", lhs: 9, rhs: 0,  type: "logic", 
                                                          direction: "output")
       @new_p = @p.create_connect_port("new_name", 43, 45)
    end
    it "should not affect the orig port" do
      expect(@p.name).to eq("port")
      expect(@p.lhs).to eq(9)
      expect(@p.rhs).to eq(0)
    end
    it "should change the cloned port" do
      expect(@new_p.name).to eq("new_name")
      expect(@new_p.lhs).to eq(43)
      expect(@new_p.rhs).to eq(45)
      expect(@new_p.type).to eq("logic")
    end
  end

end
