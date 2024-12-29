`include "frame_item.sv"
class generator;
  
  //declare transaction class 
   transaction trans;
   frame_item frame_i;
  
  //repeat count, to indicate number of items to generate
  int  repeat_count;
  int test_number ;
  
  //declare mailbox, to send the packet to the driver
  mailbox gen2drv;
  
  //declare event, to indicate the end of transaction generation
  event ended;
  
  //constructor
  function new(mailbox gen2drv);
    frame_i = new();
    //get the mailbox handle from env, in order to share the transaction packet 
    //between the generator and the driver the same mailbox is shared between both.
    this.gen2drv = gen2drv;
    
  endfunction
  
  //main task, generates (create and randomizes) the repeat_count 
  //number of transaction packets and puts them into the mailbox
  task main();
    
    repeat(repeat_count) begin
      
      if(test_number ==0 ) begin
      if( !frame_i.randomize() ) $fatal("Gen:: frame_i randomization failed");
      frame_i.display("[ --Frame_i-- ]");
      end 
      
      else if(test_number == 1)begin 
        $display("feras is done") ;
      
      end
           
	  trans = new();
	  trans.rx_data = frame_i.header_lsb;
	  gen2drv.put(trans);
      
  //    $display("genrator lsb %h", trans.rx_data);
      
	  trans = new();  
	  trans.rx_data = frame_i.header_msb;
 //     $display("genrator msb %h", trans.rx_data);
	  gen2drv.put(trans); 
	  
	  foreach(frame_i.payload[i]) begin
      trans = new();  
	  trans.rx_data = frame_i.payload[i];
	  gen2drv.put(trans);
	  end    
    end
    -> ended; //trigger end of generation

  endtask
  
endclass
