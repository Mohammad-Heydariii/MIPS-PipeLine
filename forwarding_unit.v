module forwarding_unit (ID_EX_rs, ID_EX_rt, EX_MEM_rd, MEM_WB_rd, EX_MEM_reg_write, MEM_WB_reg_write, forward1, forward2);
  
  input[4:0] ID_EX_rs, ID_EX_rt, EX_MEM_rd, MEM_WB_rd;
  input EX_MEM_reg_write, MEM_WB_reg_write;
  output reg[1:0] forward1, forward2;
  
  always@(MEM_WB_rd, ID_EX_rs, EX_MEM_rd, EX_MEM_reg_write, MEM_WB_reg_write)
  begin
    forward1 = 2'b0;
    if( EX_MEM_reg_write == 1'b1 && EX_MEM_rd == ID_EX_rs && EX_MEM_rd != 5'b0)
      forward1 = 2'b01;
    else if( MEM_WB_reg_write == 1'b1 && MEM_WB_rd == ID_EX_rs && MEM_WB_rd != 5'b0)
      forward1 = 2'b10;
  end
    
  always@(MEM_WB_rd, ID_EX_rt, EX_MEM_rd, EX_MEM_reg_write, MEM_WB_reg_write)
  begin
    forward2 = 2'b0;
    if( EX_MEM_reg_write == 1'b1 && EX_MEM_rd == ID_EX_rt && EX_MEM_rd != 5'b0)
      forward2 = 2'b01;
    else if( MEM_WB_reg_write == 1'b1 && MEM_WB_rd == ID_EX_rt && MEM_WB_rd != 5'b0)
      forward2 = 2'b10;
  end
      
endmodule
  
