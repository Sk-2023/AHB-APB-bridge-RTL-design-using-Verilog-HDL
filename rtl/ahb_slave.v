module ahb_slave(Hclk, Hresetn, Hwrite, Hreadyin, HWdata, Haddr, Htrans, HRdata_1,
                           Haddr_1, Haddr_2, Haddr_3, HWdata_1, HWdata_2, HWdata_3,
                           Temp_selx, Valid, Hwritereg, Hwritereg_2, HRdata);
                  
 input Hclk, Hresetn, Hwrite, Hreadyin;
 input [31:0] Haddr, HWdata,HRdata_1;
 input [1:0] Htrans;
 
 output reg [31:0] Haddr_1, Haddr_2, Haddr_3,HWdata_1, HWdata_2, HWdata_3;
 output reg [2:0] Temp_selx;
 output reg Valid, Hwritereg, Hwritereg_2;
 output [31:0] HRdata;
 
 assign HRdata = HRdata_1;
 
 always @(posedge Hclk or posedge Hresetn)
 begin
	if(~Hresetn)
		begin
			Haddr_1<=0;
			Haddr_2<=0;
			Haddr_3<=0;
		
			HWdata_1<=0;
			HWdata_2<=0;
			HWdata_3<=0;
		end
	else							//pipelining logic implementation
		begin
			Haddr_1<=Haddr;
			Haddr_2<=Haddr_1;
			Haddr_3<=Haddr_2;
		
			HWdata_1<=HWdata;
			HWdata_2<=HWdata_1;
			HWdata_3<=HWdata_2;

		end
 end
 
 always @(posedge Hclk or posedge Hresetn)
 begin
	if(~Hresetn)
		begin
			Hwritereg<=0;
			Hwritereg_2<=0;
		end
		
	else
		begin
			Hwritereg<=Hwrite;
			Hwritereg_2<=Hwritereg;
		end
 end

always@(posedge Hresetn, Haddr, Htrans, Hreadyin)
begin
	if(~Hresetn)
		Valid = 1'b0;
	else if((Haddr>=32'h8000_0000 && Haddr<32'h8c00_0000) && (Htrans==2'b10 || Htrans==2'b11) && (Hreadyin))
		Valid = 1'b1;
	else
		Valid = 1'b0;
end	

always@(*)
begin
		if(Haddr>=32'h8000_0000 && Haddr<32'h8400_0000)
			Temp_selx= 3'b001;
			
		else if(Haddr>=32'h8400_0000 && Haddr<32'h8800_0000)
			Temp_selx= 3'b010;
			
		else if(Haddr>=32'h8800_0000 && Haddr<32'h8c00_0000)
			Temp_selx= 3'b100;
end


endmodule