//gets the packet from the generator and drives the transaction packet items into the interface 
//the interface is connected to the DUT, so that items driven into the interface will be driven 
//into the DUT

class driver;
  
  //count the number of transactions
  int num_transactions;
  
  //create virtual interface handle
  virtual inf vinf;
  
  //create mailbox handle
  mailbox gen2drv;
  
  //constructor
  function new(virtual inf vinf, mailbox gen2drv);
    //get the interface
    this.vinf = vinf;
    //get the mailbox handle from env 
    this.gen2drv = gen2drv;
  endfunction
        
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vinf.reset);
    $display("[ --DRIVER-- ] ----- Reset Started -----");
    vinf.rx_data <= 0;

	
    wait(!vinf.reset);
    $display("[ --DRIVER-- ] ----- Reset Ended   -----");
  endtask
  
  //drives the transaction items into interface signals
  task main;
    forever begin
      transaction trans;
      @(posedge vinf.clk)begin
        gen2drv.get(trans);
//      $display("driver tran %h ",trans.rx_data);
  
	  vinf.rx_data = trans.rx_data;  
 
      trans.frame_detect = vinf.frame_detect ;
	  trans.fr_byte_position = vinf.fr_byte_position ;
      trans.display("[ --Driver-- ]");
        $display("driver %d byte postion   rx data %h ",vinf.fr_byte_position,trans.rx_data)  ;
      num_transactions++;
      
	  end
    end
  endtask
  
endclass
