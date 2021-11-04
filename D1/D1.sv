module D1 (input logic CLOCK_50, CLOCK2_50, input logic [0:0] KEY,
	       // I2C Audio/Video config interface 
           output logic FPGA_I2C_SCLK, inout wire FPGA_I2C_SDAT, 
           // Audio CODEC
           output logic AUD_XCK, 
		   input logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, 
		   output logic AUD_DACDAT);
	
	// FIR filter module io
	logic signed [15:0] in_left, in_right;
	logic input_ready, ck, rst;
	logic signed [15:0] out_left, out_right;
	logic output_ready;
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];

	/////////////////////////////////
	// This simply connects the reads and the writes together.
	// 
	/////////////////////////////////
	
	assign writedata_left = out_left;
	assign in_left = readdata_left;
	
	assign writedata_right = out_right;
	assign in_right = readdata_right;
	
	assign read = read_ready;
	assign write = write_ready;
	
	assign input_ready = read_ready;
	assign ck = CLOCK_50;
	assign rst = reset;
	assign write_ready = output_ready;
	
	// FIR filter modules

	/*
	module fir (input logic signed [15:0] in,
       input logic input_ready, ck, rst ,
       output logic signed [15:0] out,
       output logic output_ready);
	*/
	
	fir fir_left (.in(in_left), .input_ready(input_ready), .ck(ck), .rst(rst),
				.out(out_left), .output_ready(output_ready));
	fir fir_right (.in(in_right), .input_ready(input_ready), .ck(ck), .rst(rst),
				.out(out_right), .output_ready(output_ready));
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


