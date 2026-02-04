# BitBalancer – Verilog Design

## Problem Statement
- Counting the number of 1s in a binary input stream is a common digital requirement.  
- Need a hardware module that efficiently counts the number of high bits in an 8-bit input.  
- Must reset correctly and handle any input combination reliably.  

## Use Case
- Digital signal processing requiring population count (number of 1s).  
- Error detection/correction schemes in communication systems.  
- Hardware monitoring for bit occupancy or resource utilization.  
- FPGA/ASIC designs where bit analysis is required.  

## Design Requirements
- Inputs:  
  - `clk` – system clock (10 ns period)  
  - `reset` – synchronous reset signal  
  - `in` – 8-bit input bit stream  
- Output:  
  - `count` – 4-bit output representing number of 1s in input  
- Must count all 1s correctly for any input pattern.  
- Should reset count to 0 when `reset = 1`.  

## Design Constraints
- Works for **8-bit input stream only**.  
- Counter width = 4 bits (`count[3:0]`) to handle max value of 8.  
- Must operate synchronously with clock.  
- Efficient and simple implementation without additional modules.  

## Design Methodology & Implementation
- **Behavioral Verilog** with `always @(posedge clk or posedge reset)`  
- Loop through all 8 input bits using a `for` loop.  
- Increment a temporary variable `temp` for each high bit detected.  
- Assign `temp` to output `count` every clock cycle.  
- Reset clears `count` and `temp` to 0.  

## Functional Simulation & Test Cases
- Clock period = 10 ns (`always #5 clk = ~clk`)  
- Reset applied at the start to initialize the DUT.  

- Test Cases:  
  1. All zeros → count = 0  
  2. All ones → count = 8  
  3. Single 1 at LSB → count = 1  
  4. Single 1 at MSB → count = 1  
  5. Alternating ones → count = 4  
  6. Cluster in middle → count = 4  
  7. Upper/lower nibbles → count = 4  
  8. Sparse bits → count = 1 or 2  
  9. Balanced mixed patterns → count = 4 or 6  
  10. Reset test → count = 0  

- Simulation Monitoring:  
  - `$monitor` prints `time`, `reset`, `in`, and `count` every clock edge.  
  - VCD waveform generated (`bitbalancer.vcd`) for waveform viewing.  

- Simulation Link:  
  - [EDA Playground – BitBalancer](https://www.edaplayground.com/x/npXp)  

## Results & Analysis
- All test vectors produced correct output counts.  
- Reset functionality works as expected.  
- Handles all 8-bit patterns, including edge and mixed cases.  
- Efficient, simple, and reliable design.  

## Challenges & Conclusions
- Challenges:  
  - Correctly looping through all bits and ensuring synchronous assignment  
  - Maintaining correct output during reset and input changes  

- Conclusions:  
  - BitBalancer correctly counts the number of 1s in any 8-bit input  
  - Works for all test cases and edge scenarios  
  - Suitable for FPGA/ASIC integration and digital applications
