Slide What is it ?
-------------------
* A DSL (Domain Specific Language) for RTL designers to compose RTL designs.
> A domain specific language is a customized language for a particular task.
For example Makefile, Regular expressions are all examples for DSL.

* Being presented in DVCon 2015 (March 2015).
> The details will be part of the proceedings.

* Clean slate design.
> For this discussion we are focussing on new designs. Not concerned with existing 
blocks and methodolgies.

* DSL is 100% Ruby.
> We actually did not create a new language. Leveraged Ruby.
  Ruby is a popular open source object oriented scripting language.
  Not required to know Ruby. Though little bit helps.

Slide A Huge Problem ?
------------------------
* Limitation of verilog language for design.
    + modules are statically allocated. No OOP.
> The greatest problem with verilog design is that modules are statically allocated.
  Not possible to dynamically instantiate/replace them.
  No Object Oriented Programming.

    + Very tedious to construct the connectivity.
> Arcane syntax for connecting the ports together.
  New features like interface are half baked. 

* Various preprocessing scripts (Perl/Emacs) written as workaround.
    + Produce spagetti verilog code with ifdef 

* Hard to maintain and so poor reuse.
> This is **HUGE** problem. RTL code is our crown jewels. Want to maximize reuse. 

Slide Our Inspiration
----------------------
MVC design pattern
* Model : Leaf Verilog modules.
* View  : Design
    Various types/implementation of design.
    + generic view: 
    + chipX view:
    + emulation view
    + fpga view
* Controller Build scripts written by RTL designer.

> MVC is the de facto design pattern for separating out different concerns. 
  We are going to use it for solving our problem.
  + We view the leaf verilog modules as the *model*. 
  + The *design* is the view composed from the models.
      Like different views, we have different design or implementations.
  + The *controller* is the ruby scripts that creates the design.  

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
    + add_child_instance "a.b.c", Fifo #Add an instance of Fifo at "a.b.c"
    + a.**.c.clk.connect "sclk"        #Find instance 'c' any level below 'a'.
                                       #Connect its port clk to pin sclk.
     
Slide Demo
-------------
**Check demo.md in the same directory **
