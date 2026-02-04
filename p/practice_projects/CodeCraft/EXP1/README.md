# PulseTracer – Verilog Design

## Problem Statement
- Digital input signals often contain noise or glitches (e.g., switch bounce).  
- False triggers may occur if glitches are treated as valid inputs.  
- A filtering mechanism is required to detect only stable high signals for a specific number of consecutive clock cycles.  

## Use Case
- Switch/button debouncing in digital circuits and microcontrollers.  
- Noise filtering in FPGA/ASIC input signals.  
- Valid pulse detection in communication and sensor systems.  
- Event detection where spurious inputs must be ignored.  

## Design Requirements
- Inputs:  
  - `clk` – system clock (10 ns period)  
  - `rst_n` – active-low asynchronous reset  
  - `noisy_in` – noisy input signal  
- Output:  
  - `pulse_out` – goes high for 1 clock cycle on valid detection  
- Parameter:  
  - `FILTER_LEN` – number of consecutive high cycles required (default = 3)  

## Design Constraints
- Counter width = `$clog2(FILTER_LEN)`  
- Output latency = `FILTER_LEN` clock cycles  
- Async reset must clear both counter and output  
- Only one output pulse per valid input sequence  
- Must ignore glitches shorter than `FILTER_LEN`  

## Design Methodology & Implementation
- Counter-based design:  
  - Increment counter when `noisy_in = 1`  
  - Reset counter when `noisy_in = 0`  
- Pulse generation:  
  - When counter = `FILTER_LEN-1`, assert `pulse_out = 1` for 1 clock cycle  
- Reset logic:  
  - Async reset (`rst_n = 0`) clears counter and output  
- Parameterization:  
  - `FILTER_LEN` is configurable for different applications  
- Implemented in behavioral Verilog using `always @(posedge clk or negedge rst_n)`  

## Functional Simulation & Test Cases
- Simulation Setup:  
  - Clock period = 10 ns (`CLK_PERIOD = 10`)  
  - Active-low reset applied at start (`rst_n = 0`)  
  - Parameter `FILTER_LEN = 3`  

- Test Scenarios:  
  1. Short glitch (< FILTER_LEN) → No pulse generated  
  2. Stable high for FILTER_LEN cycles → Output pulse = 1 for 1 cycle  
  3. Alternating glitches → No pulse triggered  
  4. Back-to-back valid pulses → Two separate pulses detected  
  5. Long held high → Only one pulse generated  
  6. Glitch during FILTER_LEN build-up → Pulse triggers after valid sequence  
  7. Random noise + controlled pulse → Only controlled pulse detected  

- Simulation Monitoring:  
  - `$display` prints time, `noisy_in`, and `pulse_out` at each clock edge  
  - VCD waveform generated (`pulse_tracer_full.vcd`)  

- Simulation Link:  
  - [EDA Playground – PulseTracer](https://www.edaplayground.com/x/QJNT)  

## Results & Analysis
- Short glitches ignored successfully  
- Valid pulses detected exactly after `FILTER_LEN` cycles  
- Output pulse width = 1 clock cycle  
- Works correctly for parameterized filter lengths  
- Testbench confirms all expected scenarios  

## Challenges & Conclusions
- Challenges:  
  - Handling async reset without glitches  
  - Balancing responsiveness (low `FILTER_LEN`) and noise immunity (high `FILTER_LEN`)  

- Conclusions:  
  - PulseTracer is robust, reusable, and efficient  
  - Provides reliable filtering for noisy digital inputs  
  - Suitable for FPGA/ASIC implementation  
  - Simple, parameterized, and adaptable to various applications
