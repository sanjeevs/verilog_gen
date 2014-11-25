Slide What is it ?
-------------------
* A DSL (Domain Specific Language) for RTL designers to compose RTL designs.
* Being presented in DVCon 2015.
* Clean slate design.
* Implemented as Ruby scripts. (Ruby Gem).
* Ruby is a popular open source object oriented scripting language.

Slide Reason 
-------------
* Limitation of verilog language for design.
    + modules are statically allocated. No OOP.
    + Very tedious to construct the connectivity. 
    + Features like interfaces halk baked and dubious support.
* Various preprocessing scripts (Perl/Emacs) written as workaround.
    + Produce spagetti verilog code with ifdef 
* Hard to maintain and so poor reuse.

Slide Our Inspiration
----------------------
MVC design pattern
* Model : Leaf Verilog modules.
* View  : Various implementation of the module
    + generic view: 
    + chipX view:
    + emulation view
    + fpga view
* Controller
Build scripts in Ruby that compose the above views.

Slide Advantages 
---------------------
* Do not *pollute* the RTL design(model) with details related to implementation(views).
* Keep implementation specific details in separate files and compose the final design.
* Allow code reuse.

Slide Basic Flow
------------------
Our basic flow is
* RTL designers writes the design as generic Leaf modules.
* Use the toolkit to create ruby objects for each of the leaf module.
* Designer composes the design using ruby scripts.
* Use the toolkit to create the output RTL design.

Slide Toolkit
---------------
Our toolkit is composed of 2 scripts.
* vscan:(Verilog->Ruby) Scans the leaf module and creates the ruby proxy class.
* vgen: (Ruby->Verilog) Loads the ruby design and writes out verilog design.
* Intuitive api for creating build scripts
    + add_child_instance "a.b.c", Fifo #Add an instance of Fifo at path a.b.c
    + a.b.c.clk.connect "sclk"         #Connect port 'clk' of a.b.c to pin 'sclk'
     
Slide Demo
-----------
