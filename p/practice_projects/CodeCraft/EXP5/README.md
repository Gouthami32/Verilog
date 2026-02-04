# GrayCoder – Verilog Design

## Problem Statement
- Need a hardware module to convert a **4-bit binary input** into its corresponding **4-bit Gray code**.  
- Conversion must be synchronous with the clock.  
- Output should reflect the correct Gray code for any 4-bit binary input.  

## Use Case
- Digital communication systems to prevent glitches during binary-to-Gray conversion.  
- Encoder circuits for rotary encoders and position sensors.  
- FPGA/ASIC designs requiring Gray code representation for counters or state machines.  
- Educational purposes for understanding binary-to-Gray conversion.  

## Design Requirements
- Inputs:  
  - `clk` – system clock (10 ns period)  
  - `bin_in` – 4-bit binary input  
- Output:  
  - `gray_out` – 4-bit Gray code output  
- Functional requirement:  
  - MSB of Gray = MSB of binary input  
  - Remaining bits: `gray_out[i] = bin_in[i+1] XOR bin_in[i]`  
- Conversion must be synchronous with the rising edge of the clock.  

## Design Constraints
- Works for **4-bit binary inputs** only.  
- Must operate synchronously with the clock.  
- Gray code logic implemented using bitwise XOR and assignments.  

## Design Methodology & Implementation
- Behavioral Verilog using `always @(posedge clk)`.  
- Gray code output computed as:  
  - `gray_out[3] = bin_in[3]`  
  - `gray_out[2] = bin_in[3] ^ bin_in[2]`  
  - `gray_out[1] = bin_in[2] ^ bin_in[1]`  
  - `gray_out[0] = bin_in[1] ^ bin_in[0]`  
- Simple and efficient design using synchronous clock.  

## Functional Simulation & Test Cases
- Clock period = 10 ns (`always #5 clk = ~clk`).  
- VCD waveform generated (`graycoder.vcd`) for waveform viewing.  

- Test Scenarios:  
  1. Binary 0000 → Gray 0000  
  2. Binary 0001 → Gray 0001  
  3. Binary 0010 → Gray 0011  
  4. Binary 0011 → Gray 0010  
  5. Binary 0100 → Gray 0110  
  6. Binary 0101 → Gray 0111  
  7. Binary 0110 → Gray 0101  
  8. Binary 0111 → Gray 0100  
  9. Binary 1000 → Gray 1100  
  10. Binary 1001 → Gray 1101  
  11. Critical cases including repeated and boundary inputs (1010–1111).  

- Simulation Monitoring:  
  - `$display` prints time, binary input, expected Gray code, and actual Gray output.  

- Simulation Link:  
  - [EDA Playground – GrayCoder](https://www.edaplayground.com/x/Eav6)  

## Results & Analysis
- All binary inputs correctly converted to Gray code.  
- Output stable and synchronous with clock edges.  
- Design handles all 4-bit input patterns including edge and repeated cases.  
- Efficient, minimal, and reliable implementation.  

## Challenges & Conclusions
- Challenges:  
  - Ensuring correct XOR logic for each bit position.  
  - Maintaining synchronous output for all inputs.  

- Conclusions:  
  - GrayCoder reliably converts 4-bit binary numbers to Gray code.  
  - Works for all test cases and edge scenarios.  
  - Suitable for FPGA/ASIC integration and educational applications.
