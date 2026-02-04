# BitVault – 4×8 Register File

## PROBLEM STATEMENT
Create a 4×8 register file with one write port and one read port.  
The module must support:  
- Write operations using write enable  
- Immediate combinational read  
- Overwrite protection when write enable is low  
- Reset must clear all registers  

## USE CASE
- Small CPU register files  
- Storage elements in FSMs  
- Buffering in data pipelines  
- Embedded systems requiring small memory blocks  

## DESIGN REQUIREMENTS
- 4 registers, each 8 bits  
- Inputs:
  - `clk`, `rst_n`
  - `we` – write enable  
  - `waddr` – 2-bit write address  
  - `wdata` – 8-bit write data  
  - `raddr` – 2-bit read address  
- Output:
  - `rdata` – value at read address  
- Write only when `we=1`  
- Read is always available (combinational)  

## DESIGN CONSTRAINTS
- Writes must never occur when `we=0`  
- Reset must clear all registers consistently  
- Read must behave without glitches  

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
- Storage implemented as a 4-element reg array  
- Async reset clears all memory locations  
- Write logic inside clocked block  
- Read logic implemented via continuous assignment  
- Supports randomized access patterns  

## FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES
Testbench verifies:
1. Reset clears all registers  
2. Writing to each address  
3. Reading back all values  
4. Ensuring no overwrite when `we=0`  
5. Random read/write stress test  

Simulation uses:
- 10 ns clock  
- `$monitor` for real-time value tracking  
- VCD waveform generation  

## RESULTS & ANALYSIS
- All writes occur correctly when `we=1`  
- No data corruption when `we=0` (overwrite protection works)  
- Combinational read outputs correct values instantly  
- Randomized operations behaved as expected  

## CHALLENGES & CONCLUSIONS
### Challenges
- Ensuring stable combinational reads  
- Preventing unintended writes  

### Conclusions
BitVault register file functions correctly for all test conditions.  
It is lightweight, efficient, and ready for integration into digital systems.
