# 32CPU
32 bit CPU 

___
# General Architecture Design
![alt tag](https://github.com/carlosdarienvizcaino/32CPU/blob/master/documentation/GeneralArchitecture.png)
___
# Architecture Desing
![alt tag](https://github.com/carlosdarienvizcaino/32CPU/blob/master/documentation/ArchitectureDesign.png)
___ 
# State Machine Design 
![alt tag](https://github.com/carlosdarienvizcaino/32CPU/blob/master/documentation/StateMachineDesign.png)

___
# Architecture Component Descriptions:

## Datapath:
● ALU : performs all the necessary arithmetic/logic/shift operations required to implement
the MIPS instruction set (see instruction set table at end of this document). The ALU
also implements the conditions needed for branches and asserts the “Branch Taken”
output if the condition is true. The ALU should have four inputs: two for the inputs to be
processed, one for a shift amount (shown as IR[10-6]), and one for the operation select. 
You can use whatever select values you want for the operations, but I would recommend
looking over the encoding of the r-type instructions first to simplify the logic.

● Register File: 32 registers with two read ports and one write port.

● IR: The Instruction Register (IR) holds the instruction once it is fetched from memory
● PC: The Program Counter (PC) is a 32-bit register that contains the memory address of
the next instruction to be executed.

● Some special-purpose registers, including Data Memory Register, RegA, RegB,
ALUout, HI, and LO. These will be explained in lecture.

● Controller which controls all the datapath and the memory module. (The controller does
not control writing to the input ports). Note that the ALU is controlled by a separate
ALU Control unit that uses signals from both the main controller and the datapath. This
will be explained in lecture. The design of the controllers is one of the main tasks of this
project. You are welcome to add more control signals that are not shown in the datapath
figure.

● ALU Controller : controls the all the ALU Operations. This logic is up to you to figure
out, but it will become more clear after discussing the instructions in lecture.

● Memory: contains the RAM and memory-mapped I/O ports

● Sign Extended: convert a signed 16-bit input to its 32-bit representation when the signal
“isSigned” is asserted.

## CPU Controller Signals

● PCWrite: enables the PC register.

● PCWriteCond: enables the PC register if the “Branch” signal is asserted.

● IorD: select between the PC or the ALU output as the memory address.

● MemRead: enables memory read.

● MemWrite: enables memory write.

● MemToReg: select between “Memory data register” or “ALU output” as input
to “write data” signal.

● IRWrite: enables the instruction register.

● JumpAndLink: when asserted, $s31 will be selected as the write register.

● IsSigned: when asserted, “Sign Extended” will output a 32-bit sign extended
representation of 16-bit input.

● PCSource: select between the “ALU output”, “ALU OUT Reg”, or a “shifted to left
PC” as an input to PC.

● ALUOp: used by the ALU controller to determine the desired operation to be
executed by the ALU. It is up to you to determine how to use this signal. There
are many possible ways of implementing the required functionality.

● ALUSrcA: select between RegA or Pc as the input1 of the ALU.

● ALUSrcB: select between RegB, “4”, IR15-0, or “shifted IR15-0” as the input2 of
the ALU.

● RegWrite : enables the register file

● RegDst: select between IR20-16 or IR15-11 as the input to the “Write Reg”

## Other Signals

● PCWrite: enables the PC register.

● PCWriteCond: enables the PC register if the “Branch” signal is asserted.

● IorD: select between the PC or the ALU output as the memory address.

● MemRead: enables memory read.

● MemWrite: enables memory write.

● MemToReg: select between “Memory data register” or “ALU output” as input
to “write data” signal.

● IRWrite: enables the instruction register.

● JumpAndLink: when asserted, $s31 will be selected as the write register.

● IsSigned: when asserted, “Sign Extended” will output a 32-bit sign extended
representation of 16-bit input.

● PCSource: select between the “ALU output”, “ALU OUT Reg”, or a “shifted to left
PC” as an input to PC.

● ALUOp: used by the ALU controller to determine the desired operation to be
executed by the ALU. It is up to you to determine how to use this signal. There
are many possible ways of implementing the required functionality.

● ALUSrcA: select between RegA or Pc as the input1 of the ALU.

● ALUSrcB: select between RegB, “4”, IR15-0, or “shifted IR15-0” as the input2 of
the ALU.

● RegWrite : enables the register file

● RegDst: select between IR20-16 or IR15-11 as the input to the “Write Reg”



