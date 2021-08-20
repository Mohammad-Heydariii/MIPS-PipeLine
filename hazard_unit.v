module hazard_unit (ID_EX_rt, IF_ID_rs, IF_ID_rt, ID_EX_memread, pc_en, IF_ID_en, c_or_nop);
  input[4:0] ID_EX_rt, IF_ID_rs, IF_ID_rt;
  input ID_EX_memread;
  output reg pc_en, IF_ID_en, c_or_nop;
  
  always@(ID_EX_rt, IF_ID_rs, IF_ID_rt, ID_EX_memread)
  begin
    {pc_en, IF_ID_en, c_or_nop} = 3'b110;
    if(ID_EX_memread == 1 && (ID_EX_rt == IF_ID_rs || ID_EX_rt == IF_ID_rt))
      begin
        pc_en = 1'b0;
        IF_ID_en = 1'b0;
        c_or_nop = 1'b1;
      end
  end

endmodule
        