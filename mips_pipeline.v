module mips_pipeline (rst, clk, inst_adr, inst, data_adr, data_in, data_out, mem_read, mem_write);
  input rst, clk;
  output [31:0] inst_adr;
  input  [31:0] inst;
  output [31:0] data_adr;
  input  [31:0] data_in;
  output [31:0] data_out;
  output mem_read, mem_write;
  
  wire pc_en, c_or_nop, IF_ID_en, IF_flush, ID_flush, pc_src, ID_EX_memread, EX_MEM_memread, ID_EX_reg_write, EX_MEM_reg_write, MEM_WB_reg_write,
         are_equal, zero;
  wire[1:0] jump, forwarda, forwardb, forwardc, forwardd;
  wire[4:0] ID_EX_rd, IF_ID_rs, IF_ID_rt, ID_EX_rs, ID_EX_rt, EX_MEM_rd, MEM_WB_rd;
  wire[5:0] opcode, func;
  wire[8:0] control_signals; 
  
  wire [2:0] alu_ctrl;
  
  datapath DP(  clk, rst, control_signals, pc_en, c_or_nop, IF_ID_en, IF_flush, ID_flush, pc_src,
                  jump, ID_EX_memread, EX_MEM_memread, ID_EX_rd, IF_ID_rs, IF_ID_rt, ID_EX_rs,
                  ID_EX_rt, EX_MEM_rd,ID_EX_reg_write, EX_MEM_reg_write, MEM_WB_reg_write,MEM_WB_rd,
                  forwarda, forwardb, forwardc, forwardd, mem_read, mem_write, are_equal, zero, inst_adr, data_adr,
                   data_out, inst, data_in, opcode, func
            );
            
  controller CU(  pc_en, c_or_nop, IF_ID_en, IF_flush, ID_flush, pc_src, forwarda, forwardb, forwardc, forwardd, jump,
                      control_signals, are_equal, zero, ID_EX_memread, EX_MEM_memread, ID_EX_reg_write, EX_MEM_reg_write, MEM_WB_reg_write,
                      ID_EX_rs, ID_EX_rt, ID_EX_rd, IF_ID_rs, IF_ID_rt, EX_MEM_rd, MEM_WB_rd,
                      opcode, func 
                );
  
endmodule
