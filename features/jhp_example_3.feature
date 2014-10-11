module myfile (

);


my_leaf_a :              2      foo_a(8,16)      bar_a(.depth(12),.width(2))


endmodule


NOTE—When the “named parameters” (verilog 2000 style) form is used as with bar_a above, any unspecified parameters will take on their default values. Since we are using standard verilog, the named parameter list is converted to a traditional ordered list in the output verilog file

 

 

NOTE—Each module repetition group, including the modulename, the colon, repetition count, instance name[s], and parameters must be on the same line, unless the line is extended with \.
