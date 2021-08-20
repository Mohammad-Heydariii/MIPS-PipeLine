module datapath ( clk, rst, control_signals, pc_en, c_or_nop, IF_ID_en, IF_flush, ID_flush, pc_src,
                  jump, ID_EX_memread, EX_MEM_memread, ID_EX_rd, IF_ID_rs, IF_ID_rt, ID_EX_rs,
                  ID_EX_rt, EX_MEM_rd,ID_EX_reg_write, EX_MEM_reg_write, MEM_WB_reg_write,MEM_WB_rd,
                  forwarda, forwardb, forwardc, forwardd, mem_read, mem_write, are_equal, zero, inst_adr, data_adr,
                  data_out, inst, data_in, opcode, func);
                   
  input clk, rst;
  input pc_en, c_or_nop, IF_ID_en, IF_flush, ID_flush, pc_src;
  input[1:0] jump, forwarda, forwardb, forwardc, forwardd;
  input[8:0] control_signals;
  input[31:0] inst, data_in;
 
  output are_equal, zero, ID_EX_memread, EX_MEM_memread, ID_EX_reg_write, EX_MEM_reg_write, MEM_WB_reg_write, mem_read, mem_write;
  output[5:0] opcode, func;
  output[4:0] ID_EX_rs, ID_EX_rt, ID_EX_rd, IF_ID_rs, IF_ID_rt, EX_MEM_rd, MEM_WB_rd;
  output[31:0] inst_adr, data_adr, data_out;
  
 
  wire[31:0] mux1_out;
  wire[31:0] mux2_out;
  wire[8:0] mux3_out;
  wire[31:0] mux4_out;
  wire[31:0] mux5_out;
  wire[31:0] mux5_0_out;
  wire[4:0]  mux6_out;
  wire[31:0] mux7_out;
  wire[31:0] mux8_out;
  wire[31:0] mux9_out;
  
  wire[63:0] IF_ID_out; 
  wire[119:0] ID_EX_out;
  wire[73:0] EX_MEM_out;
  wire[70:0] MEM_WB_out;
    
  wire[31:0] pc_out;
  wire[31:0] read_data1, read_data2;
  wire[31:0] adder1_out, adder2_out, alu_out;
  
  wire[31:0] sgn_ext_out;
  wire[31:0] shl2_32_out;
  wire[27:0] shl2_26_out;
  wire cout;

  /////IF
  
      reg_32b PC(
                 .d_in(mux1_out), 
                 .sclr(rst), 
                 .ld(pc_en), 
                 .clk(clk), 
                 .d_out(pc_out)
                );

     adder_32b ADDER_1(
                 .a(pc_out),
                 .b(32'd4),
                 .cin(1'b0),
                 .cout(cout),
                 .sum(adder1_out)
                      );
  
    reg_64b IF_ID_reg(
                 .d_in({adder1_out, inst}), 
                 .asclr((rst | IF_flush)), 
                 .ld(IF_ID_en), 
                 .clk(clk), 
                 .d_out(IF_ID_out)
);
 
   mux2to1_32b MUX1(
                 .i0(adder1_out), 
                 .i1(mux2_out), 
                 .sel(pc_src), 
                 .y(mux1_out)
                   );

  mux4to1_32b MUX2(
                 .i0(adder2_out),
                 .i1({IF_ID_out[63:60],shl2_26_out}),
                 .i2(read_data1),
                 .i3(),
                 .sel(jump),
                 .y(mux2_out)
                   );

  ////ID
  
  reg_file  RF(
                 .wr_data(mux7_out),
                 .rd_reg1(IF_ID_out[25:21]),
                 .rd_reg2(IF_ID_out[20:16]),
                 .wr_reg(MEM_WB_out[4:0]),
                 .reg_write(MEM_WB_out[69]),
                 .rst(rst),
                 .clk(clk),
                 .rd_data1(read_data1),
                 .rd_data2(read_data2)
                  );
 
  sign_ext SGN_EXT(
                 .d_in(IF_ID_out[15:0]),
                 .d_out(sgn_ext_out)
);
 
  shl2_32b SHL2_32(
                 .d_in(sgn_ext_out),
                 .d_out(shl2_32_out)
);
  
  shl2_26b SHL2_26(
                 .d_in(IF_ID_out[25:0]),
                 .d_out(shl2_26_out)
);
 
  adder_32b ADDER_2(
                 .a(IF_ID_out[63:32]),
                 .b(shl2_32_out),
                 .cin(1'b0),
                 .cout(),
                 .sum(adder2_out)
                  );

  mux2to1_9b MUX3(.i0(control_signals),.i1(9'b0),.sel(c_or_nop),.y(mux3_out)
);
 
  mux4to1_32b MUX8(
                 .i0(read_data1),
                 .i1(alu_out),
                 .i2(EX_MEM_out[68:37]),
                 .i3(mux7_out),
                 .sel(forwardc),
                 .y(mux8_out)
);


  mux4to1_32b MUX9(
                .i0(read_data2),
                .i1(alu_out),
                .i2(EX_MEM_out[68:37]),
                .i3(mux7_out),
                .sel(forwardd),
                .y(mux9_out));
 
  reg_120b ID_EX_reg(
               .d_in({mux3_out,sgn_ext_out,read_data1,read_data2,IF_ID_out[25:11]}),
               .sclr((rst | ID_flush)),
               .ld(1'b1),
               .clk(clk),
               .d_out(ID_EX_out)
);
 
  ////EX 
  
  mux4to1_32b MUX4(
               .i0(ID_EX_out[78:47]),
               .i1(EX_MEM_out[68:37]),
               .i2(mux7_out),
               .i3(),
               .sel(forwarda),
               .y(mux4_out)
);

  mux4to1_32b MUX5(
               .i0(mux5_0_out),
               .i1(EX_MEM_out[68:37]),
               .i2(mux7_out),
               .i3(),
               .sel(forwardb),
               .y(mux5_out)
);

  mux2to1_32b MUX5_0(
               .i0(ID_EX_out[46:15]),
               .i1(ID_EX_out[110:79]),
               .sel(ID_EX_out[115]),
               .y(mux5_0_out)
);

  alu ALU(
               .a(mux4_out),
               .b(mux5_out),
               .ctrl(ID_EX_out[114:112]),
               .y(alu_out),
               .zero(zero)
);

  mux2to1_5b MUX6(
               .i0(ID_EX_out[9:5]),
               .i1(ID_EX_out[4:0]),
               .sel(ID_EX_out[111]),
               .y(mux6_out)
);

  reg_74b EX_MEM_reg(
               .d_in({ID_EX_out[119:116],zero,alu_out,ID_EX_out[46:15],mux6_out}),
               .sclr(rst),
               .ld(1'b1),
               .clk(clk),
               .d_out(EX_MEM_out)
);
  
  ////MEM
  
  reg_71b MEM_WB_reg(
               .d_in({EX_MEM_out[73:72], data_in, EX_MEM_out[68:37], EX_MEM_out[4:0]}),
               .sclr(rst),
               .ld(1'b1),
               .clk(clk),
               .d_out(MEM_WB_out)
);
 
 
 ////WB
  
  mux2to1_32b MUX7(
              .i0(MEM_WB_out[68:37]),
              .i1(MEM_WB_out[36:5]),
              .sel(MEM_WB_out[70]),
              .y(mux7_out)
);


 
  assign ID_EX_reg_write = ID_EX_out[118];
  assign EX_MEM_memread = EX_MEM_out[70];
  assign MEM_WB_reg_write = MEM_WB_out[69];
  assign MEM_WB_rd = MEM_WB_out[4:0]; 
  assign mem_read = EX_MEM_out[70];
  assign mem_write = EX_MEM_out[71];
  assign opcode = IF_ID_out[31:26];
  assign func = IF_ID_out[5:0];assign EX_MEM_memread = EX_MEM_out[70];
  assign MEM_WB_reg_write = MEM_WB_out[69];
  assign MEM_WB_rd = MEM_WB_out[4:0]; 
  assign mem_read = EX_MEM_out[70];
  assign mem_write = EX_MEM_out[71];
  assign opcode = IF_ID_out[31:26];
  assign func = IF_ID_out[5:0];
  assign IF_ID_rs = IF_ID_out[25:21];
  assign IF_ID_rt = IF_ID_out[20:16];
  assign EX_MEM_rd = EX_MEM_out[4:0];
  assign EX_MEM_reg_write = EX_MEM_out[72];
  assign inst_adr = pc_out;
  assign data_adr = EX_MEM_out[68:37];
  assign data_out = EX_MEM_out[36:5];
  assign func = IF_ID_out[5:0];assign EX_MEM_memread = EX_MEM_out[70];
  assign MEM_WB_reg_write = MEM_WB_out[69];
  assign are_equal = (mux8_out == mux9_out) ? 1'b1 : 1'b0;
  assign ID_EX_memread = ID_EX_out[116];
  assign ID_EX_rs = ID_EX_out[14:10];
  assign ID_EX_rt = ID_EX_out[9:5];
  assign ID_EX_rd = mux6_out;
  
  
endmodule
