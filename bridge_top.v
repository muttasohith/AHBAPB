module bridge_top(input hclk,hresetn,hwrite,hready_in,
                  input [31:0] hwdata,haddr,pr_data,
                  input [1:0] htrans,
                  output hready_out,p_write,p_enable,
                  output [31:0] hr_data,pwdata,paddr,
                  output [2:0] p_selx,
                  output [1:0] hresp);
         wire valid,hwrite_reg,hwritereg_1;
         wire [31:0] haddr_1,haddr_2,hwdata_1,hwdata_2;
         wire [2:0] tempselx;
      ahb_slave  AHB_Slaveinterface(hclk,hresetn,hwrite,hready_in,htrans,haddr,hwdata,
   pr_data,hwrite_reg,valid,haddr_1,haddr_2,hwdata_1,hwdata_2, hr_data,tempselx);
      apb_controller  APB_Controller(hclk,hresetn,hwrite,hwrite_reg,valid,haddr,hwdata,haddr_1,haddr_2,hwdata_1,hwdata_2,pr_data,hr_data,tempselx,p_selx,p_write,p_enable,hready_out,pwdata,paddr);
endmodule