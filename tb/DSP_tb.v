module DSP_tb();

reg [17:0] A, B, D;
reg [47:0] C ;
reg CLK , CARRYIN;
reg [7:0] OPMODE;
reg [17:0] BCIN;
reg RSTA , RSTB , RSTC , RSTCARRYIN , RSTD, RSTM , RSTOPMODE , RSTP;
reg CEA , CEB , CEC , CECARRYIN, CED , CEM , CEOPMODE , CEP;
reg [47:0] PCIN;

wire [17:0] BCOUT;
wire [47:0] PCOUT;
wire [47:0] P;
wire [35:0] M;
wire CARRYOUT , CARRYOUTF;

//with default parameters
DSP48A1 DUT (.A(A), .B(B), .D(D), .C(C), .CLK(CLK), .CARRYIN(CARRYIN), .OPMODE(OPMODE), 
                .BCIN(BCIN), .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), 
                .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP),
                .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN), .CED(CED), 
                .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP), .PCIN(PCIN),.BCOUT(BCOUT), .PCOUT(PCOUT),
                .P(P), .M(M), .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF));

initial
  begin
    CLK = 0 ;
    forever #1 CLK = ~CLK; 
  end
initial
  begin
    //2. Stimulus Generation
    //2.1. Verify Reset Operation
    RSTA = 1;
    RSTB = 1;
    RSTC = 1;
    RSTCARRYIN = 1;
    RSTD = 1 ;
    RSTM = 1 ;
    RSTOPMODE = 1 ;
    RSTP = 1 ;
    A = $random;
    B = $random;
    D = $random;
    C = $random;
    CARRYIN = $random;
    OPMODE = $random;
    BCIN = $random;
    CEA = $random;
    CEB = $random;      
    CEC = $random;
    CECARRYIN = $random;
    CED = $random;
    CEM = $random;
    CEOPMODE = $random;
    CEP = $random;
    PCIN = $random;
    @(negedge CLK);
    if (P != 48'b0 || M != 36'b0 || CARRYOUT != 1'b0 || CARRYOUTF != 1'b0)
      begin
        $display("Reset failed, P: %b, M: %b, CARRYOUT: %b, CARRYOUTF: %b", P, M, CARRYOUT, CARRYOUTF);
        $stop;
      end
    @(negedge CLK);
    RSTA = 0;
    RSTB = 0;
    RSTC = 0;
    RSTCARRYIN = 0;
    RSTD = 0 ;
    RSTM = 0 ;
    RSTOPMODE = 0 ;
    RSTP = 0 ;
    {CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP} = 8'b11111111;
    //verify path 1
    /*
    A = 20;
    B = 10;
    C = 350;
    D = 25;
    BCIN = $random;
    PCIN = $random;
    CARRYIN = $random;
    OPMODE = 8'b11011101;
    repeat(4) @(negedge CLK);
    if(BCOUT != 'hf || M != 'h12c || P != 'h32 || PCOUT != 'h32 
       || CARRYOUTF != 0 || CARRYOUT != 0)
       begin
            $display("DSP Path 1 failed, BCOUT: %h, M: %h, P: %h, PCOUT: %h, CARRYOUTF: %b, CARRYOUT: %b", 
                    BCOUT, M, P, PCOUT, CARRYOUTF, CARRYOUT);
            $stop;
       end
    $stop;
    */
    //verify path 2
    /*
    A = 20;
    B = 10;
    C = 350;
    D = 25;
    BCIN = $random;
    PCIN = $random;
    CARRYIN = $random;
    OPMODE = 8'b00010000;
    repeat(3) @(negedge CLK);
    if(BCOUT != 'h23 || M != 'h2bc || P != 0 || PCOUT != 0 
       || CARRYOUTF != 0 || CARRYOUT != 0)
       begin
            $display("DSP Path 2 failed, BCOUT: %h, M: %h, P: %h, PCOUT: %h, CARRYOUTF: %b, CARRYOUT: %b", 
                    BCOUT, M, P, PCOUT, CARRYOUTF, CARRYOUT);
            $stop;
       end
    $stop;
    */
    //verify path 3
    /*
    A = 20;
    B = 10;
    C = 350;
    D = 25;
    BCIN = $random;
    PCIN = $random;
    CARRYIN = $random;
    OPMODE = 8'b00001010;
    repeat(3) @(negedge CLK);
    if(BCOUT != 'ha || M != 'hc8 || P != PCOUT || CARRYOUTF != CARRYOUT)
       begin
            $display("DSP Path 3 failed, BCOUT: %h, M: %h, P: %h, PCOUT: %h, CARRYOUTF: %b, CARRYOUT: %b", 
                    BCOUT, M, P, PCOUT, CARRYOUTF, CARRYOUT);
            $stop;
       end
    $stop;
    */
    //verify path 4
    A = 5;
    B = 6;
    C = 350;
    D = 25;
    PCIN = 3000;
    BCIN = $random;
    CARRYIN = $random;
    OPMODE = 8'b10100111;
    repeat(3) @(negedge CLK);
    if(BCOUT != 'h6 || M != 'h1e || P != 'hfe6fffec0bb1 || PCOUT != 'hfe6fffec0bb1
       || CARRYOUTF != 1 || CARRYOUT != 1)
       begin
            $display("DSP Path 4 failed, BCOUT: %h, M: %h, P: %h, PCOUT: %h, CARRYOUTF: %b, CARRYOUT: %b", 
                    BCOUT, M, P, PCOUT, CARRYOUTF, CARRYOUT);
            $stop;
       end
    $stop;
  end
endmodule