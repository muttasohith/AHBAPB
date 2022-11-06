module top_tb();
     reg hclk,hresetn;
     wire hready_out;
     wire penable_out,pwrite_out;
     wire [2:0] psel_out;
     wire [31:0] paddr_out,pwdata_out;
     wire [31:0] pr_data;
   
     wire hwrite,hready_in;
     wire [1:0] htrans;
     wire [31:0] hwdata,haddr;
     wire p_write,p_enable;
     wire [2:0] p_selx;
     wire [31:0] paddr,pwdata,hr_data;
     wire [1:0] hresp;

    assign hr_data = pr_data;

    ahb_master AHB_MASTER(hclk,hresetn,hready_out,hresp,hr_data,hwrite,hready_in,htrans,hwdata,haddr);
    bridge_top BRIDGE_TOP(hclk,hresetn,hwrite,hready_in,hwdata,haddr,pr_data,htrans,hready_out,p_write,p_enable,hr_data,pwdata,paddr,p_selx,hresp);
    apb_interface APB_INTERFACE(p_write,p_enable,p_selx,paddr,pwdata,pwrite_out,penable_out,psel_out,paddr_out,pwdata_out,pr_data);
   initial
     begin
       hclk =0;
       forever #10 hclk = ~hclk;
     end
    
   task reset();
    begin
      @(negedge hclk)
         hresetn = 0;
      @(negedge hclk)
         hresetn = 1;
    end
   endtask
 initial
  begin
   reset();
   //AHB_MASTER.single_write;
   AHB_MASTER.single_read;
   #100 $finish;
  end   

endmodule
