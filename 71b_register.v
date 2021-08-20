module reg_71b (d_in, sclr, ld, clk, d_out);
  input [70:0] d_in;
  input sclr, ld, clk;
  output reg[70:0] d_out;
 
  always @(posedge clk)
  begin
    if (sclr==1'b1)
      d_out = 71'd0;
    else if (ld)
      d_out = d_in;
  end
  
endmodule

