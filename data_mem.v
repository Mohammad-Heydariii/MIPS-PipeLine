module data_mem (adr, d_in, mrd, mwr, clk, d_out);
  input [31:0] adr;
  input [31:0] d_in;
  input mrd, mwr, clk;
  output [31:0] d_out;
  
  reg [7:0] mem[0:65535];
  
  initial
  begin
 
 $readmemb("data.txt",mem,1000);
  end
  
  
  // The following initial block is for TEST PURPOSE ONLY 
  initial begin
    #3500 $display("The content of mem[2000] = %d", $signed({mem[2003], mem[2002], mem[2001], mem[2000]}));
    $display("The content of mem[2004] = %d", {mem[2007], mem[2006], mem[2005], mem[2004]});
  end 
  
  
  always @(posedge clk)
    if (mwr==1'b1)
      {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} = d_in;
  
  assign d_out = (mrd==1'b1) ? {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} : 32'd0;
  
endmodule   
