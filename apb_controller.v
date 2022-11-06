module apb_controller(input hclk,hresetn,hwrite,hwrite_reg,valid,
                      input [31:0] haddr,hwdata,haddr_1,haddr_2,hwdata_1,hwdata_2,pr_data,hr_data,
                      input [2:0] tempselx,
                      output reg [2:0] p_selx,
                      output reg  p_write,p_enable,hready_out,
                      output reg [31:0] pwdata,paddr);
         parameter ST_IDLE = 3'b000;
         parameter ST_READ = 3'b001;
         parameter ST_WWAIT = 3'b010;
         parameter ST_WRITE = 3'b011;
         parameter ST_WRITEP = 3'b100;
         parameter ST_RENABLE = 3'b101;
         parameter ST_WENABLE = 3'b110;
         parameter ST_WENABLEP = 3'b111;   
         reg [2:0] ps,ns;	
         reg p_write_temp,p_enable_temp,hready_out_temp;	
         reg [2:0] p_sel_temp;
         reg [31:0] pwdata_temp,paddr_temp;			 
        //present_state logic
         always@(posedge hclk)
           begin
             if(!hresetn)
               ps <= ST_IDLE;
             else
               ps <= ns;
           end
       //next_state logic
        always@(posedge hclk)
          begin
           ns = ST_IDLE;
            case(ps)
              ST_IDLE : if(valid == 1 && hwrite == 1)
                        ns <= ST_WWAIT;
                        else if(valid == 1 && hwrite ==0)
                        ns <= ST_READ;
                        else 
                        ns <= ST_IDLE;
              ST_READ  : ns <= ST_RENABLE;
              ST_WWAIT : if(valid)
                         ns <= ST_WRITEP;
                         else 
                         ns <= ST_WRITE; 
              ST_WRITE  : if(valid)
                          ns <= ST_WENABLEP;
                          else 
                          ns <= ST_WENABLE;
              ST_WRITEP :  ns <= ST_WENABLE;
              ST_RENABLE :  if(valid == 1 && hwrite == 0)
                            ns <= ST_READ;
                            else if(valid == 1 && hwrite ==1)
                            ns <= ST_WWAIT;
                            else if(valid == 0)
                            ns <= ST_IDLE;                        
              ST_WENABLE :  if(valid == 1 && hwrite ==1)
                            ns <= ST_WWAIT;
                            else if(valid == 1 && hwrite ==0)
                            ns <= ST_READ;
                            else if(valid == 0)
                            ns <= ST_IDLE;                         
              ST_WENABLEP : if(valid == 1 && hwrite_reg ==1)
                            ns <= ST_WRITEP;
                            else if(valid == 0 && hwrite_reg ==1)
                            ns <= ST_WRITE;
                            else if(hwrite_reg == 0)
                            ns <= ST_READ;      
            endcase
          end
         // temp output logic
           always@(posedge hclk)
             begin
               case(ps)
                   ST_IDLE : begin
                                if(valid == 1 && hwrite == 0) 
                                    begin
                                       p_write_temp = hwrite;
                                       p_sel_temp = tempselx;
                                       p_enable_temp = 0;
                                       paddr_temp = haddr;
                                       hready_out_temp = 0;
                                    end 
                                else if(valid == 1 && hwrite == 1)
                                     begin
                                      p_sel_temp = 0;
                                      p_enable_temp = 0;
                                      hready_out_temp = 1; 
                                     end
                                else 
                                  begin
                                     p_sel_temp = 0;
                                     p_enable_temp = 0;
                                     hready_out_temp = 1; 
                                  end
                             end
                   ST_READ  : begin
                               p_enable_temp = 1;
                               hready_out_temp = 1; 
                              end
                   ST_WWAIT  : begin
                                 paddr_temp = haddr_1;
                                 p_write_temp = hwrite;
                                 p_sel_temp = tempselx;
                                 p_enable_temp = 0;
                                 pwdata_temp = hwdata;
                                 hready_out_temp = 0;
                               end
                   ST_WRITE : begin
                                 if(valid == 1 && hwrite == 1)
                                  begin
                                     p_sel_temp = 1;
                                     p_enable_temp = 0;
                                     hready_out_temp = 1;
                                  end
                                 else if(valid == 1 && hwrite == 0)
                                   begin
                                     p_write_temp = hwrite;
                                     p_sel_temp = tempselx;
                                     p_enable_temp = 0;
                                     paddr_temp = haddr;
                                     hready_out_temp = 0; 
                                   end
                                 else if(valid == 0)
                                   begin
                                     p_sel_temp = 0;
                                     p_enable_temp = 0;
                                     hready_out_temp = 1;
                                   end
                              end 
                   ST_WRITEP  : begin
                                  hready_out_temp = 1;
                                  p_enable_temp = 1;
                                end
                   ST_RENABLE : begin
                                  if(valid == 1 && hwrite ==1)
                                    begin 
                                     p_sel_temp = 0;
                                     p_enable_temp = 0;
                                     hready_out_temp = 1;
                                    end
                                 else if(valid == 1 && hwrite == 0)
                                    begin
                                     paddr_temp = haddr;
                                     p_write_temp = hwrite;
                                     p_sel_temp = tempselx;
                                     p_enable_temp = 0;
                                     hready_out_temp = 0; 
                                    end
                                  else if(valid == 0)
                                    begin
                                     p_sel_temp = 0;
                                     p_enable_temp = 0;
                                     hready_out_temp = 1;
                                    end
                                end
                  ST_WENABLE : begin
                                if(valid == 1 && hwrite ==1)
                                  begin
                                   p_sel_temp = 0;
                                   p_enable_temp = 0;
                                   hready_out_temp = 1; 
                                  end
                                else if(valid == 1 && hwrite == 0)
                                  begin
                                    paddr_temp = haddr;
                                    p_write_temp = hwrite;
                                    p_sel_temp = tempselx;
                                    p_enable_temp = 0;
                                    hready_out_temp = 0; 
                                  end
                                else if(valid == 0)
                                    begin
                                     p_sel_temp = 0;
                                     p_enable_temp = 0;
                                     hready_out_temp = 1;
                                    end
                               end
                   ST_WENABLEP : begin
                                  if(valid == 1 && hwrite_reg ==1)
                                    begin
                                      hready_out_temp = 0;
                                      p_enable_temp = 0;
                                      paddr_temp = haddr_2;
                                      pwdata_temp = hwdata; 
                                      p_write_temp = hwrite_reg;
                                      p_sel_temp = tempselx;
                                    end
                                  else if(valid == 0 && hwrite_reg ==1)
                                    begin
                                     hready_out_temp = 0;
                                     p_enable_temp = 0;
                                     paddr_temp = haddr;
                                     pwdata_temp = hwdata; 
                                     p_write_temp = hwrite;
                                     p_sel_temp = tempselx;
                                    end
                                  else if(hwrite_reg == 0) 
                                     begin
                                      hready_out_temp = 0;
                                      p_enable_temp = 0;
                                      paddr_temp = haddr; 
                                      p_write_temp = hwrite;
                                      p_sel_temp = tempselx;
                                     end
                                 end
               endcase
             end
         //Output logic
          always@(posedge hclk)
           begin 
             if(!hresetn)
              begin
               p_write <= 0;
               p_enable <= 0;
               pwdata <= 0;
               paddr <= 0;
               p_selx <= 0;
               hready_out <= 1;
              end
             else
              begin
               p_write <= p_write_temp;
               p_enable <= p_enable_temp;
               pwdata <= p_sel_temp;
               paddr <= paddr_temp;
               p_selx <= p_sel_temp;
               hready_out <= hready_out_temp;
              end
           end
endmodule
