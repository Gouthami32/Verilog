# ByteStreamer – Serial-to-Parallel Converter

## PROBLEM STATEMENT
Design an 8-bit serial-to-parallel converter that shifts one bit per clock cycle when `shift_enable=1`. Once 8 bits have been shifted in, the module must output the full byte and assert `byte_ready` for one cycle.

## USE CASE
- UART receivers  
- SPI data capture  
- Serial communication interfaces  
- Capturing serialized sensor data  
- Digital streaming applications  

## DESIGN REQUIREMENTS
- Inputs:
  - clk (system clock)
  - rst_n (active-low reset)
  - shift_enable (controls shifting)
  - serial_in (1-bit input stream)
- Outputs:
  - parallel_out (8-bit converted output)
  - byte_ready (pulse when full byte collected)
- Shift LSB last or first depending on internal design style.
- Must reset counter and internal register on reset.

## DESIGN CONSTRAINTS
- Must collect exactly 8 bits per byte.
- Byte output must remain stable until next full byte is assembled.
- `byte_ready` must be high for only 1 clock cycle.
- No shifting must occur when `shift_enable=0`.

## DESIGN METHODOLOGY & IMPLEMENTATION DETAILS
- A shift register stores incoming bits.
- A 4-bit counter tracks how many bits have been collected.
- When counter reaches 7, the module:
  - Forms the 8-bit parallel output.
  - Pulses `byte_ready`.
  - Resets the bit counter.

Shift implementation:
```verilog
shift_reg <= {shift_reg[6:0], serial_in};
