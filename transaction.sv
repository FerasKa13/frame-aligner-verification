class transaction;
  
  //declare the transaction fields
    bit [7:0] rx_data;//frame
	bit frame_detect;
    bit [3:0] fr_byte_position;
  
  function void display(string name);
    $display("-------------------------");
   $display("- %s ",name);
    $display("-------------------------");
	$display("- rx_data = %0d",rx_data);
    $display("- frame_detect = %d",frame_detect);
    $display("- fr_byte_position = %d",fr_byte_position);
    $display("-------------------------");
    
  endfunction 
endclass

