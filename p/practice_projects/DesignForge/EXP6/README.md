# Experiment 6 — RingBuffer (FIFO of Depth 4)

## PROBLEM STATEMENT
Design a FIFO buffer with a fixed depth of 4, including write and read interfaces.  
Implement full/empty status flags and verify correct push-pop behavior, pointer wrap-around, and data integrity.

---

## USE CASE
- Message buffers  
- UART RX/TX FIFOs  
- Network packet buffers  
- Streamed data temporary storage  
- Producer-consumer architectures  

---

## DESIGN REQUIREMENTS
- FIFO depth = 4  
- Inputs:
  - clk  
  - rst  
  - write_en  
  - read_en  
  - write_data[7:0]  
- Outputs:
  - read_data[7:0]  
  - full  
  - empty  

FIFO must block:
- Writes when full  
- Reads when empty  

Must maintain correct data order (First-In First-Out).

---

## DESIGN CONSTRAINTS
- No overwriting allowed when full  
- Pointers must wrap around correctly (ring buffer)  
- FIFO must maintain count of stored elements  
- Fully synchronous except async reset  

---

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
- Two 2-bit pointers:
  - `w_ptr`: next write location  
  - `r_ptr`: next read location  
- 3-bit counter (0–4) tracks occupancy  
- Memory implemented as `mem[3:0]`  

Write operation:
