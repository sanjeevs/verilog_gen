require 'spec_helper'

module VerilogGen

  describe Port do
    let(:port) { Port.new("in1") }

    it "should have correct name" do
      expect(port.name).to eql "in1"
    end

    it "should be input by default" do
      expect(port.direction).to eql :input
    end

    it "should be single bit by default" do
      expect(port.width).to eql 1 
    end

    describe "equal" do
      let(:same_port) { Port.new("in1") }
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
      let(:diff_port) { Port.new("in2") }
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
      let(:port) { Port.new("port", width: 10, direction: :output) }
      it "should have the correct width" do
        expect(port.width).to equal(10)
      end
      it "should have the correct direction" do
        expect(port.direction).to equal(:output)
      end
    end

  end
end
