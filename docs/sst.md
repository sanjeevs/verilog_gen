Slide What is it ?
A DSL (Domain Specific Language) for RTL designers to compose RTL designs.
Implemented as Ruby scripts. (Ruby Gem).
Ruby is a popular open source object oriented scripting language.
Clean slate design.
Being presented in DVCon 2015.

Slide Reason
Existing code mixes the generic part and the implementation specific parts.
Use ifdef/perl to create different implementation version of the design.
Leads to spagetti code and poor reuse.

Slide Our Philosophy
Do not "pollute" the RTL design with details related to implementation.
Keep implementation specific details in separate files and compose the final design.
 
Slide Basic Flow
Our basic flow is
RTL designers writes the design as generic Leaf modules.
Use the toolkit to create ruby objects for each of the leaf module.
Designer composes the design using ruby scripts.
Use the toolkit to create the output RTL design.

Slide Toolkit
Our toolkit is composed of 2 scripts.
vscan:(Verilog->Ruby) Scans the leaf module and creates the ruby proxy class.
vgen: (Ruby->Verilog) Loads the ruby design and writes out verilog design.


