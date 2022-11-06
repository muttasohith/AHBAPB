module ahb_master(input hclk,hresetn,hready_out,input [1:0] hresp, input [31:0] hr_data,
                  output reg hwrite,hready_in,output reg [1:0] htrans, output reg [31:0] hwdata,haddr);
                  reg [2:0] hburst,hsize;  
           
                 // integer i = 0;   
                 //parameter BYTE = 3'b000;
                 //parameter HALF_WORD = 3'b001;
                 //parameter WORD = 3'b010;
      task single_write();
        begin
          @(posedge hclk);
           #1;
           begin
            hwrite = 1;
            htrans =2'd2;
            hsize = 0;
            hburst = 0;
            hready_in = 1;
            haddr = 32'h8000_0001;
           end
          @(posedge hclk);
          #1;
           begin
            htrans = 2'd0;
            hwdata = 32'h8202_0613;
           end
        end
      endtask
     task single_read();
        begin
          @(posedge hclk);
           #1;
           begin
            hwrite = 0;
            htrans =2'd2;
            hsize = 0;
            hburst = 0;
            hready_in = 1;
            haddr = 32'h8000_0003;
           end
          @(posedge hclk);
          #1;begin
            htrans = 2'd0;
           end
        end
      endtask
endmodule