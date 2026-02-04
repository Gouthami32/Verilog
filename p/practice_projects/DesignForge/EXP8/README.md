# Experiment 8 — DualClockFIFO (Asynchronous FIFO Using Gray Pointers)

## PROBLEM STATEMENT
Implement a FIFO buffer that operates with two independent clocks:
- **Write clock (wclk)**
- **Read clock (rclk)**

Use **Gray-coded pointers** for safe synchronization and implement full/empty detection.  
Testbench must demonstrate correct operation with different read/write speeds.

---

## USE CASE
- UART RX/TX FIFOs  
- CDC (clock domain crossing) buffers  
- Async communication between subsystems  
- CPU → peripheral interfaces  
- Network buffers  

---

## DESIGN REQUIREMENTS
- FIFO depth = 4  
- Independent write and read clocks  
- Must use:
  - Gray-coded pointers  
  - 2-flip-flop synchronizers  
- Outputs:
  - full flag  
  - empty flag  
  - read_data  
- Prevent:
  - Writes when full  
  - Reads when empty  

---

## DESIGN CONSTRAINTS
- Binary pointers must **not** be directly sent across clock domains  
- Must avoid metastability  
- Must maintain data integrity across wrap-around  
- Full detection must use inverted MSB technique:
