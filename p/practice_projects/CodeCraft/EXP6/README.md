# DebouncerLite – Verilog Design

## Problem Statement
- Need a simple hardware module to **debounce a noisy input signal**.  
- The debounced output should go high only when the input is stable high for **N consecutive clock cycles**.  
- Output resets correctly when reset is applied.  

## Use Case
- Eliminates false triggering due to switch bounce or noisy signals in digital circuits.  
- Input conditioning for push-buttons, mechanical switches, or sensors.  
- Useful in FPGA/ASIC designs to provide clean digital signals.  
- Can be integrated with state machines or event counters.  

## Design Requirements
- Inputs:  
  - `clk` – system clock (10 ns period)  
  - `rst_n` – active-low asynchronous reset  
  - `noisy_in` – noisy input signal  
- Output:  
  - `debounced` – clean, debounced output  
- Functional requirement:  
  - Output goes high only if input remains high for **N consecutive clock cycles**.  
  - Output goes low otherwise.  
  - Reset sets output to 0.  

## Design Constraints
- Works for configurable **N consecutive cycles** (parameter `N`).  
- Must operate synchronously with clock.  
- Reset is active-low asynchronous.  

## Design Methodology & Implementation
- Behavioral Verilog using `always @(posedge clk)`.  
- Input bits are shifted into an **N-bit shift register**.  
- Output goes high if all bits in the shift register are 1 (`{N{1'b1}}`).  
- Output goes low if any bit in the shift register is 0.  

## Functional Simulation & Test Cases
- Clock period = 10 ns (`always #5 clk = ~clk`).  
- VCD waveform generated for viewing in waveform viewers.  

- Test Scenarios:  
  1. Short high glitch (< N cycles) → output should remain 0  
  2. Stable high for ≥ N cycles → output goes high  
  3. Stable low for ≥ N cycles → output remains low  
  4. Rapid toggling of input → output remains stable  
  5. Long stable high → output high  
  6. Long stable low → output low  

- Simulation Monitoring:  
  - `$monitor` prints time, `noisy_in`, and `debounced` outputs.  

- Simulation Link:  
  - [EDA Playground – DebouncerLite](https://www.edaplayground.com/x/aEVr)  

## Results & Analysis
- All test vectors correctly debounced the input signal.  
- Output reflects stable high only when input is consistently high for N cycles.  
- Output remains low for glitches shorter than N cycles.  
- Reset functionality works correctly.  

## Challenges & Conclusions
- Challenges:  
  - Ensuring proper shift register operation and stable output under noisy conditions.  
  - Handling active-low reset without glitches.  

- Conclusions:  
  - DebouncerLite effectively cleans noisy input signals.  
  - Parameterizable design makes it flexible for different debounce requirements.  
  - Simple and reliable for FPGA/ASIC integration.
