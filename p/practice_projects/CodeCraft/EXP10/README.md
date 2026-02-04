# EdgeHighlighter – Verilog Design

## Problem Statement
- Detect rising and falling edges of a digital input signal.  
- Generate **one-cycle pulses** for each rising (0→1) and falling (1→0) edge.  
- Support **asynchronous active-low reset**.  

## Use Case
- Signal synchronization and edge detection in digital systems.  
- Event-triggered logic (e.g., timers, counters, interrupts).  
- Interfacing with external sensors that produce asynchronous signals.  

## Design Requirements
- Inputs:  
  - `clk` – system clock  
  - `rst_n` – async active-low reset  
  - `in_sig` – input signal to detect edges  
- Outputs:  
  - `rise_pulse` – 1-cycle high when rising edge occurs  
  - `fall_pulse` – 1-cycle high when falling edge occurs  

- Functional Requirements:  
  - On reset (`rst_n = 0`): `rise_pulse = fall_pulse = 0`  
  - On rising edge (`in_sig` changes 0→1): `rise_pulse = 1` for 1 cycle  
  - On falling edge (`in_sig` changes 1→0): `fall_pulse = 1` for 1 cycle  
  - Pulses must be **mutually exclusive**  

## Design Methodology & Implementation
- Behavioral Verilog using `always @(posedge clk or negedge rst_n)`  
- Temporary register `prev` stores previous value of `in_sig`  
- Pulse generation:  
  - `rise_pulse = in_sig & ~prev`  
  - `fall_pulse = ~in_sig & prev`  
- Optional 2-flip-flop synchronization for metastability mitigation when `USE_SYNC = 1`  

## Functional Simulation & Test Cases
- Clock: 100 MHz (`CLK_NS = 10ns`)  
- VCD waveform: `edgehighlighter_tb.vcd`  
- Test Scenarios:  
  1. Single 1-cycle pulse → expect one rise and one fall  
  2. Wide high pulse (≥1 cycles) → only one rise at start, one fall at end  
  3. Back-to-back pulses separated by 1-cycle low → detect each edge correctly  
  4. Long low period → no pulses  
  5. Alternate input every cycle (…010101…) → alternating rise/fall pulses  
  6. Mid-stream reset → history cleared; edges detected fresh after reset  

- Assertions ensure no simultaneous rise and fall pulses  

## Results & Analysis
- DUT correctly detects rising and falling edges  
- Generates one-cycle pulses as expected  
- Optional 2FF synchronizer ensures metastability mitigation for asynchronous inputs  
- Reset correctly clears history  

## Challenges & Conclusions
- Challenges:  
  - Avoiding double pulses when input changes rapidly  
  - Ensuring mutual exclusivity of rise/fall pulses  
- Conclusions:  
  - EdgeHighlighter is robust for detecting edges and generating single-cycle pulses  
  - Suitable for FPGA/ASIC designs needing edge-triggered events  
