# NibbleSwapper – Verilog Design

## Problem Statement
- Need a hardware module to **swap the lower and upper 4-bit nibbles** of an 8-bit input.  
- Must only swap when a control signal (`swap_en`) is enabled.  
- Output should **hold its previous value** if `swap_en = 0`.  
- Must reset output to 0 asynchronously when `reset = 1`.  

## Use Case
- Digital circuits where nibble rearrangement is required.  
- Byte manipulation in communication or memory-mapped systems.  
- FPGA/ASIC designs requiring conditional data transformation.  
- Applications needing controlled swapping of bits for encoding/decoding.  

## Design Requirements
- Inputs:  
  - `clk` – system clock (10 ns period)  
  - `reset` – active-high asynchronous reset  
  - `in` – 8-bit input data  
  - `swap_en` – control signal to enable swapping  
- Output:  
  - `out` – 8-bit output with swapped nibbles when `swap_en = 1`  
- Functional requirement:  
  - Swap upper 4 bits (`in[7:4]`) and lower 4 bits (`in[3:0]`) only when `swap_en = 1`.  
  - Hold previous output when `swap_en = 0`.  

## Design Constraints
- Works for **8-bit input only**.  
- Must operate synchronously with the clock.  
- Reset is asynchronous and sets `out = 0`.  
- Simple implementation using concatenation `{}` for swapping.  

## Design Methodology & Implementation
- Behavioral Verilog using `always @(posedge clk or posedge reset)`.  
- Output is reset to 0 on `reset = 1`.  
- If `swap_en = 1`, `out = {in[3:0], in[7:4]}`.  
- If `swap_en = 0`, output holds its previous value.  
- Efficient and minimal logic using concatenation operator for nibble swap.  

## Functional Simulation & Test Cases
- Clock period = 10 ns (`always #5 clk = ~clk`).  
- Asynchronous reset applied at start.  

- Test Scenarios:  
  1. Reset behavior → `out = 0`.  
  2. Normal swap → `0x71 → 0x17`.  
  3. Hold output when `swap_en = 0`.  
  4. Swap again → `0xB4 → 0x4B`.  
  5. swap_en toggling → output changes only when enabled.  
  6. Back-to-back swaps with different inputs.  
  7. Repeated input → validate repeated swap.  
  8. Edge cases: `0x00 → 0x00`, `0xFF → 0xFF`.  
  9. Glitch check → output should hold if `swap_en = 0`.  
  10. Generic test patterns (various inputs).  

- Simulation Monitoring:  
  - `$display` prints input, swap enable, and output on each clock edge.  
  - VCD waveform generated (`nibbleswapper.vcd`) for waveform viewing.  

- Simulation Link:  
  - [EDA Playground – NibbleSwapper](https://www.edaplayground.com/x/EaMW)  

## Results & Analysis
- Nibbles correctly swapped when `swap_en = 1`.  
- Output holds previous value when `swap_en = 0`.  
- Reset functionality works as expected.  
- All test cases, including edge cases and toggling, passed.  
- Simple, efficient, and reliable implementation.  

## Challenges & Conclusions
- Challenges:  
  - Ensuring output holds value correctly when `swap_en = 0`.  
  - Handling asynchronous reset cleanly.  

- Conclusions:  
  - NibbleSwapper reliably swaps nibbles when enabled.  
  - Works for all 8-bit input patterns and edge cases.  
  - Suitable for FPGA/ASIC integration in digital systems.  
