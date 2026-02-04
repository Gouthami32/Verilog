# LightChaser – Verilog Design

## Problem Statement
- Need a hardware module to create a **rotating LED pattern** on an N-bit LED array.  
- LEDs should rotate cyclically when enabled and reset to a default pattern when reset.  

## Use Case
- Decorative LED displays and running light effects.  
- Visual indicators for status in embedded systems.  
- Educational demonstrations of shift register and cyclic operations.  
- FPGA/ASIC designs requiring LED patterns or cyclic signal control.  

## Design Requirements
- Inputs:  
  - `clk` – system clock (10 ns period)  
  - `rst_n` – active-low reset  
  - `enable` – control signal to rotate LEDs  
- Outputs:  
  - `leds` – N-bit LED pattern  
- Functional requirement:  
  - On reset: `leds = 00000001` (LSB LED on)  
  - When `enable = 1`: LEDs rotate cyclically every clock cycle.  
  - When `enable = 0`: LED pattern holds the current state.  

## Design Constraints
- Supports **N-bit LEDs** (parameterized, default N=8).  
- Must operate synchronously with the clock.  
- Active-low reset asynchronously sets initial LED pattern.  

## Design Methodology & Implementation
- Behavioral Verilog using `always @(posedge clk or negedge rst_n)`.  
- Uses **shift register logic** to rotate LEDs:  
  - `{leds[N-2:0], leds[N-1]}` shifts the MSB to LSB cyclically.  
- Output pattern updated only when `enable` is high.  
- Reset immediately sets the pattern to LSB ON.  

## Functional Simulation & Test Cases
- Clock period = 10 ns (`always #5 clk = ~clk`).  
- VCD waveform generated (`LightChaser_tb.vcd`) for viewing in waveform viewers.  

- Test Scenarios:  
  1. Reset active → LED pattern = `00000001`  
  2. Enable high → LEDs rotate cyclically  
  3. Enable low → LEDs hold current state  
  4. Enable toggled → LEDs start/stop rotation  

- Simulation Monitoring:  
  - `$monitor` prints time, LED pattern, reset, and enable signals.  

- Simulation Link:  
  - [EDA Playground – LightChaser](https://www.edaplayground.com/x/Nn5X)  

## Results & Analysis
- LEDs rotate correctly when enabled.  
- Pattern holds steady when enable = 0.  
- Reset correctly sets LSB LED ON.  
- Cyclic rotation continues seamlessly across multiple enable cycles.  

## Challenges & Conclusions
- Challenges:  
  - Ensuring cyclic shift works correctly for parameterized N-bit width.  
  - Synchronizing enable and reset behavior without glitches.  

- Conclusions:  
  - LightChaser provides a simple and effective rotating LED pattern.  
  - Parameterizable design allows scaling to any number of LEDs.  
  - Suitable for educational, decorative, and embedded applications.
