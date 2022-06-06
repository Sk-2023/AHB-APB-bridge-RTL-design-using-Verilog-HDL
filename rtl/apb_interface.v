module apb_interface(Penable, Pwrite, Pselx, PRdata, Paddr, PWdata,
                      Penableout, Pselxout, Pwriteout, Paddrout, PWdataout, PRdata); 

input Penable, Pwrite;
input [2:0] Pselx;
input [31:0] Paddr, PWdata;

output Penableout, Pwriteout;
output [2:0] Pselxout;
output [31:0] Paddrout, PWdataout;
output reg [31:0] PRdata;  

assign Penableout = Penable;
assign Pselxout = Pselx;
assign Pwriteout = Pwrite;
assign Paddrout = Paddr;
assign PWdataout = PWdata; 

always@(*)	
	begin
		if(Penable && ~Pwrite)
			PRdata = $urandom;
		else
			PRdata=0;
	end
endmodule
