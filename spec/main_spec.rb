require 'spec_helper'

module VerilogGen
  
  describe "CmdArgs" do
    describe "top level module" do
      let(:options) do 
        {top_module: "eval puts 'hello world'" }
      end
      it "should eval file" do
        expect(VerilogGen.
      end
      it "should work" do
        expect(VerilogGen.msg(options)).to eql("eval puts 'hello world")
      end
    end
  end
end

