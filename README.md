# UART16750

2008-2009 Sebastian Witt

Description:

Implements a synthesizable 16550/16750 UART core.

Features:

- Full synchronous design
- Pin compatible to 16550/16750
- Register compatible to 16550/16750
- Baudrate generator with clock enable
- Supports 5/6/7/8 bit characters
- None/Even/Odd parity bit generation and detection
- Supports 1/1.5/2 stop bit generation
- 16/64 byte FIFO mode
- Receiver FIFO trigger levels 1/4/8/14/16/32/56
- Control lines RTS/CTS/DTR/DSR/DCD/RI/OUT1/OUT2
- Automatic flow control with RTS/CTS
- All interrupts sources/modes

Todo:

- Variable character time-out counter
- DMA control

Tests:

A script is used to create a extensive functional stimuli file which
can be used for simulation or real-hardware testing.
The core was synthesized on a Altera Cyclone II, connected to x86
standard hardware and than tested with standard OS drivers from:

- Linux 2.2/2.4/2.6
- Windows 2000/XP/Vista
- *BSD
- *DOS

Files:

uart_16750.vhd:         Top level file
uart_receiver.vhd:      UART receiver part
uart_transmitter.vhd:   UART transmitter part
uart_baudgen.vhd:       Baudrate generator
uart_interrupt.vhd:     Interrupt register and generation

The FIFO implementation should be replaced for the specific device.
In slib_fifo.vhd is a generic FIFO (for simulation), slib_fifo_cyclone2.vhd
can be used for a Altera Cyclone II.

Rules for FIFO generation with vendor tools:

The top-word is always available at the output (no read-request/delay).

Resource usage:

    * Altera Cyclone II
          o 440 LE
          o 1216 memory bits
          o Frequency: 130 MHz

    * Xilinx Spartan 3E
          o 378 Slices
          o 1 RAMB
          o Frequency: 100 MHz

Simulation:

It's possible to simulate and test the design with GHDL [1].
A Makefile is available for starting the simulation. The testbench
creates a log file (uart_log.txt).

[1] http://ghdl.free.fr
