# Experiment 9 — PulseStretch (5-Cycle Pulse Extender)

## PROBLEM STATEMENT
Design a pulse-stretching module that converts any input pulse into a fixed-width,
5-cycle output pulse. If another input pulse arrives before the previous stretched
pulse is finished, the new pulse must be ignored.

---

## USE CASE
- Debouncing short pulses
- Stretching sensor events
- Making asynchronous pulses detectable in slower domains
- Clock-to-clock event transfer
- Edge-to-level conversion

---

## DESIGN REQUIREMENTS
- Output must be HIGH for exactly **5 clock cycles**.
- Ignore any additional pulses while stretching.
- Input pulses may be 1-cycle or multiple cycles.
- Provide clear reset behavior.

Inputs:
- clk  
- rst  
- in_pulse  

Output:
- out_pulse (stretched for WIDTH=5 cycles)

---

## DESIGN CONSTRAINTS
- Must avoid retriggering during active stretch.
- Counter must precisely generate the fixed output width.
- Output transitions must align with clock edges.

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
- A simple FSM-based counter approach.
- When the first pulse arrives:
active = 1
count = WIDTH - 1
out_pulse = 1

yaml
Copy code
- Each cycle:
- If count > 0 → decrement  
- If count = 0 → stop stretching  
- New pulses are ignored until `active = 0`.

---

## FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES
Testbench covers:

### Test 1 — Single short pulse  
Output remains high for exactly 5 clocks.

### Test 2 — Pulse during stretch  
Ignored correctly.

### Test 3 — Multiple rapid pulses  
Only the first pulse starts stretching.

### Test 4 — Long input pulse  
Output still only 5 cycles.

Waveform recorded in `pulsestretch.vcd`.

---

## RESULTS & ANALYSIS
- Stretch output width always equals 5 cycles.
- No glitching even when pulses overlap.
- Counter and `active` flag behave predictably.
- TB validates all edge cases.

---

## CHALLENGES & CONCLUSIONS
### Challenges
- Preventing retriggering during stretch.
- Ensuring reliable behavior for very short pulses.

### Conclusions
PulseStretch successfully converts any input pulse into a uniform-length output
and protects against multiple triggers, making it useful in real hardware
interfaces and timing systems.
