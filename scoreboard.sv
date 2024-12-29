//gets the packet from the monitor, generates the expected results 
//and compares with the actual results received from the monitor

class scoreboard;
   
  //create mailbox handle
  mailbox mon2scbin;
  mailbox mon2scbout;
  
  //count the number of transactions
  int num_transactions;
//////////////////////// Reference model //////////////////////////////////////////////

   reg [1:0] frame_counter_ref = 0 ;
   reg [5:0] na_byte_counter_ref = 6'h0;
   reg frame_detect_ref = 0;            // frame alignment indication
   reg [7:0] header_lsb_samp_ref,header_msb_samp_ref;
   reg [7:0] x,y;
   reg [7:0] expected_header_msb_ref;
   reg [7:0] expy ;
   reg header_msb_valid_ref , header_lsb_valid_ref , validx ,validy;

   int err =0 ;
   int corr= 0;
   int fr_byte_position_ref =0 ;
 
//////////////////////////////////////////////////////////////////
  
  //constructor
  function new(mailbox mon2scbin, mailbox mon2scbout);
    //get the mailbox handle from  environment 
    this.mon2scbin = mon2scbin;
    this.mon2scbout = mon2scbout;

  endfunction
  
  
  
  //Compare the actual results with the expected results
  task main;
    transaction trans_in;
    transaction trans_out;
    forever begin
     
	  
//********************************* header lsb and msb checking *********************************  
      mon2scbout.get(trans_out);
      mon2scbin.get(trans_in);	
      header_lsb_samp_ref = trans_in.rx_data;
      
      if(fr_byte_position_ref == 8'd10) begin
     	 fr_byte_position_ref = fr_byte_position_ref + 1;
      end
      
      mon2scbout.get(trans_out);
	  mon2scbin.get(trans_in);
              
	  header_msb_samp_ref = trans_in.rx_data;
      
      $display("fr_byte_position_ref = %d",fr_byte_position_ref );
      $display("header = %h", {header_msb_samp_ref, header_lsb_samp_ref});
      header_lsb_valid_ref = (header_lsb_samp_ref == 8'haa) || (header_lsb_samp_ref == 8'h55);
      expected_header_msb_ref = (header_lsb_samp_ref == 8'haa) ? 8'haf : ( (header_lsb_samp_ref == 8'h55) ? 8'hba : 8'h00); 
	  header_msb_valid_ref = (expected_header_msb_ref == header_msb_samp_ref);
		
// ************************************************************************************************	

// ********************************frame with correct header  **************************************************	

	if(header_lsb_valid_ref && header_msb_valid_ref) begin
      $display("***************VALID HEADER ********************************");
		frame_counter_ref = frame_counter_ref+1;
          
          
         
        mon2scbout.get(trans_out); 
		mon2scbin.get(trans_in);
        fr_byte_position_ref =(fr_byte_position_ref +1) % 11 ;          
        mon2scbout.get(trans_out);  
        fr_byte_position_ref =fr_byte_position_ref +1 ;  
		mon2scbin.get(trans_in);
        mon2scbout.get(trans_out);
        fr_byte_position_ref =fr_byte_position_ref +1 ;  
		mon2scbin.get(trans_in);
        mon2scbout.get(trans_out);
        fr_byte_position_ref =fr_byte_position_ref +1 ;  
		mon2scbin.get(trans_in);
        mon2scbout.get(trans_out);
        fr_byte_position_ref =fr_byte_position_ref +1 ;  
		mon2scbin.get(trans_in);
        mon2scbout.get(trans_out);
        fr_byte_position_ref =fr_byte_position_ref +1 ;  
		mon2scbin.get(trans_in);
        mon2scbout.get(trans_out);
        fr_byte_position_ref =fr_byte_position_ref +1 ;  
		mon2scbin.get(trans_in);
        mon2scbout.get(trans_out);
        fr_byte_position_ref =fr_byte_position_ref +1 ;  
		mon2scbin.get(trans_in);
        mon2scbout.get(trans_out);
        fr_byte_position_ref =fr_byte_position_ref +1 ;  
		mon2scbin.get(trans_in);
        mon2scbout.get(trans_out);
        fr_byte_position_ref =fr_byte_position_ref +1 ;
		mon2scbin.get(trans_in);


		if(frame_counter_ref == 2'h3)
	    frame_detect_ref = 1'b1;
          
             fr_byte_position_ref  = fr_byte_position_ref % 12;  
		end
    
         
      
//******************************** frame is not valid ,check the payload  ***************************************************		
		else begin 
		x = header_lsb_samp_ref;
		y = header_msb_samp_ref;
        frame_counter_ref = 1'b0;  
        $display("*********** NO VALID HEADER ***********************");
		fr_byte_position_ref = 0  ;
          
		for (int i = 0; i < 10; i++) begin
		validx = (x == 8'haa) || (x == 8'h55);
		expy = (x == 8'haa) ? 8'haf : ( (x == 8'h55) ? 8'hba : 8'h00); 
		validy = (expy == y);
		if(validx && validy )  /// there is a correct header in the payload
		na_byte_counter_ref =0;
		else 
		na_byte_counter_ref = na_byte_counter_ref +1'b1;
		
		mon2scbin.get(trans_in);
        mon2scbout.get(trans_out);
		x = y;
		y = trans_in.rx_data;
		end  ///for
		
			
        if(na_byte_counter_ref == 6'd47)begin 
	    frame_detect_ref = 1'b0;
		na_byte_counter_ref = 0 ;
        
		end
          
					
		end //else 73
		
////////////////////check the reffernce model with the design///////////////////	
		
		if(frame_detect_ref == trans_out.frame_detect)begin
	    	corr++;
             $display("*********** Result frame aligner is as Expected************");
			end
		else begin
		 	err++;
          $error("Wrong frame detecet Result.\n\t Expeced refrence FD : %0d Actual dut FD : 	%0d",frame_detect_ref,trans_out.frame_detect);     
			end
           
         if(fr_byte_position_ref == trans_out.fr_byte_position)begin
           corr++;
          $display("***********Result byte_position is as Expected************");
			end
		else begin
		 err++;
          $error("Wrong byte_position Result.\n\t Expeced refrence BP: %0d Actual dut BP: %0d",fr_byte_position_ref,trans_out.fr_byte_position);     
			end
           
/////////////////////////////////////////////////////////////////////////////	  
	  
	  
	  
      num_transactions++;
      trans_in.display("[ --Scoreboard_in-- ]");
      trans_out.display("[ --Scoreboard_out-- ]");
      $display("- correct  = %0d, ******** error = %0d" , corr ,err );
      
    end  //forever
  endtask
  
endclass