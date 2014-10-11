Here, internal interconnect bus “foobar” is forced to also be a primary output; its bus size will be the same as what would have been automatically used as a wire.

 

module myfile (

output [10:0] foobar;

);

 

Foobar is forced to be a primary output at size 10:0. If foobar was already a wire, its size is overridden to 10:0.
