# EvenOddFSM – Verilog Design

## Problem Statement
- Need a hardware module to determine whether an 8-bit input number is **even or odd**.  
- Only valid input (`in_valid = 1`) should be considered.  
- Output must reset correctly and hold previous values if input is not valid.  

## Use Case
- Digital number classification for even/odd detection.  
- Arithmetic and control applications in FPGA/ASIC designs.  
- Input validation and digital signal processing.  
- Educational examples for FSM-based decision making.  

## Design Requirements
- Inputs:  
  - `clk` – system clock (10 ns period)  
  - `reset` – active-high asynchronous reset  
  - `in_valid` – input valid signal  
  - `data_in` – 8-bit input number  
- Outputs:  
  - `even` – high if input is even  
  - `odd` – high if input is odd  
- Functional requirement:  
  - If `in_valid = 1`, determine parity using LSB (`data_in[0]`)  
  - If `in_valid = 0`, outputs hold their previous state  
  - Reset sets both outputs to 0  

## Design Constraints
- Works for **8-bit input numbers** only.  
- Must operate synchronously with the clock.  
- Reset is asynchronous and sets outputs to 0.  
- Only one-hot output: either `even = 1` or `odd = 1` at a time.  

## Design Methodology & Implementation
- Behavioral Verilog using `always @(posedge clk or posedge reset)`.  
- If `reset = 1`, outputs cleared to 0.  
- If `in_valid = 1`, parity is determined by checking LSB:  
  - `data_in[0] = 0 → even = 1, odd = 0`  
  - `data_in[0] = 1 → even = 0, odd = 1`  
- If `in_valid = 0`, outputs retain previous state.  

## Functional Simulation & Test Cases
- Clock period = 10 ns (`always #5 clk = ~clk`).  
- Reset applied at start.  

- Test Scenarios:  
  1. Input 0 → even  
  2. Input 1 → odd  
  3. Input 2 → even  
  4. Maximum value 255 → odd  
  5. Input 128 → even (MSB set)  
  6. Input 127 → odd  
  7. Input 254 → even  
  8. `in_valid = 0` → outputs hold previous values  
  9. Generic inputs 10–16 → even/odd classification  

- Simulation Monitoring:  
  - `$display` prints time, input value, `in_valid`, `even`, `odd`, and expected output.  
  - VCD waveform generated (`evenoddfsm.vcd`) for waveform viewing.  

- Simulation Link:  
  - [EDA Playground – EvenOddFSM](https://www.edaplayground.com/x/bdbv)  

## Results & Analysis
- All test vectors produced correct even/odd outputs.  
- Outputs hold previous values when `in_valid = 0`.  
- Reset functionality works correctly.  
- Reliable FSM behavior for all 8-bit input patterns.  

## Challenges & Conclusions
- Challenges:  
  - Correctly handling input validation (`in_valid`) to prevent unwanted output changes.  
  - Ensuring asynchronous reset works while maintaining FSM logic.  

- Conclusions:  
  - EvenOddFSM correctly identifies parity for 8-bit numbers.  
  - Outputs are robust, reliable, and suitable for FPGA/ASIC integration.  
  - Simple FSM-based design for parity detection and educational purposes.
