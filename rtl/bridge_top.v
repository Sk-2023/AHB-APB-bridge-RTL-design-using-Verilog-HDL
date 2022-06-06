module bridge_top(Hclk, Hresetn, Hwrite,Htrans, Hreadyin, HWdata, Haddr, Hreadyout, HRdata,
				  Penable, Pwrite, PRdata, PWdata, Paddr, Pselx);

 input Hclk, Hresetn, Hreadyin, Hwrite;
 input [31:0] HWdata, Haddr, PRdata;
 input [1:0] Htrans;
 
 output Penable, Pwrite, Hreadyout;
 output [31:0] PWdata, Paddr, HRdata;
 output [2:0] Pselx;
 
 wire [31:0] Haddr_1, Haddr_2, Haddr_3, HWdata_1, HWdata_2, HWdata_3, HRdata_1;
 wire Valid, Hwritereg, Hwritereg_2;
 wire [2:0] Temp_selx;
 
 ahb_slave ahb_slave(.Hclk(Hclk),.Hresetn(Hresetn),.Hwrite(Hwrite),.Hreadyin(Hreadyin),.HWdata(HWdata),.Haddr(Haddr),.Htrans(Htrans),.HRdata_1(HRdata_1),
                           .Haddr_1(Haddr_1),.Haddr_2(Haddr_2),.Haddr_3(Haddr_3),.HWdata_1(HWdata_1),.HWdata_2(HWdata_2),.HWdata_3(HWdata_3),
                           .Temp_selx(Temp_selx),.Valid(Valid),.Hwritereg(Hwritereg),.Hwritereg_2(Hwritereg_2),.HRdata(HRdata));
						   
 apb_fsm apb_fsm(.Valid(Valid),.Hclk(Hclk),.Hresetn(Hresetn),.Hwrite(Hwrite),.Haddr_1(Haddr_1),.Haddr_2(Haddr_2),.Haddr_3(Haddr_3), .HWdata_1(HWdata_1), 
				 .HWdata_2(HWdata_2),.HWdata_3(HWdata_3),.Temp_selx(Temp_selx),.Hwritereg(Hwritereg),.Hwritereg_2(Hwritereg_2),.Hreadyout(Hreadyout),
				 .HRdata_1(HRdata_1),.Penable(Penable),.Pwrite(Pwrite),.PWdata(PWdata),.PRdata(PRdata),.Paddr(Paddr),.Pselx(Pselx));

endmodule