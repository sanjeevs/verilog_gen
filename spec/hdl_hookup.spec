require 'spec_helper'

# Tests for the hookup logic,
#
describe VerilogGen::HdlModule do
  before(:all) do
    @input_port_lst = []
    10.times do |i|
      @input_port_lst << VerilogGen::Port.new(i, lhs: i, rhs: 2*i)
    end
    @output_port_lst = []
    7.times do |i|
      @output_port_lst << VerilogGen::Port.new(i, rhs: i, lhs: 2*i,
                                            direction: "output")
    end
  end
  it "should find true for input in unconnected inputs" do
    expect(VerilogGen.unconnected_input? @input_port_lst).to eq(true)
  end
  it "should compute super width of unconnected inputs" do
    expect(VerilogGen.super_port_width @input_port_lst).to eq([0, 18])
  end
  it "should find false for output unconnected inputs" do
    expect(VerilogGen.unconnected_output? @input_port_lst).to eq(false)
  end

  it "should find false for input in unconnected outputs" do
    expect(VerilogGen.unconnected_input? @output_port_lst).to eq(false)
  end
  it "should find true for output unconnected inputs" do
    expect(VerilogGen.unconnected_output? @output_port_lst).to eq(true)
  end
  it "should compute super width of unconnected outputs" do
    expect(VerilogGen.super_port_width @output_port_lst).to eq([12, 0])
  end

end
