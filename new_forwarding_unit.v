module new_forwarding_unit (IF_ID_rs, IF_ID_rt, ID_EX_reg_write, ID_EX_rd, EX_MEM_rd, EX_MEM_reg_write, MEM_WB_rd, MEM_WB_reg_write, forward3, forward4);
  
  input[4:0] IF_ID_rs, IF_ID_rt, ID_EX_rd, EX_MEM_rd, MEM_WB_rd;
  input ID_EX_reg_write, EX_MEM_reg_write, MEM_WB_reg_write;
  output reg[1:0] forward3, forward4;
  
  always@(IF_ID_rs, ID_EX_reg_write, ID_EX_rd, EX_MEM_rd, EX_MEM_reg_write, MEM_WB_rd, MEM_WB_reg_write)
  begin
    forward3 = 2'b0;
    if(ID_EX_reg_write == 1'b1 && IF_ID_rs == ID_EX_rd && ID_EX_rd != 5'b0)
      forward3 = 2'b01;
    else if(EX_MEM_reg_write == 1'b1 && IF_ID_rs == EX_MEM_rd && EX_MEM_rd != 5'b0)
      forward3 = 2'b10;
    else if(MEM_WB_reg_write == 1'b1 && IF_ID_rs == MEM_WB_rd && MEM_WB_rd != 5'b0)
      forward3 = 2'b11;
  end
    
  always@(IF_ID_rt, ID_EX_reg_write, ID_EX_rd, EX_MEM_rd, EX_MEM_reg_write, MEM_WB_rd, MEM_WB_reg_write)
  begin
    forward4 = 2'b0;
    if(ID_EX_reg_write == 1'b1 && IF_ID_rt == ID_EX_rd && ID_EX_rd != 5'b0)
      forward4 = 2'b01;
    else if(EX_MEM_reg_write == 1'b1 && IF_ID_rt == EX_MEM_rd && EX_MEM_rd != 5'b0)
      forward4 = 2'b10;
    else if(MEM_WB_reg_write == 1'b1 && IF_ID_rt == MEM_WB_rd && MEM_WB_rd != 5'b0)
      forward4 = 2'b11;
  end
      
endmodule

