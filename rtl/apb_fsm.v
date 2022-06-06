module apb_fsm(Valid,Hclk,Hresetn, Hwrite,Haddr_1, Haddr_2, Haddr_3, HWdata_1, HWdata_2, HWdata_3, Temp_selx, 
                      Hwritereg, Hwritereg_2, Hreadyout,HRdata_1,
                      Penable, Pwrite, PWdata, PRdata, Paddr, Pselx);

 input Valid, Hwrite, Hwritereg, Hwritereg_2, Hclk, Hresetn;
 input [31:0] Haddr_1, Haddr_2, Haddr_3, HWdata_1, HWdata_2, HWdata_3, PRdata;
 input [2:0] Temp_selx;
  
 
 output reg[2:0] Pselx;
 output reg Penable, Pwrite,Hreadyout;
 output reg [31:0] PWdata,Paddr;
 output [31:0] HRdata_1;
 
 parameter ST_IDLE = 3'b000, ST_WWAIT = 3'b001, ST_WRITE = 3'b010, ST_WRITEP = 3'b011, ST_WENABLEP=3'b100,
           ST_READ=3'b101, ST_RENABLE = 3'b110, ST_WENABLE=3'b111;
 
 reg [2:0] present_state, next_state;
 
 assign HRdata_1= PRdata;
 
 always @(posedge Hclk or posedge Hresetn)
 begin
	if(~Hresetn)							//sequential logic
		present_state<=ST_IDLE;
	else
		present_state<=next_state;
 end
 
 always @(*)
 begin
	next_state = ST_IDLE;
	Pselx = 3'b000;
	Pwrite = 1'b0;
	Hreadyout=1'b0;
    Penable=0;
    Paddr=32'd0;
    PWdata=32'd0;
     
	 case(present_state)
		ST_IDLE: begin
					Pselx = 3'b000;
					Penable = 1'b0;
					Hreadyout = 1'b0;
					
					if(~Valid)
						next_state = ST_IDLE;
						
					else if(Valid && Hwrite)
						next_state = ST_WWAIT;
						
					else 
						next_state = ST_READ;
				 end
		
		ST_WWAIT: begin
					Hreadyout = 1'b0;
					Pselx = 3'd0;
					Penable = 1'b0;
					Pwrite = 1'b0;
					
					if(~Valid)
						next_state = ST_WRITE;
						
					else if(Valid)
						next_state = ST_WRITEP;
				  end
				  
		ST_WRITE: begin
					Paddr=Haddr_1;
					Pselx=Temp_selx;
					Pwrite=1'b1;
					Penable=1'b0;
					PWdata=HWdata_1; // HWdata_1
					Hreadyout=1'b0;
		        
					if(Valid)
						next_state = ST_WENABLEP;
					else if(~Valid)
						next_state = ST_WENABLE;
				  end
				  
        ST_WRITEP: begin
					Paddr= Haddr_2;
					Pselx= Temp_selx;
					Pwrite=1'b1;
					Hreadyout=1'b0;
					Penable=1'b0;
					PWdata=HWdata_1;
						
					next_state = ST_WENABLEP;
				   end
		
		ST_WENABLEP: begin
						Pwrite=1'b1;
						Penable=1'b1;
						Hreadyout=1'b1;
						Paddr=Haddr_3;
						PWdata=HWdata_2;
						Pselx=Temp_selx;
						
						if(Valid && Hwritereg)
							next_state = ST_WRITEP;
							
						else if (~Valid && Hwritereg)
							next_state = ST_WRITE; 
							
						else if(~Hwritereg)
							next_state = ST_READ;
					 end
		
		ST_WENABLE: begin
						Penable=1'b1;
						Pselx=Temp_selx;
						Pwrite=1'b1;
						Paddr=Haddr_2;
						Hreadyout=1'b1;
						PWdata = HWdata_1;
		        
						if(Valid && ~Hwritereg)
							next_state = ST_READ;
							
						else if(~Valid)
							next_state = ST_IDLE;
							
						else if(Valid && Hwritereg)
							next_state = ST_WWAIT;
					end	

		
		ST_READ: begin
					Pselx=Temp_selx;
					Penable=1'b0;
					Paddr=Haddr_1;
					Pwrite=1'b0;
					Hreadyout=1'b0;
					
					next_state = ST_RENABLE;
				 end
		
		ST_RENABLE: begin
						Penable=1'b1;
						Pwrite=1'b0;
						Hreadyout=1'b1;
						Pselx=Temp_selx;
						Paddr = Haddr_1;
						
						if(~Valid)
							next_state = ST_IDLE;
							
						else if(Valid && ~Hwritereg)
							next_state = ST_READ;
							
						else if(Valid && Hwritereg)
							next_state = ST_WWAIT;
					end
					
		default: next_state = ST_IDLE;
	endcase
 end
 endmodule