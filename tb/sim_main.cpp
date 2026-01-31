#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <map>
#include <cstdint>
#include <memory>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtb_processor.h"

// Simple byte-addressable memory model
std::map<uint64_t, uint8_t> mem;

// Function to load a Verilog hex file into memory
void load_memory(const std::string& hex_file, uint64_t base_addr) {
    std::ifstream file(hex_file);
    if (!file.is_open()) {
        std::cerr << "Error: Could not open hex file: " << hex_file << std::endl;
        exit(1);
    }

    uint64_t current_addr = base_addr;
    std::string line;
    while (std::getline(file, line)) {
        if (line.empty()) continue;
        if (line[0] == '@') {
            current_addr = base_addr + std::stoull(line.substr(1), nullptr, 16);
            continue;
        }

        std::stringstream ss(line);
        unsigned int byte;
        while (ss >> std::hex >> byte) {
            mem[current_addr++] = byte;
        }
    }
}

int main(int argc, char** argv) {
    // Verilator setup
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->commandArgs(argc, argv);
    const std::unique_ptr<Vtb_processor> top{new Vtb_processor{contextp.get()}};

    // Waveform tracing setup
    VerilatedVcdC* tfp = new VerilatedVcdC;
    contextp->traceEverOn(true);
    top->trace(tfp, 99);
    tfp->open("wave.vcd");

    // Load program into memory
    load_memory("src/test.hex", 0x80000000);

    // Simulation loop
    top->reset = 1;
    top->clk = 0;
    
    uint64_t sim_time = 0;
    uint64_t max_sim_time = 1000000; // Timeout to prevent infinite loops

    while (!contextp->gotFinish() && sim_time < max_sim_time) {
        // Reset sequence
        if (sim_time < 10) {
            top->reset = 1;
        } else {
            top->reset = 0;
        }

        // Clock toggle
        top->clk = !top->clk;
        top->eval();

        // On the rising edge of the clock
        if (top->clk) {
            // Instruction fetch
            uint32_t inst = 0;
            for (int i = 0; i < 4; ++i) {
                if (mem.count(top->imem_addr + i)) {
                    inst |= (uint32_t)mem[top->imem_addr + i] << (i * 8);
                }
            }
            top->imem_rdata = inst;

            // Data memory write
            if (top->dmem_we) {
                // Check for simulation end condition
                if (top->dmem_addr == 0x10000000) {
                    std::cout << "Simulation finished." << std::endl;
                    std::cout << "Final result (written to 0x10000000): " << top->dmem_wdata << std::endl;
                    break;
                }
                // Write 64-bit data to memory
                for (int i = 0; i < 8; ++i) {
                    mem[top->dmem_addr + i] = (top->dmem_wdata >> (i * 8)) & 0xFF;
                }
            }
        }
        
        // Dump waveform and advance time
        tfp->dump(sim_time++);
    }

    // Cleanup
    tfp->close();
    top->final();
    delete tfp;

    if (sim_time >= max_sim_time) {
        std::cerr << "Simulation timed out!" << std::endl;
        return 1;
    }

    return 0;
}