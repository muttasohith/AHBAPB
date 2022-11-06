module apb_interface(input p_write,p_enable,
                     input [2:0] p_selx,
                     input [31:0] paddr,pwdata,
                     output pwrite_out,penable_out,
                     output [2:0] psel_out,
                     output reg [31:0] pr_data,
                     output [31:0] paddr_out,pwdata_out);
            assign penable_out = p_enable;
            assign pwrite_out = p_write;
            assign psel_out = p_selx;
            assign paddr_out = paddr;
            assign pwdata_out = pwdata;
           
              always@(*)
               begin
                 if(p_write == 0 && p_enable ==1)
                  pr_data = ($random)%256;
                 else
                  pr_data = 0;
              end

endmodule
