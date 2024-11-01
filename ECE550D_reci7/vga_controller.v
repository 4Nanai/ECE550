module vga_controller(iRST_n,
                      iVGA_CLK, //50Mhz
                      ctrl_left,
                      ctrl_right,
                      ctrl_up,
                      ctrl_down,
                      last_data_received,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data);

	
input iRST_n;
input iVGA_CLK;
input ctrl_left;
input ctrl_right;
input ctrl_up;
input ctrl_down;
input [7:0] last_data_received;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
reg [9:0] square_x;
reg [9:0] square_y;
reg [4:0] square_size;

initial begin
   square_size = 5'd25;
   square_x = 10'd0;
   square_y = 10'd0;
end

reg [19:0] counter;
wire move_en; //enable to move
assign move_en = (counter == 20'd833333);

always @(posedge iVGA_CLK or negedge iRST_n) begin
   if (!iRST_n) begin
      counter <= 20'd0;
   end else if (move_en) begin
      counter <= 20'd0;
   end else begin
      counter <= counter + 20'd1;
   end
end

always @(posedge iVGA_CLK or negedge iRST_n) begin
   if (!iRST_n) begin
      square_x <= 10'd0;
      square_y <= 10'd0;
   end
   else if (move_en) begin
      if (ctrl_right && square_x + square_size < 639) begin
         square_x <= square_x + 10'd1;
      end else if (ctrl_left && square_x > 0) begin
         square_x <= square_x - 10'd1;
      end else if (ctrl_down && square_y + square_size < 479) begin
         square_y <= square_y + 10'd1;
      end else if (ctrl_up && square_y > 0) begin
         square_y <= square_y - 10'd1;
      end
   end
end

////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
	
//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) begin
   if (ADDR % 640 >= (square_x) 
      && ADDR % 640 <= (square_x + square_size) 
      && ADDR / 480 >= (square_y)
      && ADDR / 480 <= (square_y + square_size)) begin //if pixel is in square
      bgr_data <= 24'hC1B6FF;
   end
   else begin
      bgr_data <= bgr_data_raw;
   end
end

assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule