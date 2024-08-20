`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2024 05:49:28 PM
// Design Name: 
// Module Name: Baud_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Baud_gen(
       input CLK,
       input [2:0] sel,
       input reset_external,
       output baud_clk
    );
    reg [10:0] baud_cnt;
    reg [10:0] count = 10'd0;
    wire reset_baudf;
    always @(*) begin
        case(sel)
            3'd0: baud_cnt= 10'd1920;  //1920 for 9600 Baud
            3'd1: baud_cnt= 10'd960;  //960 for 19200
            3'd2: baud_cnt= 10'd480;  //480 for 38400
            3'd3: baud_cnt= 10'd320;  //320 for 57600
            3'd4: baud_cnt= 10'd160;  //160 for 115200
            3'd5: baud_cnt= 10'd80;  //80  for 230400
            3'd6: baud_cnt= 10'd40; //40  for 460800
            3'd7: baud_cnt= 10'd20; //20  for 921600
    endcase
end
assign reset_baudf = (count >= (baud_cnt-1)) ? 1:0;
assign baud_clk = (count < (baud_cnt/2)) ? 1:0;

always @(posedge CLK,posedge reset_external) begin
    if(reset_external) begin
        count<=0;
    end
    else if(reset_baudf == 1'b1) begin
        count<=0;
    end
    else begin
        count = count + 'd1;
    end

end
endmodule
