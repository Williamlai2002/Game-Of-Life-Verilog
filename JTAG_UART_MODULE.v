module JTAG_UART_MODULE(clk, reset, write, readdata, writedata);
	input clk;
	input reset;
	input write;
	input [7:0] writedata;
	output [7:0] readdata;
	
	
	reg [20:0] slowdown_counter;
	wire half_clk_pe, write_pe;
	
	// The half clock is the speed at which data is streamed into the JTAG buffer.
	// The python script is EXTREMELY slow compared to the FPGA so even the 25MHZ half
	// speed is plenty.
	risingedgedetect pe  (slowdown_counter[1], clk, half_clk_pe);
	risingedgedetect pe1 (write, clk, write_pe);
	
	// JTAG UART
	jtag_uart_jtag_uart_0 jtag_uart_0 (
		.clk            (clk),                       //    Clock
		.rst_n          (!reset),                 	//    !reset
		.av_chipselect  (1'b1),  							// 	Chip select (always one chip)
		.av_address     (1'b0),     						//    Address
		.av_read_n      (!clk),      						//    !read
		.av_readdata    (readdata),    					//    read data
		.av_write_n     (!write_pe),     				//    !write
		.av_writedata   (writedata),   					//    write data
		.av_waitrequest (), 									//    request data from pc
		.av_irq         ()                           //    Interrupt
	);
	
	
	always @(posedge clk) begin
		slowdown_counter <= slowdown_counter + 1;
	end

endmodule

// Outputs the rising edge of a wire
module risingedgedetect (
    input sig,           
    input clk,                     
    output pe,
    output reg out
);          

    reg sig_dly;                         

    always @ (posedge clk) begin
        sig_dly <= sig;
    end

    assign pe = sig & ~sig_dly;            

    always @ (posedge clk) begin
        if (pe) begin
            out <= ~out;
        end
    end
endmodule 