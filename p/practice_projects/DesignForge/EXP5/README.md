# SafeALU – 8-bit Arithmetic Logic Unit

## PROBLEM STATEMENT
Design an 8-bit ALU capable of performing ADD, SUB, AND, and OR operations.  
It must also generate three status flags:  
- **Zero (Z)**  
- **Carry (C)**  
- **Overflow (V)**  

The ALU must correctly detect arithmetic overflow and update flags accordingly.

---

## USE CASE
- CPU datapaths  
- Embedded arithmetic units  
- Digital signal processing  
- Microcontroller-style ALU behavior  
- Students learning computer architecture concepts  

---

## DESIGN REQUIREMENTS
- Inputs:
  - A, B → 8-bit operands  
  - OP → selects operation  
- Outputs:
  - R → 8-bit result  
  - Z → 1 when result is zero  
  - C → Carry/borrow flag for ADD/SUB  
  - V → Signed overflow flag  
- Supported operations:
  - 00 → ADD  
  - 01 → SUB  
  - 10 → AND  
  - 11 → OR  

---

## DESIGN CONSTRAINTS
- Must detect **carry-out** for addition  
- Must detect **borrow** for subtraction  
- Must compute **signed overflow**  
- Flags must be valid for all operations  
- Pure combinational ALU (no clock or storage elements)  

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
- `temp` is a 9-bit temporary register used to detect carry.  
- Overflow logic implemented using signed overflow formula:  
  - ADD Overflow:  
    `(~A[7] & ~B[7] & R[7]) | (A[7] & B[7] & ~R[7])`  
- Zero flag is updated after all operations.  
- AND/OR operations do not affect carry/overflow.  

---

## FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES
Testbench validates:

### **Arithmetic tests**
- ADD without carry  
- ADD with carry  
- ADD with overflow  
- SUB without borrow  
- SUB with borrow  
- SUB with overflow  

### **Logical tests**
- A & B  
- A | B  

### **Flag tests**
- Zero flag behavior  
- Carry flag correctness  
- Signed overflow correctness  

Waveform output is saved in `safealu.vcd` for inspection.

---

## RESULTS & ANALYSIS
- ADD and SUB correctly update C and V flags.  
- Logical operations behave as expected.  
- Zero flag correctly detects result = 0.  
- Overflow cases validated and working.  
- ALU behaves exactly as expected for 8-bit signed/unsigned arithmetic.

---

## CHALLENGES & CONCLUSIONS
### Challenges
- Correct overflow logic for signed numbers  
- Borrow interpretation for subtraction  
- Ensuring flags update correctly for all modes  

### Conclusions
SafeALU is a fully functional arithmetic unit supporting core operations with accurate flag behavior.  
It is suitable for CPU datapath design, digital logic courses, and FPGA learning experiments.
