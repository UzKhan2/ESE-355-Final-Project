# Project Description

The objective of the project is to complete the logic level design of a processor and then realize the layout design of the corresponding VLSI circuit. You will have to maximize the speed of your processor. 
To accomplish this goal, you will have to design fast building blocks, and then carefully lay them out. Your final design will have to fit inside the pad frame. Your design should be compact, and the amount of white space in your layout should be minimized. The I/O signals of your design will have to be connected to the I/O pads of the pad frame. 

# Project Instructions

- Decide the structure of the instruction word.
- Encode the opcodes of the 13 instructions of your processor. 
- Decide the control circuits that must be generated to the processor blocks after decoding an instruction. 
- Decide the handshaking signals between the processor and the 2 memory modules. 
- Design the register file including the decoding circuitry. 
- Design arithmetic modules for addition, comparison, shift, and rotation. 
- Design the decoder circuit. 
- Design the other registers, like PC, IR, PSR, WIR, and Result. 
- Design the processor FSM which coordinates the pipelined execution of the fetch, execute, and store phases.

# Instructions

**LD Reg, memory address**
- load instruction transfers value from the memory address to register Reg in the register file. 

**LD Reg1, Reg2**
- load instruction that transfers the content of Reg2 into Reg1. 

**LD Reg, PC**
- loads the content of register Reg into the PC counter.

**LD PC, Reg**
- loads the content of the PC counter into the register Reg of the register file.

**ADD Reg1, Reg2**
- adds the content of registers Reg1 and Reg2 and stores the result back to register Reg1, as a result, OV (overflow) and Z (zero) flags are set. 

**CMPE Reg1, Reg2**
- checks if Reg1 = Reg2, as a result, a certain EQ flag is set in register PSR. 

**CMPL Reg1, Reg2**
- checks if Reg1 < Reg2, as a result, a certain LT flag is set in register PSR. 

**SHF Reg**
- shift left the content of register Reg (i) BRZ address – branch to address if Z flag was set by the previous instruction. 

**BRE address**
- branch to address if the EQ flag was set by the previous instruction. 

**BRL address**
- branch to address if the LT flag was set by the previous instruction. 

**BROV address**
- branch to address if the IV flag was set by the previous instruction. 

**ST Reg**
- memory address stores the content of the Register into the memory location
