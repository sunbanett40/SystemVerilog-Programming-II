/////////////////////////////////////////////////////////////////////
// Design unit: sequencer
//            :
// File name  : sequencer.sv
//            :
// Description: Code for M4 Lab exercise
//            : Outline code for sequencer
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : 
//            : School of Electronics and Computer Science
//            : University of Southampton
//            : Southampton SO17 1BJ, UK
//            : 
//
// Revision   : Version 1.0 
/////////////////////////////////////////////////////////////////////

module sequencer (input logic start, clock, Q0, n_rst,
 output logic add, shift, ready, reset);

logic count_flag;
logic [2:0] count = 3'b100;
 
enum {idle, adding, shifting, stopped} present_state, next_state;

always_ff @(posedge clock, negedge n_rst)
    begin: SEQ                              //Sequential label for modelsim
        if (!n_rst)                         //Reset
            present_state <= idle;
        else                                //Update state on clockedge
            present_state <= next_state;
    end
 
always_comb
    begin: COM                              //Combinational label for modelsim
 
        //Set default values of output
        add = '0;
        shift = '0;
        ready = '0;
        reset = '0;
 
        unique case (present_state)         //Unique case label gives compiler error if a state is missing
            idle : begin
                reset = '1;               //Assert unconditional output
                if (start)                  //Conditional to progress to next state
                    next_state = adding;
                else                        //Else stay in ready state
                    next_state = idle;
            end
            adding : begin
                count <= count-1;           //update count
                if (Q0)                     //Conditional to progress to next state
                    add = '1;               //Assert conditional output
                next_state = shifting;
            end
            shifting : begin
                shift = '1;                 //Assert unconditional output
                if (count > 0)              //Conditional to progress to next state
                    next_state = adding;
                else                        //Else stay in ready state
                    next_state = stopped;
            end
            stopped : begin
                ready = '1;                 //Assert unconditional output
                if (start)                  //Conditional to progress to next state
                    next_state = idle;
                else                        //Else stay in ready state
                    next_state = stopped;
            end
        endcase
    end  
endmodule
