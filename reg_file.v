module reg_file (wr_data, rd_reg1, rd_reg2, wr_reg, reg_write, rst, clk, rd_data1, rd_data2);
  input [31:0] wr_data;
  input [4:0] rd_reg1, rd_reg2, wr_reg;
  input reg_write, rst, clk;
  output reg[31:0] rd_data1, rd_data2;
  
  reg [31:0] register_file [0:31];
  integer i;
  
  always @(negedge clk)begin
    if (rst == 1'b1)begin
      rd_data1 <= 32'b0;
      rd_data2 <= 32'b0;
    end
    else begin
      rd_data1 <= register_file[rd_reg1];
      rd_data2 <= register_file[rd_reg2];
    end
  end
      
  
  always @(reg_write, wr_data, wr_reg)begin
    if (rst == 1'b1)
      for (i=0; i<32 ; i=i+1 )
        register_file[i] <= 32'd0;
    else if (reg_write == 1'b1)
      if(wr_reg != 5'd0)begin
        register_file[wr_reg] <= wr_data;
      end
     
    end
      
endmodule