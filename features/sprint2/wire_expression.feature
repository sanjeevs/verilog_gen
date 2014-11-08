Feature: Invert the output pin and connect to input pin.

  Scenario: Invert output 
  Given a file named "producer.rb" with: 
  """
  class Producer < HdlModule
    def build
      add_port "out1", width: 10, direction: "output"
    end
  end
  """
  And a file named "consumer.rb" with: 
  """
  class Consumer < HdlModule
    def build
      add_port "in1", width: 10, direction: "input"
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build
       add_instance Producer, "producer"
       add_instance Consumer, "consumer"
       producer.out1.connect "data"
       add_instance InvGate, output: "data_inv", input: "data"
       consumer.in1.connect "data_inv"
    end

  end
  """
  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut;
      
      wire[9:0] data;

      producer producer(.out1(data));
      assign data_inv = ~data;
      consumer consumer(.in1(data_inv));

      endmodule
    """

