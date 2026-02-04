# SeqCheck – Rising Edge Detector with Sliding Window

## PROBLEM STATEMENT
Design a Verilog module that detects **3 rising edges** on an input signal within a **5-cycle sliding window**.  
If detected, the module asserts a `hit` output for exactly **1 clock cycle**.  

---

## USE CASE
- Event detection in digital systems (e.g., debouncing, protocol monitoring).  
- Detecting burst activity within a time frame (e.g., error bursts, signal glitches).  
- Useful in **hardware verification**, **signal monitoring**, and **safety systems**.  

---

## DESIGN REQUIREMENTS
1. **Input/Output**  
   - `clk`: System clock  
   - `rst_n`: Asynchronous active-low reset  
   - `in_sig`: Input signal  
   - `hit`: Output flag, high for 1 cycle when 3 edges within 5 cycles are detected  

2. **Detection Conditions**  
   - Rising edges only (0 → 1 transition).  
   - Window length = 5 cycles.  
   - Threshold = 3 rising edges.  

3. **Output Behavior**  
   - Assert `hit = 1` for exactly **one clock cycle** when threshold is crossed.  
   - Reset clears all history.  

---

## DESIGN CONSTRAINTS
- Must be written in **Verilog-2001** (no SystemVerilog features).  
- Latency limited to synchronizer delay (2FF).  
- Small hardware footprint (simple registers + add/sub logic).  
- Window size fixed at **W=5** and threshold **K=3**.  

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
1. **Input Synchronizer**  
   - Two flip-flops used to synchronize `in_sig` to `clk`.  
   - Prevents metastability.  

2. **Edge Detection**  
   - Rising edge detected when:  
     ```verilog
     rise = s2 & ~prev;
     ```  

3. **Sliding Window Implementation**  
   - **Ring buffer** stores last 5 rise bits.  
   - **Running sum** updated every cycle:  
     ```
     next_sum = sum - old_bit + new_rise
     ```  
   - Index pointer (`idx`) advances circularly through the buffer.  

4. **Threshold Crossing Detection**  
   - If `sum >= 3` and previous condition was false → assert `hit = 1`.  
   - Otherwise → `hit = 0`.  

---

## FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES
Simulation performed using the provided **SystemVerilog testbench** (`tb_seqcheck.sv`).

### Test Cases
1. **CASE 1:** Exactly 3 rises within 5 cycles → one `hit`.  
2. **CASE 2:** 3 rises spaced >5 cycles → no `hit`.  
3. **CASE 3:** Dense edges → multiple hits as window slides.  
4. **CASE 4:** Reset clears history.  
5. **CASE 5:** Long HIGH (only first rise counts) + two more rises → one `hit`.  
6. **CASE 6:** Alternating input → periodic hits.  
7. **CASE 7:** Constant LOW → no hits.  

---

## RESULTS & ANALYSIS
- The DUT output matches the **reference model** in all 7 test cases.  
- Waveforms confirm correct synchronization, edge detection, and threshold logic.  
- No mismatches found → simulation **PASS**.  

---

## CHALLENGES & CONCLUSIONS
### Challenges
- Implementing a **sliding window** efficiently without scanning all past cycles.  
- Avoiding off-by-one errors in the ring buffer index.  
- Ensuring only the **first crossing of threshold** generates `hit` (no multiple pulses).  

### Conclusions
- The design successfully detects 3 rising edges within a 5-cycle window.  
- Compact hardware implementation using:  
  - 2FF synchronizer  
  - Ring buffer of 5 bits  
  - Running sum (3 bits wide)  
- Can be generalized to other **W, K values** if needed.  
- Fully verified with deterministic testbench.  

---

## Simulation Link
👉 [View Simulation on EDA Playground](https://www.edaplayground.com/x/UTat)  

