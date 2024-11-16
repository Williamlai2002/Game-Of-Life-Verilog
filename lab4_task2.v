module lab4_task2(CLOCK_50, KEY, LEDR);
	input CLOCK_50;
	input [1:0] KEY;
	output [9:0] LEDR;
	
	// A test Default state, you can find more in the lab doc
	wire [63:0] default_state;
	assign default_state = 64'd147499484866150400;
	
	// TODO: Make a counter so that the game runs at the specified speed
	
	//Make Game Clock 
	reg [24:0] counter; //log2(50*1mil/2.98)
	reg CLOCK2point98HZ;
	always @ (posedge CLOCK_50) begin 
		counter = counter + 1;
		if (counter == 16778523) begin  //(50*1000000/2.98)
		   counter <= 0;
			CLOCK2point98HZ = ~ CLOCK2point98HZ;
		end else begin
            counter <= counter + 1;
        end
	end
	
	//make game write clock
	reg CLOCKGAMEWRITE; // write should be 8 times slower than the game clock
	reg [20:0] gamewritecounter;
	always @ (posedge CLOCK_50) begin 
		gamewritecounter <= gamewritecounter + 1;
		if (gamewritecounter == 2097315) begin  //(50*1000000/2.98 * 8)
		   gamewritecounter <= 0;
			CLOCKGAMEWRITE <= ~ CLOCKGAMEWRITE;
			end else begin
            gamewritecounter <= gamewritecounter + 1;
        end
	end
	
	//make row clock
	reg rowclock; // write should be 8 times faster than the game clock
	reg [20:0] rowcounter;
	always @ (posedge CLOCK_50) begin 
		rowcounter <= rowcounter + 1;
		if (rowcounter == 134228184) begin  
		   rowcounter <= 0;
			rowclock <= ~ rowclock;
			end else begin
            rowcounter <= rowcounter + 1;
        end
	end
	
	//Registers & wires
	reg[7:0] jtag_row;
	wire [63:0] game_output;
	
	// JTAG MODULE
	JTAG_UART_MODULE jtag(
		.clk(CLOCK_50),
		.write(/* Write Clock */CLOCKGAMEWRITE),
		.writedata(/* single row of the game board */ jtag_row), //connect output of game of life to input of JTAG module
		.reset(),
		.readdata(),
	);
	
	// GAME OF LIFE
	game_of_life game(
		.clk(/* Game Clock */ CLOCK2point98HZ),
		.load(/* Load Signal */ KEY[0]), 
		.data(default_state),
		.q(/* Whole board output */game_output)
		);  
	
	 reg [7:0] row_index;
	// Seperate the game of life output into rows. The rows should update 8x faster than the game does
	always @(posedge /* Write Clock */ rowclock ) begin
		/* sequentially update the output to the jtag*/
		 // Update row_index to iterate over rows
        if (row_index == 7) begin
            row_index <= 0;
        end else begin
            row_index <= row_index + 1;
        end
        
        // Extract the appropriate row from game_output
        jtag_row <= game_output[(row_index * 8) +: 7];
	end
	
	assign LEDR = jtag_row[7:0];
endmodule

module game_of_life(clk, load, data, q);
    input load;
    input clk;
    input [63:0] data;
    output reg [63:0] q; 

    reg [63:0] q_next;
    reg [3:0] counter;

	initial begin
		q_next = 0;
		counter = 0;
	end
	
	// TODO: Initiliaze Loop integers
    integer i;
	 integer j;
	 integer alive_neighbours;
	 
    always @(*) begin 
        // Game of life code
		  
	    // Two main for-loops to handle the analysis of each cell
	    for (i = 1; i < 8; i = i + 1) begin
            for (j = 1; j < 8; j = j + 1) begin
                // Check for edge conditions
					 
                // Count the neighbours
					 alive_neighbours = 0;
					 if (data[i*8+j] == 1) begin
					 
					   if(i > 0) begin
							if (data[(i-1)*8+j] == 1) begin
							alive_neighbours = alive_neighbours +1;
							end
						end else
						
						if(i< 7) begin
							if ((data[(i+1)*8+j] == 1))begin
								alive_neighbours = alive_neighbours +1;
							end
						end else
						
						if((i >0) && (j >0)) begin
							if (data[(i-1)*8+(j-1)] == 1) begin
							alive_neighbours = alive_neighbours +1;
							end
						end else
						
						if(j>0) begin
							if (data[i*8+(j-1)] == 1) begin
							alive_neighbours = alive_neighbours +1;
							end
						end else
						
						if((i<7) && (j>0)) begin
							if (data[(i+1)*8+(j-1)] == 1) begin
							alive_neighbours = alive_neighbours +1;
							end
						end else
						
						if((i<7) && (j>0)) begin
							if (data[(i+1)*8+(j-1)] == 1) begin
							alive_neighbours = alive_neighbours +1;
							end
						end else
						
					   if ((i>0) && (j<7)) begin
							if (data[(i-1)*8+(j+1)] == 1) begin
							alive_neighbours = alive_neighbours +1;
							end
						end else
						
						if((i>0) && (j<7)) begin
							if (data[(i-1)*8+(j+1)] == 1) begin
							alive_neighbours = alive_neighbours +1;
							end
						end else
						
						if((j<7)) begin
							if (data[i*8+(j+1)] == 1) begin
							alive_neighbours = alive_neighbours +1;
							end
						end else
						
						if (i < 7 && j < 7)begin
							if (data[(i+1)*8 + (j+1)] == 1) begin
							alive_neighbours = alive_neighbours +1;
							end
						end
					 end
					 //current cell is alive
					 if (data[i*8 + j] == 1) begin 
						if (alive_neighbours == 0 || alive_neighbours == 1) begin
							q_next[i*8 + j] = 0;
						end
						if(alive_neighbours == 2) begin
							q_next[1*8 + j] = data[1*8 + j];
						end
						if(alive_neighbours ==3) begin
							q_next[1*8 + j] =1;
						end
						if(alive_neighbours >4) begin
							q_next[1*8 + j] =0;
						end
			
					 end 
                // Choose next state
					 
            end
	    end
    end        
    
    
    always @(posedge clk) begin
        if (load) q <= data;
        else q <= q_next;
    end
endmodule
