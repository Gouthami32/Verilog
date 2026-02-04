# RotatorUnit – Verilog Design

## Problem Statement
- Implement an **8-bit (parametric) rotate register** that can rotate left or right depending on a control signal.  
- Register should support synchronous **load**, enable gating, and active-low reset.  
- Rotate operations must continue only when enabled, and the register holds state otherwise.  

## Use Case
- Circular shift operations in digital signal processing.  
- Data manipulation and alignment in embedded systems.  
- LED pattern rotation or simple hardware-based FIFO manipulations.  
- General-purpose FPGA and ASIC designs needing controlled shift registers.  

## Design Requirements
- Inputs:  
  - `clk` – system clock  
  - `rst_n` – async active-low reset  
  - `enable` – gate signal to start/stop rotation  
  - `load` – synchronous load signal  
  - `dir` – rotation direction (0 = left, 1 = right)  
  - `data_in` – 8-bit input data for loading  
- Outputs:  
  - `data_out` – 8-bit rotated output  

- Functional Requirements:  
  - On reset (`rst_n = 0`): `data_out = 0`  
  - If `enable = 1` and `load = 1`: load `data_in` to `data_out`  
  - If `enable = 1` and `load = 0`: rotate `data_out` by 1 in the direction specified by `dir`  
  - If `enable = 0`: hold the current state  

## Design Constraints
- Parameterizable width (default 8-bit)  
- Rotation direction controlled synchronously  
- Load and rotation gated by `enable`  

## Design Methodology & Implementation
- Behavioral Verilog using `always @(posedge clk)`  
- Conditional logic for **reset, load, enable, and direction**  
- Uses concatenation operator for rotation:  
  - Left rotate: `{data_out[6:0], data_out[7]}`  
  - Right rotate: `{data_out[0], data_out[7:1]}`  
- Checker implemented in testbench for reference model (`rol1` and `ror1`)  
- Parameterizable for scalability  

## Functional Simulation & Test Cases
- Clock: 100 MHz (`CLK_NS = 10ns`)  
- VCD waveform: `rotatorunit_tb.vcd` for waveform viewing  
- Test Scenarios:  
  1. Reset behavior → `data_out = 0`  
  2. Load input while enable = 1  
  3. Rotate left several cycles  
  4. Rotate right several cycles  
  5. Enable = 0 → hold current state  
  6. Toggle rotation direction  
  7. Attempt load with enable = 0 → ignored  
  8. Load all zeros → rotation stays zero  
  9. Load all ones → rotation remains all ones  
  10. Wrap-around check → rotating full width returns original value  

- Assertions and `$fatal` ensure DUT matches reference model  

- Simulation Link:  
  - [EDA Playground – RotatorUnit](https://www.edaplayground.com/x/Qdxc)  

## Results & Analysis
- DUT correctly rotates data left and right based on `dir`  
- Load operation works synchronously and overrides rotation  
- Enable = 0 holds the current state reliably  
- Reset asynchronously clears register  
- Wrap-around behavior verified for full rotation cycles  

## Challenges & Conclusions
- Challenges:  
  - Correctly sequencing load, enable, and rotate logic  
  - Handling wrap-around without glitches  
  - Parameterization for scalable bit-width  

- Conclusions:  
  - RotatorUnit is robust and fully functional for 8-bit or parameterized widths  
  - Suitable for digital design projects needing rotation, load, and controlled enable  
  - Checker in testbench ensures correctness through automated assertions
