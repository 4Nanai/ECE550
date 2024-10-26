# CheckPoint 5 (Probably)

**probably has lots of bug!**

## Todos

- [x] Program Counter
- [x] Instruction Register (not used but prepared for pipeline)
- [x] Decoder
- [x] Sign Extension
- [x] Instruction Memory
- [x] Data Memory

#### Inside Datapath

- [x] R-type Instruction
- [x] addi (Add Immediate Number)
- [x] sw (Store Word)
- [x] lw (Load Word)
- [x] beq (Jump to *pc + 1 + N* if dataA == dataB) (Validate)
- [x] blt (Jump to *pc + 1 + N* if dataA < dataB) (Not validate)
- [x] ji (Jump Immediate Number)  (Not validate)
- [x] jal (Store *pc + 1* &  Jump Immediate Number) (Not validate)
- [x] jr (Jump to addr register $rd point to) (Not validate)
- [ ] bex
- [ ] setx
- [x] Testbench
