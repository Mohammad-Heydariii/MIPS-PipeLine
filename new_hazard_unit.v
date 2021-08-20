module new_hazard_unit(opcode, ID_EX_rd, EX_MEM_rd, IF_ID_rs, IF_ID_rt, ID_EX_memread, EX_MEM_memread, h1_pce, IF_ID_en, ID_flush, apply);
 input[4:0] ID_EX_rd, EX_MEM_rd, IF_ID_rs, IF_ID_rt;
 input[5:0] opcode;
 input ID_EX_memread, EX_MEM_memread;
 output reg h1_pce, IF_ID_en, ID_flush, apply;
  
  always@(opcode, ID_EX_rd, EX_MEM_rd, IF_ID_rs, IF_ID_rt, ID_EX_memread, EX_MEM_memread)
  begin
    {h1_pce, IF_ID_en, ID_flush, apply} = 4'b1101;
    if(opcode == 6'b000100)begin
     if(ID_EX_memread == 1 && (IF_ID_rs == ID_EX_rd || IF_ID_rt == ID_EX_rd) && ID_EX_rd != 5'b0)
        begin
          h1_pce = 1'b0;
          IF_ID_en = 1'b0;
          ID_flush = 1'b1;
          apply = 1'b0;
        end
      else if(EX_MEM_memread == 1 && (IF_ID_rs == EX_MEM_rd || IF_ID_rt == EX_MEM_rd) && EX_MEM_rd != 5'b0)
        begin
          h1_pce = 1'b0;
          IF_ID_en = 1'b0;
          ID_flush = 1'b1;
          apply = 1'b0;
        end
    end
  end

endmodule