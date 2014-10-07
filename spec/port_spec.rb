require 'spec_helper'

module VerilogGen

  describe Port do
    let(:port) { Port.new("in1") }

    it "should have correct name" do
      expect(port.name).to eql "in1"
    end
  end
end
