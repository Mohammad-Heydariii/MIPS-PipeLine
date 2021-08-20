module reg_74b (d_in, sclr, ld, clk, d_out);
  input [73:0] d_in;
  input sclr, ld, clk;
  output reg[73:0] d_out;
 
  always @(posedge clk)
  begin
    if (sclr==1'b1)
      d_out = 74'd0;
    else if (ld)
      d_out = d_in;
  end
  
endmodule

