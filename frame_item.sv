class frame_item;  

  typedef enum bit [1:0] {HEAD_1, HEAD_2, ILLEGAL} header_type_t;
  
  rand header_type_t header; 
  rand bit [7:0] header_lsb;
  rand bit [7:0] header_msb;
  rand bit [7:0] payload[10];
  
  constraint header_t {
    header dist {HEAD_1 := 30, HEAD_2 := 40, ILLEGAL := 30};
  }
  
  constraint header_type {
    if (header == HEAD_1) {
      header_lsb == 8'haa;
      header_msb == 8'haf;
    } else if (header == HEAD_2) { 
      header_lsb == 8'h55;
      header_msb == 8'hba;
   } else if (header == ILLEGAL) {
    // Allow any values other than those used by HEAD_1 and HEAD_2
      header_lsb == 8'h00 ;
       header_lsb ==8'h00;
  }
  }

function void display(string name);
    $display("-------------------------");
    $display("- %s ", name);
    $display("-------------------------");
    $display("header = %h", {header_msb, header_lsb});
    
    // Display each byte in the payload array
    foreach (payload[i]) begin
        $display("payload[%0d] = %h", i, payload[i]);
    end
    $display("-------------------------");
endfunction

endclass
