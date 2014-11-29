require 'spec_helper'

describe "Running vscan" do
 let(:leaf1) { VerilogGen.leaf("Generic_mem", 
                     file_name: "spec/fixture/generic_mem.v").new("leaf1")}

 # Specify the same class but give it a invalid file name.
 let(:leaf2) { VerilogGen.leaf("Generic_mem", file_name: "xxxx").new("leaf2") }

 let(:leaf4x64) { VerilogGen.leaf("Generic_mem_4x64", 
                     parameter: "DEPTH=4 WIDTH=64",
                     file_name: "spec/fixture/generic_mem.v").new("leaf4x64")}

 it "should be able to create the class" do
   expect(leaf1.class.name).to eql("VerilogGen::Generic_mem")
   Leaf =  VerilogGen.leaf("Generic_mem", 
                              file_name: "spec/fixture/generic_mem.v")
 
   expect(Leaf.name).to eql("VerilogGen::Generic_mem")
 end
 it "should be able to create an instance of leaf" do
   expect(leaf1.class.module_name).to eql("generic_mem")
 end

 it "should be able to flag invalid argument" do
  expect {VerilogGen.leaf("Generic_mem", 
                  invalid: "spec/fixture/generic_mem.v")}.to raise_exception
 end

 it "should skip if the class is already created" do
   expect(leaf2.class.name).to eql("VerilogGen::Generic_mem")
 end

 it "should accept parameter values" do
   expect(leaf4x64.class.module_name).to eql("generic_mem")
   expect(leaf4x64.class.parameters[:DEPTH]).to eql(4)
   expect(leaf4x64.class.parameters[:WIDTH]).to eql(64)
 end
end


