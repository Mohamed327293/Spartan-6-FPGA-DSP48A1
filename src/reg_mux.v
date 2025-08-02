module reg_mux(in , clk , clk_en , rst , out_mux);

parameter WIDTH = 18;
parameter RSTTYPE = "SYNC"; // takes values ("SYNC" or "ASYNC")
parameter REG = 1 ;

input [WIDTH-1:0] in;
input clk, rst , clk_en;
output [WIDTH-1:0] out_mux;
reg [WIDTH-1:0] out_reg;

generate 
  if (RSTTYPE == "ASYNC")
    begin
      if(REG)
        begin
          always @(posedge clk or posedge rst)
            begin
                if (rst)
                    out_reg <= {WIDTH{1'b0}};
                else if (clk_en)
                    out_reg <= in;
            end
          assign out_mux = out_reg;
        end
      else
        assign out_mux = in; ;
    end
  else // RSTTYPE == "SYNC"
    begin
      if(REG)
        begin
          always @(posedge clk)
            begin
                if (rst)
                    out_reg <= {WIDTH{1'b0}};
                else if (clk_en)
                    out_reg <= in;
            end
          assign out_mux = out_reg;
        end
      else
        assign out_mux = in; ;
    end
endgenerate

endmodule