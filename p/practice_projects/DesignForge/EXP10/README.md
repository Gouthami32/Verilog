# Experiment 10 — ModeMux (4-Input Multiplexer with Dual Arbitration Modes)

## PROBLEM STATEMENT
Design a multiplexer that selects one of four inputs (I0–I3) based on request lines.  
The module must support two arbitration modes:
1. Fixed Priority (I0 > I1 > I2 > I3)
2. Round Robin Priority (rotating fairness)

The testbench must demonstrate:
- Mode switching
- Simultaneous requests
- Sequential arbitration correctness

---

## USE CASE
- Shared bus arbitration  
- Multi-master communication systems  
- Routers, network switches  
- CPU resource sharing (DMA, memory buses)  
- Fair scheduling mechanisms  

---

## DESIGN REQUIREMENTS
- Inputs:  
  - clk, rst  
  - mode (0=fixed, 1=round-robin)  
  - req[3:0]  
  - data_in[0..3] each 8-bit  

- Outputs:  
  - grant[3:0] one-hot  
  - data_out[7:0]  

- Round robin must maintain **fairness**  
- Fixed priority always favors I0 first  

---

## DESIGN CONSTRAINTS
- Only one grant active per cycle  
- Round robin pointer updates **only when a grant occurs**  
- Must handle simultaneous requests correctly  
- No starvation in round-robin mode  

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
### Mode = 0 → Fixed Priority
Priority order:
I0 → I1 → I2 → I3

yaml
Copy code
If multiple requesters assert simultaneously, the highest priority wins.

### Mode = 1 → Round Robin
Uses a rotating pointer `rr_ptr` (0..3).  
Pointer only increments **after a successful grant**, ensuring fairness.

### Data Routing
Grant selects which 8-bit data passes to `data_out`.

---

## FUNCTIONAL SIMULATION METHODOLOGY & TEST CASES
### Test Cases Performed
1. **Fixed Mode:**
   - All requests active → I0 selected  
   - Partial requests → highest priority selected  
2. **Round Robin Mode:**
   - All requests active → selection rotates 0→1→2→3→0...  
   - Random request patterns  
3. **Mode Switching:**
   - Switch from fixed → round robin mid-simulation  

Waveform: `modemux.vcd`

---

## RESULTS & ANALYSIS
- Fixed priority always selects I0 first correctly.  
- Round robin rotates fairness without skipping entries.  
- No two grants active at once.  
- Data integrity maintained for all request patterns.

---

## CHALLENGES & CONCLUSIONS
### Challenges
- Managing round-robin fairness correctly  
- Avoiding unnecessary pointer increments  
- Stable priority resolution logic  

### Conclusions
ModeMux successfully implements a dual-mode arbitration multiplexer suitable for bus arbitration and scheduling systems.  
It behaves deterministically in fixed mode and fairly in round-robin mode.
