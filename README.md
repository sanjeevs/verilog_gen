# VerilogGen

Allows the user to declaratively create a verilog design. Using this tool
the user can create a logical model of the design. running the script will
render the logical view of the design. 
Then for creating different views of the design (corresponding to different
chips, technologies, ...etc) the user inherits from the logical model. It 
manipulates the logical instance hierarchy by adding/deleting/swapping the 
modules. It then calls the 'vgen' script which creates the ports of the 
modules due to the change.

To render it the script uses a default erb template. It is possible for the
user to use a custom template to insert custom system verilog logic.

Create a class HdlModule that corresponds to a verilog module. The class
HdlModule knows the ports and the instances of the design. The script vgen
can create the ports of the design by using the following  default rule.
A. if there are multiple outputs then it is a primary output whose width
  is the sum of all the busses.
B. If there is one output then it is an internal wire.
C. If there is 0 output then it is an primary input. The width of the port
  is the largest width of the input pin.
  If the user actually wanted the inputs to form a sub bus then user
  would connect the ports to the pin manually.

## Installation

Add this line to your application's Gemfile:

    gem 'verilog_gen'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install verilog_gen

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/verilog_gen/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
