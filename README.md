# Design and FPGA Implementation of a RISC-V Based Custom System-on-Chip

## Overview

This project presents the design of a customizable RISC-V based System-on-Chip (SoC) using Verilog HDL.

The SoC integrates a simplified RV32I processor core with memory, a memory-mapped bus, and multiple peripherals. The architecture is designed to demonstrate processor design, RTL development, memory-mapped communication, and FPGA-based digital system implementation.

## Architecture

The system consists of:

- RISC-V RV32I CPU
- ALU
- Register File
- Instruction Decoder
- ROM
- RAM
- Memory-Mapped Bus
- GPIO
- UART Transmitter
- Timer
- FPGA Top Module

## Memory Map

| Address | Peripheral |
|---|---|
| `0x00000000 - 0x00000FFF` | ROM |
| `0x00001000 - 0x00001FFF` | RAM |
| `0x00002000` | GPIO |
| `0x00003000` | UART |
| `0x00004000` | Timer |

## Project Structure

```text
RISC-V-Custom-SoC-FPGA/
├── rtl/
│   ├── cpu/
│   ├── memory/
│   ├── bus/
│   ├── peripherals/
│   ├── soc_top.v
│   └── fpga_top.v
├── software/
│   └── program.hex
├── tb/
│   └── soc_tb.v
├── simulation/
│   └── waveforms/
├── constraints/
│   └── fpga.xdc
└── docs/
    ├── architecture/
    └── block-diagrams/
    Verification

The design was simulated using:

Icarus Verilog
GTKWave

The following functions were verified:

Register operations
GPIO access
UART transaction
Timer operation
FPGA Implementation

The design is intended for implementation on an Artix-7 FPGA platform.

FPGA implementation includes:

RTL synthesis
Implementation
Timing analysis
Bitstream generation
Hardware testing
Tools
Verilog HDL
Icarus Verilog
GTKWave
Xilinx Vivado
Git/GitHub
Applications
Embedded processor systems
FPGA-based SoC development
Digital system design
RISC-V processor research
Hardware/software co-design