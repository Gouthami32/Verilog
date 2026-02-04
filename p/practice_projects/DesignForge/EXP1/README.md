# SmartCounter

## PROBLEM STATEMENT
Design an 8-bit counter with load, enable, and reset functionality.  
- When load is active, the counter must load an external value.  
- When enable is active, the counter increments every clock cycle.  
- Reset should asynchronously clear the counter.  

The design must behave correctly under various sequences of load, enable, and reset.

---

## USE CASE
- Digital timers and stopwatches  
- Address generators  
- Event counters  
- Loop iteration hardware in pipelines  
- Configurable counters in FPGA/ASIC modules  

---

## DESIGN REQUIREMENTS
- 8-bit output counter  
- Inputs:
  - `clk` → system clock  
  - `rst_n` → active-low asynchronous reset  
  - `load` → loads `load_val` into counter  
  - `enable` → increments counter  
  - `load_val` → 8-bit value to load  
- Load has priority over enable  
- Reset clears output to 0  

---

## DESIGN CONSTRAINTS
- Must operate reliably under rapid enable/load transitions  
- Must avoid race conditions during async reset  
- Load and increment must be synchronous to the clock  

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
- RTL uses a synchronous always block with async reset  
- Priority order:
  1. Reset  
  2. Load  
  3. Increment  
- Counter increments using simple binary addition  
- Reset implemented using `negedge rst_n` for instant clearing  

---

## FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES
**Clock:** 10 ns period  
**Simulation:** Verifies following scenarios:

### **Test Cases**
1. **Reset test** → counter becomes 0  
2. **Load operation** → counter loads exact value  
3. **Increment operation** → counter increments for multiple cycles  
4. **Hold behavior** → when enable=0, counter freezes  
5. **Load during run** → load overrides increment  
6. **Final reset** → counter returns to 0  

Waveforms captured using VCD.

---

## RESULTS & ANALYSIS
- Counter increments correctly only when enable=1  
- Counter loads value correctly and immediately on load=1  
- Load operation overrides increment  
- Reset reliably clears count to 0  
- No unexpected glitches or incorrect transitions observed  

---

## CHALLENGES & CONCLUSIONS
### Challenges
- Ensuring correct priority order (Reset > Load > Enable)  
- Avoiding misbehavior when load and enable toggle in the same clock cycle  

### Conclusions
- SmartCounter performs reliably under all tested scenarios  
- Ready for integration into larger digital systems  
- Demonstrates correct synchronous counter behavior with async reset  
