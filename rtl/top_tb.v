module top_tb();

 reg Hclk, Hresetn;
 reg [1:0] Hresp;

 wire Penableout,Pwriteout;
 wire [2:0] Pselxout;
 wire [31:0] Paddrout,PWdataout;
 wire [31:0] PRdata;
 wire Hwrite,Hreadyin;
 wire [1:0]Htrans;
 wire [31:0] HWdata,Haddr;
 wire [31:0] Paddr,PWdata,HRdata;
 wire Penable,Pwrite;
 wire [2:0] Pselx;
 
 ahb_master ahb_master(Hclk, Hresetn, HRdata, Hreadyout, Hresp, Htrans, Hreadyin, HWdata, Haddr, Hwrite);
 
 bridge_top bridge_top(Hclk, Hresetn, Hwrite,Htrans, Hreadyin, HWdata, Haddr, Hreadyout, HRdata, Penable, Pwrite, PRdata, PWdata, Paddr, Pselx);
 
 apb_interface apb_interface(Penable, Pwrite, Pselx, PRdata, Paddr, PWdata, Penableout, Pselxout, Pwriteout, Paddrout, PWdataout, PRdata);
 
 initial
 begin
	Hclk = 0;
	forever #10 Hclk = ~Hclk;
 end
 
 task reset();
 begin
	@(posedge Hclk)
		Hresetn = 0;
	@(posedge Hclk)
		Hresetn = 1;
 end
 endtask
 
 initial
 begin
	reset();
	ahb_master.single_write;
	//ahb_master.single_read;
	#1000 $finish;
	
 end
endmodule