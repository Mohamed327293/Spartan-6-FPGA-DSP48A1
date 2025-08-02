module DSP48A1 (A , B , C , D , CARRYIN, BCIN , M , P , CARRYOUT , CARRYOUTF , CLK , OPMODE , CEA,
            CEB, CEC , CED , CECARRYIN , CEM , CEOPMODE , CEP , RSTA , RSTB , RSTC ,
            RSTCARRYIN, RSTD, RSTM , RSTOPMODE , RSTP , BCOUT , PCIN , PCOUT);
parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1; 
parameter CREG  = 1;
parameter DREG  = 1;
parameter MREG  = 1;
parameter PREG  = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODES"; // takes values ("OPMODES" or "CARRYIN")
parameter B_INPUT = "DIRECT"; // takes values ("DIRECT" or "CASCADE")
parameter RSTTYPE = "SYNC"; // takes values ("SYNC" or "ASYNC")

input [17:0] A , B , D;
input [47:0] C ;
input CLK , CARRYIN;
input [7:0] OPMODE;
input [17:0] BCIN;
input RSTA , RSTB , RSTC , RSTCARRYIN , RSTD, RSTM , RSTOPMODE , RSTP;
input CEA , CEB , CEC , CECARRYIN, CED , CEM , CEOPMODE , CEP;
input [47:0] PCIN;

output [17:0] BCOUT;
output [47:0] PCOUT;
output [47:0] P;
output [35:0] M;
output CARRYOUT , CARRYOUTF;

wire [17:0] A0_IN;
wire [17:0] A_IN;
wire [17:0] B0_IN;
wire [17:0] B_IN;
wire [47:0] C_IN;
wire [17:0] D_IN;
wire [17:0] pre_a_s; // the pre-adder/subtractor result
wire [17:0] MUX_4_OUT; //the output of the mux between add/sub and muul 
wire [35:0] MUL;    // the result of the multiplier
wire [35:0] M_OUT;  // output of the M_REG
wire [47:0] POUT_wire;  // output of the P_REG
wire [47:0] MUX_X; 
wire [47:0] MUX_Z; 
wire CIN;
wire Out_Carry;
wire [47:0] post_a_s; // the post-adder/subtractor result
wire COUT; // Carry out from the adder/subtractor
// INSTANTIATION FOR A0_REG_MUX
  reg_mux #(.WIDTH(18) , .REG(A0REG))A0_REG_MUX 
           (.in(A), .clk(CLK), .clk_en(CEA), .rst(RSTA), .out_mux(A0_IN));

// INSTANTIATION FOR A1_REG_MUX
  reg_mux #(.WIDTH(18) , .REG(A1REG))A1_REG_MUX 
           (.in(A0_IN), .clk(CLK), .clk_en(CEA), .rst(RSTA), .out_mux(A_IN));

// INSTANTIATION FOR D_REG_MUX
  reg_mux #(.WIDTH(18) , .REG(DREG))D_REG_MUX 
           (.in(D), .clk(CLK), .clk_en(CED), .rst(RSTD), .out_mux(D_IN));

// INSTANTIATION FOR B0_REG_MUX
generate
  if(B_INPUT == "DIRECT")
    begin
      reg_mux #(.WIDTH(18) , .REG(B0REG))B0_REG_MUX_DIRECT 
               (.in(B), .clk(CLK), .clk_en(CEB), .rst(RSTB), .out_mux(B0_IN));
    end
  else if(B_INPUT == "CASCADE")
    begin
      reg_mux #(.WIDTH(18) , .REG(B0REG))B0_REG_MUX_CASCADE 
               (.in(BCIN), .clk(CLK), .clk_en(CEB), .rst(RSTB), .out_mux(B0_IN));
    end
  else
      assign B0_IN = 18'b0; // Default case if B_INPUT is neither DIRECT nor CASCADE
endgenerate

//PRE ADDER/SUBTRACTOR 
assign pre_a_s = OPMODE[6] ? (D_IN - B0_IN) : (D_IN + B0_IN) ; // pre_a_s is the result of the adder/subtractor for b & d 

assign MUX_4_OUT = OPMODE[4] ? pre_a_s : B0_IN;

// INSTANTIATION FOR B1_REG_MUX
reg_mux #(.WIDTH(18) , .REG(B1REG))B1_REG_MUX
         (.in(MUX_4_OUT), .clk(CLK), .clk_en(CEB), .rst(RSTB), .out_mux(B_IN));

assign BCOUT = B_IN; // BCOUT (our first output)
assign MUL = B_IN * A_IN; // the result of the multiplier

// INSTANTIATION FOR C_REG_MUX
reg_mux #(.WIDTH(48) , .REG(CREG))C_REG_MUX 
         (.in(C), .clk(CLK), .clk_en(CEC), .rst(RSTC), .out_mux(C_IN));

// INSTANTIATION FOR M_REG_MUX
reg_mux #(.WIDTH(36) , .REG(MREG))M_REG_MUX 
         (.in(MUL), .clk(CLK), .clk_en(CEM), .rst(RSTM), .out_mux(M_OUT));

assign M = M_OUT; // M is the output of the multiplier

// Creating MUX X & Z
assign MUX_X = (OPMODE[1:0] == 2'b00) ? 48'b0 : 
                (OPMODE[1:0] == 2'b01) ? {12'b0 , M_OUT} :
                (OPMODE[1:0] == 2'b10) ? POUT_wire :
                {D_IN[11:0], A_IN[17:0], B_IN[17:0]};
assign MUX_Z = (OPMODE[3:2] == 2'b00) ? 48'b0 : 
                (OPMODE[3:2] == 2'b01) ? PCIN :
                (OPMODE[3:2] == 2'b10) ? POUT_wire :
                C_IN;
// INSTANTIATION FOR CIN_REG
generate
  if(CARRYINSEL == "OPMODES")
    begin
      reg_mux #(.WIDTH(1) , .REG(CARRYINREG))cin_opmode5 
               (.in(OPMODE[5]), .clk(CLK), .clk_en(CECARRYIN), .rst(RSTCARRYIN), .out_mux(CIN));
    end
  else if(B_INPUT == "CARRYIN")
    begin
     reg_mux #(.WIDTH(1) , .REG(CARRYINREG))cin_carry_cascade 
               (.in(CARRYIN), .clk(CLK), .clk_en(CECARRYIN), .rst(RSTCARRYIN), .out_mux(CIN));
    end
  else
      assign CIN = 18'b0; // Default case if CARRYINSEL is neither OPMODES nor CARRYIN
endgenerate
//POST ADDER/SUBTRACTOR
assign {Out_Carry , post_a_s} = OPMODE[7] ? (MUX_Z - (MUX_X + CIN)) : (MUX_X + MUX_Z + CIN); 
// INSTANTIATION FOR P_REG_MUX
  reg_mux #(.WIDTH(48) , .REG(PREG))P_REG_MUX 
           (.in(post_a_s), .clk(CLK), .clk_en(CEP), .rst(RSTP), .out_mux(POUT_wire));
assign P = POUT_wire; // P is the output of the DSP48A1
assign PCOUT = POUT_wire; 
// CARRYOUT and CARRYOUTF
  reg_mux #(.WIDTH(1) , .REG(CARRYOUTREG))CARRYOUT_REG_MUX 
           (.in(Out_Carry), .clk(CLK), .clk_en(CECARRYIN), .rst(RSTCARRYIN), .out_mux(COUT));
assign CARRYOUT = COUT;
assign CARRYOUTF = COUT;
endmodule