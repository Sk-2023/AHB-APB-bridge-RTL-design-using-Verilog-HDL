module ahb_master(Hclk, Hresetn, HRdata, Hreadyout, Hresp, Htrans, Hreadyin, HWdata, Haddr, Hwrite);
input Hclk, Hresetn, Hreadyout;
input [31:0] HRdata;
input [1:0] Hresp;

output reg [1:0] Htrans;
output reg Hreadyin, Hwrite;
output reg [31:0] Haddr, HWdata;
reg [2:0] Hsize, Hburst;

task single_write();
begin
	@(posedge Hclk)
		//#1;
		begin
		Hwrite = 1'b1;
		Htrans = 2'b10; //Non-seq for single transfer.
		Hreadyin = 1'b1;
		Hsize = 3'b000;  //word size is 8 bit
		Hburst = 3'b000; //a single transfer.
		Haddr = 32'h8000_0001;
		end
	@(posedge Hclk)
		//#1;
		begin
		HWdata = 32'h0000_0990;
		Htrans = 2'd0; //IDLE - no pending transaction is there.
		end
	@(posedge Hclk)
		Hreadyin = 0;
end
endtask

task single_read();
begin
	@(posedge Hclk)
		//#1;
		begin
		Hwrite = 1'b0;
		Htrans = 2'b10; //Non-seq for single_read transfer
		Hreadyin = 1'b1;
		Hsize = 3'b000;
		Hburst = 3'b000;
		Haddr = 32'h8000_0001;
		end
	@(posedge Hclk)
		//#1;
		begin
		Htrans = 2'd0; //IDLE - no transaction here
		end
end
endtask
endmodule