/////////////////////////////////////////////////////////////////////
// Design unit: register
//            :
// File name  : register.sv
//            :
// Description: Code for M4 Lab exercise
//            : registers C and AQ
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Tom Kazmierski & Mark Zwolinski
//            : School of Electronics and Computer Science
//            : University of Southampton
//            : Southampton SO17 1BJ, UK
//            : mz@ecs.soton.ac.uk
//
// Revision   : Version 1.0 17/10/13
//            : modified for DE1-SoC: mz, 16/10/17
/////////////////////////////////////////////////////////////////////

module register (input logic clock, reset, add, shift, C,
              input logic[3:0] Qin, Sum, output logic[7:0] AQ);

logic Creg; // MSB carry bit storage

always_ff @ (posedge clock)
  if (reset)  // clear C,A and load Q, M
  begin
   Creg <= 0;
   AQ[7:4] <= 0;
   AQ[3:0] <= Qin; // load multiplier into Q
  end
  else if (add) // store Sum in C,A
  begin
   Creg <= C;
   AQ[7:4] <= Sum;
  end
  else if (shift) // shift A, Q
  begin
   {Creg,AQ} <= {1'b0,Creg,AQ[7:1]};
  end
endmodule
