#include <stdint.h>

volatile uint64_t mem[8];

static inline uint64_t sh1add(uint64_t rs1, uint64_t rs2) {
    uint64_t rd;
    __asm__ volatile (
        "sh1add %0, %1, %2"
        : "=r"(rd)
        : "r"(rs1), "r"(rs2)
    );
    return rd;
}

static inline uint64_t sh2add(uint64_t rs1, uint64_t rs2) {
    uint64_t rd;
    __asm__ volatile (
        "sh2add %0, %1, %2"
        : "=r"(rd)
        : "r"(rs1), "r"(rs2)
    );
    return rd;
}

static inline uint64_t sh3add(uint64_t rs1, uint64_t rs2) {
    uint64_t rd;
    __asm__ volatile (
        "sh3add %0, %1, %2"
        : "=r"(rd)
        : "r"(rs1), "r"(rs2)
    );
    return rd;
}

int main() {
    uint64_t a = 10;
    uint64_t b = 3;

    // Basic arithmetic
    uint64_t c = a + b;
    uint64_t d = a - b;

    // Memory access
    mem[0] = c;
    mem[1] = d;

    // Branching
    if (c > d) {
        mem[2] = 1;
    } else {
        mem[2] = 0;
    }

    // Zba instructions
    // sh1add: base + index*2
    uint64_t e = sh1add(a, b);

    // sh2add: base + index*4
    uint64_t f = sh2add(a, b);

    // sh3add: base + index*8
    uint64_t g = sh3add(a, b);

    mem[3] = e;
    mem[4] = f;
    mem[5] = g;

    while (1); // End simulation
}
