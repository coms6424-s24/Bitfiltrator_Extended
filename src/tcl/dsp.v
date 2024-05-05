module dsp ();

  parameter G_SIZE = 4;

  genvar i;
  generate
    for (i=0; i<G_SIZE; i=i+1) begin : DSP48E1_gen
      (* DONT_TOUCH = "yes" *)
      DSP48E1 #(
// Feature Control Attributes: Data Path Selection
.A_INPUT("DIRECT"), // Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
.B_INPUT("DIRECT"), // Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
.USE_DPORT("FALSE"), // Select D port usage (TRUE or FALSE)
.USE_MULT("MULTIPLY"), // Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
// Pattern Detector Attributes: Pattern Detection Configuration
.AUTORESET_PATDET("NO_RESET"), // "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH"
.MASK(48'h3fffffffffff), // 48-bit mask value for pattern detect (1=ignore)
.PATTERN(48'h000000000000), // 48-bit pattern match for pattern detect
.SEL_MASK("MASK"), // "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2"
.SEL_PATTERN("PATTERN"), // Select pattern value ("PATTERN" or "C")
.USE_PATTERN_DETECT("NO_PATDET"), // Enable pattern detect ("PATDET" or "NO_PATDET")
// Register Control Attributes: Pipeline Register Configuration
.ACASCREG(2), // Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
.ADREG(0), // Number of pipeline stages for pre-adder (0 or 1)
.ALUMODEREG(0), // Number of pipeline stages for ALUMODE (0 or 1)
.AREG(2), // Number of pipeline stages for A (0, 1 or 2)
.BCASCREG(2), // Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
.BREG(2), // Number of pipeline stages for B (0, 1 or 2)
.CARRYINREG(0), // Number of pipeline stages for CARRYIN (0 or 1)
.CARRYINSELREG(0), // Number of pipeline stages for CARRYINSEL (0 or 1)
.CREG(0), // Number of pipeline stages for C (0 or 1)
.DREG(0), // Number of pipeline stages for D (0 or 1)
.INMODEREG(0), // Number of pipeline stages for INMODE (0 or 1)
.MREG(1), // Number of multiplier pipeline stages (0 or 1)
.OPMODEREG(0), // Number of pipeline stages for OPMODE (0 or 1)
.PREG(0), // Number of pipeline stages for P (0 or 1)
.USE_SIMD("ONE48") // SIMD selection ("ONE48", "TWO24", "FOUR12")
)
DSP48E1_inst (
// Cascade: 30-bit (each) output: Cascade Ports
.ACOUT(), // 30-bit output: A port cascade output
.BCOUT(), // 18-bit output: B port cascade output
.CARRYCASCOUT(), // 1-bit output: Cascade carry output
.MULTSIGNOUT(), // 1-bit output: Multiplier sign cascade output
.PCOUT(), // 48-bit output: Cascade output
// Control: 1-bit (each) output: Control Inputs/Status Bits
.OVERFLOW(), // 1-bit output: Overflow in add/acc output
.PATTERNBDETECT(), // 1-bit output: Pattern bar detect output
.PATTERNDETECT(), // 1-bit output: Pattern detect output
.UNDERFLOW(), // 1-bit output: Underflow in add/acc output
// Data: 4-bit (each) output: Data Ports
.CARRYOUT(), // 4-bit output: Carry output
.P(), // 48-bit output: Primary data output
// Cascade: 30-bit (each) input: Cascade Ports
 .ACIN(30'b0),                      // 30-bit input: A cascade data
 .BCIN(18'b0),                      // 18-bit input: B cascade
 .CARRYCASCIN(1'b0),                // 1-bit input: Cascade carry
 .MULTSIGNIN(1'b0),                 // 1-bit input: Multiplier sign cascade
 .PCIN(48'b0),                      // 48-bit input: P cascade
 // Control inputs: Control Inputs/Status Bits
 .ALUMODE(4'b0),                    // 4-bit input: ALU control
 .CARRYINSEL(3'b0),                 // 3-bit input: Carry select
 .CLK(1'b0),                        // 1-bit input: Clock
 .INMODE(5'b0), 
 .OPMODE(7'b0), // 7-bit input: Operation mode input
.RSTINMODE(1'b0), // 1-bit input: Reset input for INMODEREG
// Data: 30-bit (each) input: Data Ports
.A(30'b0),                         // 30-bit input: A data
.B(18'b0),                         // 18-bit input: B data
.C(48'b0),                         // 48-bit input: C data
.CARRYIN(1'b0),  
.D(25'b0), // 25-bit input: D data input
// Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
.CEA1(1'b1),                       // 1-bit input: Clock enable for 1st stage AREG
.CEA2(1'b1),                       // 1-bit input: Clock enable for 2nd stage AREG
.CEAD(1'b1),                       // 1-bit input: Clock enable for ADREG
.CEALUMODE(1'b1),                  // 1-bit input: Clock enable for ALUMODE
.CEB1(1'b1),                       // 1-bit input: Clock enable for 1st stage BREG
.CEB2(1'b1),                       // 1-bit input: Clock enable for 2nd stage BREG
.CEC(1'b1),   
.CECARRYIN(1'b1),                  // 1-bit input: Clock enable for CARRYINREG
.CECTRL(1'b1),                     // 1-bit input: Clock enable for OPMODEREG and CARRYINSELREG
.CED(1'b1),   
.CEM(1'b1),                        // 1-bit input: Clock enable for MREG
.CEP(1'b1),                        // 1-bit input: Clock enable for PREG
.RSTA(1'b0),                       // 1-bit input: Reset for AREG
.RSTALLCARRYIN(1'b0), 
.RSTALUMODE(1'b0),                 // 1-bit input: Reset for ALUMODEREG
.RSTB(1'b0),                       // 1-bit input: Reset for BREG
.RSTC(1'b0),                       // 1-bit input: Reset for CREG
.RSTCTRL(1'b0),                    // 1-bit input: Reset for OPMODEREG and CARRYINSELREG
.RSTD(1'b0),                       // 1-bit input: Reset for DREG and ADREG.RSTM(RSTM), // 1-bit input: Reset input for MREG
.RSTM(1'b0),                       // 1-bit input: Reset for MREG
.RSTP(1'b0)                        // 1-bit input: Reset for PREG);
// End of DSP48E1_inst instantiation
);
    end
  endgenerate

endmodule