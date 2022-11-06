module ahb_slave(input hclk,hresetn,hwrite,hready_in,
                 input [1:0] htrans, 
                 input [31:0] haddr,hwdata,pr_data,
                 output reg hwrite_reg,valid,
                 output reg [31:0] haddr_1,haddr_2,hwdata_1,hwdata_2,
                 output [31:0] hr_data,
                 output reg [2:0] tempselx);
                 reg hwrite_reg_1;
  always@(posedge hclk)
    begin
      if(!hresetn)
         begin
            haddr_1 <= 0;
            haddr_2 <= 0;
            hwdata_1 <= 0;
            hwdata_2 <= 0;
         end
      else
        begin
         haddr_2 <= haddr_1;
         haddr_1 <= haddr;
         hwdata_2 <= hwdata_1;
         hwdata_1 <= hwdata;
        end
    end
  always@(posedge hclk)
    begin
      if(!hresetn)
          begin
           hwrite_reg_1 <= 0;
           hwrite_reg <= 0;
          end
      else
          begin
           hwrite_reg <= hwrite_reg_1;
           hwrite_reg_1 <= hwrite;
          end
    end
  always@(*)
    begin
      valid = 1'b0;
        if(hready_in == 1'b1 && (htrans == 2'b10 || htrans == 2'b11) && (haddr >= 32'h80000000 && haddr < 32'h8c000000))
          begin
            valid = 1'b1;
          end
    end
  always@(*)
   begin
     tempselx = 3'b000;
       if(haddr > 32'h80000000 && haddr < 32'h84000000)
         tempselx = 3'b001;
           if(haddr > 32'h84000000 && haddr < 32'h88000000)
             tempselx = 3'b010;
               if(haddr > 32'h88000000 && haddr < 32'h8c000000)
                 tempselx = 3'b100;
   end
   assign hr_data = pr_data;
endmodule