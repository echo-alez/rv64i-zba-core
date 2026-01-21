#include <verilated.h>
#include "Vtb_processor.h"

int main(int argc, char** argv) {
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->commandArgs(argc, argv);
    contextp->traceEverOn(true);

    const std::unique_ptr<Vtb_processor> top{new Vtb_processor{contextp.get()}};

    while (!contextp->gotFinish()) {
        top->eval();
        if (top->eventsPending())
            contextp->time(top->nextTimeSlot());
        else
            break; // No more events to process        
    }

    top->final();
    return 0;
}