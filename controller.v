module controller (pc_en,c_or_nop, IF_ID_en, IF_flush, ID_flush, pc_src, forwarda, forwardb, forwardc, forwardd, jump,
                      control_signals, are_equal, zero, ID_EX_memread, EX_MEM_memread, ID_EX_reg_write, EX_MEM_reg_write, MEM_WB_reg_write,
                      ID_EX_rs, ID_EX_rt, ID_EX_rd, IF_ID_rs, IF_ID_rt, EX_MEM_rd, MEM_WB_rd,
                      opcode, func);
                    
    output pc_en, c_or_nop, IF_ID_en, ID_flush;
    output reg IF_flush, pc_src;
    output reg [1:0] jump;
    output[1:0] forwarda, forwardb, forwardc, forwardd;
    output [8:0] control_signals;
    
    input are_equal, zero, ID_EX_memread, EX_MEM_memread, ID_EX_reg_write, EX_MEM_reg_write, MEM_WB_reg_write;
    input[4:0] ID_EX_rs, ID_EX_rt, ID_EX_rd, IF_ID_rs, IF_ID_rt, EX_MEM_rd, MEM_WB_rd;
    input [5:0] opcode;
    input [5:0] func;
    
    reg reg_write, reg_dst, mem_read, mem_write, alu_src_b, ID_flush_taken, mem_to_reg;        
    reg [1:0] alu_op;
    wire h1_pce, h2_pce, h1_ie, h2_ie, ID_flush_stall, apply;        
    wire [2:0] operation;


assign control_signals = {mem_to_reg, reg_write, mem_write, mem_read, alu_src_b, operation, reg_dst}; 
    assign pc_en = h1_pce & h2_pce;
    assign IF_ID_en = h1_ie & h2_ie;
    assign ID_flush = ID_flush_stall | ID_flush_taken;
    

    alu_controller ALU_CTRL(
                           .alu_op(alu_op), 
                           .func(func), 	
			   .operation(operation)	
                           );
    
    forwarding_unit EX_FU(
			   .ID_EX_rs(ID_EX_rs), 
                           .ID_EX_rt(ID_EX_rt), 
                           .EX_MEM_rd(EX_MEM_rd), 
                           .MEM_WB_rd(MEM_WB_rd), 
                           .EX_MEM_reg_write(EX_MEM_reg_write), 
                           .MEM_WB_reg_write(MEM_WB_reg_write), 
                           .forward1(forwarda), 
                           .forward2(forwardb)
                          );
    
    hazard_unit MEMORY_HU(
                           .ID_EX_rt(ID_EX_rt), 
                           .IF_ID_rs(IF_ID_rs), 
                           .IF_ID_rt(IF_ID_rt), 
                           .ID_EX_memread(ID_EX_memread), 
                           .pc_en(h1_pce),
                           .IF_ID_en(h1_ie),
                           .c_or_nop(c_or_nop)
                          );
    
   new_forwarding_unit ID_FU(
                           .IF_ID_rs(IF_ID_rs), 
                           .IF_ID_rt(IF_ID_rt), 
                           .ID_EX_reg_write(ID_EX_reg_write), 
                           .ID_EX_rd(ID_EX_rd), 
                           .EX_MEM_rd(EX_MEM_rd), 
                           .EX_MEM_reg_write(EX_MEM_reg_write), 
                           .MEM_WB_rd(MEM_WB_rd), 
                           .MEM_WB_reg_write(MEM_WB_reg_write), 
                           .forward3(forwardc), 
                           .forward4(forwardd)
                           );
     
    new_hazard_unit BRANCH_HU(
                           .opcode(opcode),
                           .ID_EX_rd(ID_EX_rd), 
                           .EX_MEM_rd(EX_MEM_rd), 
                           .IF_ID_rs(IF_ID_rs), 
                           .IF_ID_rt(IF_ID_rt), 
                           .ID_EX_memread(ID_EX_memread), 
                           .EX_MEM_memread(EX_MEM_memread), 
                           .h1_pce(h2_pce), 
                           .IF_ID_en(h2_ie), 
                           .ID_flush(ID_flush_stall), 
                           .apply(apply)
                           );


    
    always @(opcode, are_equal)
    begin
      {IF_flush, ID_flush_taken, mem_to_reg, reg_write, mem_write, mem_read, alu_src_b, reg_dst, alu_op, pc_src, jump} = 13'd0;
      case (opcode)
        // RType instructions
        6'b000000 : {mem_to_reg, reg_dst, reg_write, alu_op} = 5'b11110;   
        // Load Word (lw) instruction           
        6'b100011 : {alu_src_b, reg_write, mem_read} = 3'b111; 
        // Store Word (sw) instruction
        6'b101011 : {mem_to_reg, alu_src_b, mem_write} = 3'b111;                                 
        // Branch on equal (beq) instruction
        6'b000100 : {pc_src, IF_flush, ID_flush_taken} = (are_equal & apply == 1'b1) ? 3'b111 : 1'b000; 
        // Add immediate (addi) instruction
        6'b001001: {mem_to_reg, reg_write, alu_src_b} = 3'b111; 
        // Set lower than immediate (slti) instruction 
        6'b001010: {mem_to_reg, reg_write, alu_src_b, alu_op} = 5'b11111;
        // Jump (j) instruction 
        6'b000010: {pc_src, jump, ID_flush_taken, IF_flush} = 5'b10111;    
        // Jump register (jr) instruction    
        6'b000110: {pc_src, jump, ID_flush_taken, IF_flush} = 5'b11011;
      endcase 
    end
    
  
endmodule
