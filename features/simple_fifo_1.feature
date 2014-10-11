Feature: Create a simple fifo.

  Scenario: Create a logical view
  Given a file named "cntlr.rb" with: 
  """
  class Cntlr < HdlModule
    def build
      add_port Port.new("rst")
      add_port Port.new("clk")
      add_port Port.new("push", direction: "input")
      add_port Port.new("wen", direction: "output")
    end
  end
  """
  And a file named "memory.rb" with:
  """
  class Memory < HdlModule
    def build
      add_port Port.new("rst")
      add_port Port.new("clk")
      add_port Port.new("write_enable")
    end
  end
  """
  And a file named "fifo.rb" with:
  """
  class Fifo < HdlModule
    def build
       add_instance Cntlr, "cntlr1"
       add_instance Memory, "memory1"
    end

    def connect
       #Create the pin
       connect cntlr1.wen, "write_enable" 
    end
  end
  """

  When I run `vgen fifo.rb memory.rb fifo.rb `
  Then the file "fifo.v" should contain:
    """

      module fifo(rst, clk, push);
      input rst;
      input clk;
      input push;

      wire rst;
      wire clk;

      Cntlr cntlr1(.rst(rst),
                   .clk(clk),
                   .wen(write_enable));

      Memory memory1(.rst(rst),
                     .clk(clk),
                     .write_enable(write_enable));

      endmodule
    """
