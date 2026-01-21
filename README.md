# RV64I-Zba: 5-Stage RISC-V 64-bit Processor
A synthesizable 64-bit RISC-V processor core implementing the RV64I base integer ISA with support for the Zba (Address Generation) bit-manipulation extension.
The design follows a classic 5-stage in-order pipeline, prioritizing clarity, correctness, and verifiability.

This project is intended for educational, research, and verification purposes, with a complete RTL → software → simulation flow.

---

## Features
- ISA: RV64I (Base Integer Instruction Set)
- Extension: Zba (Address Generation)
  - sh1add, sh2add, sh3add
- Microarchitecture:
  - 5-stage in-order pipeline
  - Harvard architecture (separate instruction & data memories)
  - Single-issue
  - Static not-taken branch policy
- Exclusions:
  - No CSRs
  - No interrupts
  - No privilege modes
  - No virtual memory

---

## Zba Supported Instructions
| Instruction	| Semantics |
|-------------|-----------|
| `sh1add`    | `rs1 + (rs2 << 1)` |
| `sh2add`    |	`rs1 + (rs2 << 2)` |
| `sh3add`    |	`rs1 + (rs2 << 3)` |

The Zba extension is implemented as dedicated ALU operations integrated into the execute stage.


## Architecture Overview

### Pipeline Stages

The processor follows a classic [**5-stage in-order pipeline**](https://en.wikipedia.org/wiki/Classic_RISC_pipeline):

1. **IF — Instruction Fetch**: Fetches the instruction from instruction memory using the program counter.

2. **ID — Instruction Decode / Register Read**: Decodes the instruction, reads source registers, and generates control signals.

3. **EX — Execute / Address Generation**: Performs arithmetic and logical operations, branch evaluation, and Zba address generation instructions.

4. **MEM — Data Memory Access**: Executes load and store operations on data memory.

5. **WB — Write Back**: Writes computation or memory results back to the register file.


### Hazard Handling

To maintain correct execution while minimizing stalls, the following mechanisms
are implemented:

- **Data Forwarding**
  - EX → EX forwarding
  - MEM → EX forwarding

- **Pipeline Stalling**
  - Load-use hazards are detected and resolved by inserting a stall when an
    instruction depends on a value being loaded in the immediately preceding cycle.

---


## Project Structure

```text
project
├── rtl/
│ ├── rv64_core.sv # Top-level processor module
│ ├── alu.sv # ALU with Zba support
│ ├── regfile.sv # 32x64-bit register file
│ ├── control.sv # Instruction decode and control logic
│ └── pipeline_regs.sv # IF/ID, ID/EX, EX/MEM, MEM/WB registers
│
├── tb/
│ └── tb_processor.sv # Self-checking SystemVerilog testbench
│
├── software/
│ ├── test.c # C test program exercising RV64I + Zba
│ ├── test.s # Generated assembly (for inspection)
│ ├── test.elf # Linked ELF binary
│ ├── test.hex # Machine code for simulation
│ └── linker.ld # Bare-metal linker script
│
├── docs/
│ └── design.pdf # Datapath and pipeline diagram
│
├── build_commands.txt # Toolchain commands
└── README.md
```
---

## Software Toolchain

The processor executes bare-metal software, compiled specifically for the
supported ISA configuration.

### Compiler and Target

- Compiler: riscv64-unknown-elf-gcc
- ISA: rv64i_zba
- ABI: lp64

### Toolchain Notes

- GNU GCC does not provide built-in intrinsics for Zba instructions.
- Zba operations are emitted using inline assembly.
- Assembly inspection confirms native sh1add, sh2add, and sh3add instructions.


## Building the Test Program
```bash
# Compile C to Assembly:
riscv64-unknown-elf-gcc \
  -march=rv64i_zba \
  -mabi=lp64 \
  -O0 \
  -S test.c -o test.s

# Assemble
riscv64-unknown-elf-as test.s -o test.o

# Linker (Bare-Metal)
riscv64-unknown-elf-ld -T linker.ld test.o -o test.elf

# Generate Memory Image
riscv64-unknown-elf-objcopy -O verilog test.elf test.hex
```

## Simulation (Verilator)
```bash
# Build the Simulation Executable
verilator -Wall --sv --timing --trace \
  --cc tb/tb_processor.sv rtl/*.sv \
  --top-module tb_processor \
  --exe tb/sim_main.cpp

make -C obj_dir -f Vtb_processor.mk -j

# Run the Simulation
./obj_dir/Vtb_processor

# View Waveforms
gtkwave wave.vcd
```
---

## Verification Strategy

The testbench performs the following steps:
- Loads test.hex into instruction memory
- Applies reset for several cycles
- Allows the program to execute until it reaches an infinite loop

The following behaviors are automatically verified:
- Correct arithmetic execution
- Correct load/store behavior
- Correct branch handling
- Correct execution of Zba instructions

## Expected Results
| Memory Index  | Expected Value |
|---------------|----------------|
| mem[3]        |	16 (sh1add)    |
| mem[4]	      | 22 (sh2add)    |
| mem[5]	      | 34 (sh3add)    |

If all checks pass, the simulation terminates successfully.
