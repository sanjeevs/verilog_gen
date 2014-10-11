Feature create output ports

Scenario:
When NVMAKE detects that the same wire is connected (without a [n:m or [n] ) to multiple outputs, it assumes that the user wants to connect sub-slices of a larger bus. The instances are connected to the resultant larger bus starting with bit 0 and working up, each instance is connected to enough bits to fill the width of its formal output.

 

When NVMAKE detects that the same wire is connected to multiple inputs, it assumes that the user wants to simply distribute a bus to all of them, and the width is simply the width of the formal pin on the leaf. However, a module section declaration of

 

input [*] myinput ;


will cause a larger bus to be formed, and the individual instances will be connected in instance order to smaller slices of the bus, each satisfying the formal input.

 

Auto widths is useful for connecting several leaves, each of which acts on part of a larger bus.

 

In the following example, we use 2 instances each of byte-wide leaves to make a 16-wide top level, and also connect busses between 2 stages, using automatic widths. The only re-write needed is to connect the first stage output to the second stage input.

 

module bytewide_a (

clock,

a_dat_in,

a_dat_out

) ;

 

input [7:0] a_dat_in ;

output[7:0] a_dat_out;

 

endmodule

 

 

module bytewide_b (

clock,

b_dat_in,

b_dat_out

);

 

input [7:0] b_dat_in ;

output[7:0] b_dat_out;

 

endmodule

 

File wordwide_ab.jh:

 

module wordwide_ab (

input [*] a_dat_in ;

) ;

 

bytewide_a : 2

 

bytewide_b : 2

b_dat_in a_dat_out

 

endmodule

 

The output verilog for wordwide_ab.v is shown following; note that the primary input, primary output, and connecting wire have all been automatically grown to 16 bits, and 8 bit slices have been connected as required to each leaf.

 

module wordwide_ab (

a_dat_in,

b_dat_out

);

 

input   [15 : 0]                               a_dat_in                       ; // bytewide_a

output  [15 : 0]                               b_dat_out          ; // bytewide_b

wire    [15 : 0]                               a_dat_out                    ; // bytewide_a

// bytewide_b

 

//instance

bytewide_a   bytewide_a_0   (

        .a_dat_in                                  ( a_dat_in[7:0]                          ),

        .a_dat_out                                ( a_dat_out[7:0]                       )

);

 

//instance

bytewide_a   bytewide_a_1   (

        .a_dat_in                                  ( a_dat_in[15:8]                         ),

        .a_dat_out                          ( a_dat_out[15:8]                            )

);

 

//instance

bytewide_b   bytewide_b_0   (

        .b_dat_in                        ( a_dat_out[7:0]                      ),

        .b_dat_out                      ( b_dat_out[7:0]                      )

);

 

//instance

bytewide_b   bytewide_b_1   (

        .b_dat_in                        ( a_dat_out[15:8]                     ),

        .b_dat_out                      ( b_dat_out[15:8]                     )

);

 

endmodule
