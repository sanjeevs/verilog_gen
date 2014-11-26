Slide A Huge Problem ?
------------------------
* Verilog RTL design is hard to reuse.
    + modules are statically allocated. No OOP.
> The greatest problem with verilog design is that modules are statically allocated.
> Not possible to dynamically instantiate/replace them.
> No Object Oriented Programming.
    + Very tedious to construct the connectivity.
> Arcane syntax for connecting the ports together.
    + New features like interface are half baked. 
> Waiting for verilog language to evolve is not practical.

Slide Existing Solutions 
------------------------
* Various preprocessing scripts (Perl/Emacs) written as workaround.
* Bad *code* alert. 
    + Produce spagetti verilog code with scattered if/else 
    + Create artifical level of hierarchy.

Slide MVC Design Framework
-------------------
* Model View Controller Design Framework  
> A framework to allow RTL designers to build reusable hardware blocks.

* Clean slate design.
> For this discussion we are focussing on new designs. Not concerned with existing 
blocks and methodolgies.

Slide Our Inspiration
----------------------
* MVC design pattern.
> MVC is the de facto design pattern for separating out different concerns. 
  Do not *pollute* the RTL design(model) with details related to implementation(views).

* Model : Leaf Verilog modules.
* View  : Design
    Various types/implementation of design.
    + generic view: 
    + chipX view:
    + emulation view
    + fpga view
* Controller Build scripts written by RTL designer.

  How do we apply MVC for solving our problem ?
  + We view the leaf verilog modules as the **model**. 
  + The design is the **view** composed from the models.
      Like different views, we have different designs or implementations.
  + The **controller** is the build script that creates the designs.  

Slide Build Scripts 
---------------------
* Build scripts are written in Ruby.
> Ruby is an open source popular scripting language.

* Have a full fledged OOP language for creating the design.
    + Inheritance, duck typing
    + Can use regular expressions, hashes, arrays.
    + pattern matching
* Can algorthmically
    + Add/Del/Replace instances of the design.
    + Query the ports
    + create connectivity.
 * Examples
    + Emulation version is same as generic version except for *memory cells*.
    + ChipA version is identical to ChipX except for new bist logic.

Slide Intuitive Verilog API 
-----------------------------
* Provide intuitive api for creating verilog 
    + add_child_instance "a.b.c", Fifo #Add an instance of Fifo at "a.b.c"
    + a.**.c.clk.connect "sclk"        #Find instance 'c' any level below 'a'.
                                       #Connect its port clk to pin sclk.
     
Slide Demo
-------------
**Check demo.md in the same directory **
