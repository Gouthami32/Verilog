# Experiment 7 — StopTimer (FSM Stopwatch Controller)

## PROBLEM STATEMENT
Design an FSM-based stopwatch controller that handles **start**, **stop**, and **reset** operations.  
The output must show elapsed time based on clock cycles.  
The FSM must correctly handle edge transitions and user button presses.

---

## USE CASE
- Digital stopwatches
- Event duration measurement
- Embedded timing modules
- Timer controllers in microcontrollers
- FSM practice for digital design students

---

## DESIGN REQUIREMENTS
Inputs:
- clk – system clock  
- rst – asynchronous reset  
- start – begin/resume count  
- stop – pause counting  
- clear – reset elapsed count  

Output:
- elapsed[15:0] – elapsed time value

FSM States:
- **IDLE** → not counting  
- **RUNNING** → counting every clock  
- **PAUSED** → holding value  

---

## DESIGN CONSTRAINTS
- Must be implemented as a clean FSM  
- Elapsed count should increment only in RUNNING  
- Reset/clear must set elapsed = 0  
- Must support repeated start/stop cycles  
- Must avoid glitches with button edges (TB simulates pulses)

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
- FSM type: **Moore machine**
- Next-state logic depends on `start`, `stop`, `clear`
- Elapsed time increments only when in RUNNING state:
