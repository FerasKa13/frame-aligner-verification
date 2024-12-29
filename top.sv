// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
//testbench top is the top most file, in which DUT and Verification environment are connected. 

//include interfcae 
`include "interface.sv"

//include one test at a time
`include "random_test.sv"
//`include "directed_test.sv"

module top;
  
  //clock and reset signal declaration
  bit clk;
  bit rst;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset generation
  initial begin
    rst = 1;
    #15 rst =0;
  end
  
  
  //interface instance in order to connect DUT and testcase
  inf i_inf(clk,rst);
  
  //testcase instance, interface handle is passed to test 
  rand_test t1(i_inf);
//  test_2   t2(i_inf)
  
  //DUT instance, interface handle is passed to test 
 // frame_aligner a1(.clk(i_inf.clk),i_inf.rx_data ,reset ,i_inf.fr_byte_position ,i_inf.frame_detect);
  frame_aligner a1(.clk(i_inf.clk),.rx_data(i_inf.rx_data),.reset(i_inf.reset) ,.fr_byte_position(i_inf.fr_byte_position) ,.frame_detect(i_inf.frame_detect));
  initial begin
 	$dumpfile("dump.vcd");
	$dumpvars;
  end 
  
endmodule
