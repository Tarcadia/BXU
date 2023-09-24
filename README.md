# BXU

## Intro

This processing unit is implemented using 16-bit code bit-width and 8-bit data bit-width in Harvard Architecture based on an extension of [Brainfuck](https://wikipedia.org/wiki/Brainfuck) with a UART as IO.

This project is based on my first attempt at writing a processing unit years ago and this new implementation freshens up the project without requiring the use of data and code belts or any other dedicated peripherals. Another main change is that this reimplementation fixes most timing issues in that it can run on a chip rather than simulating. What's more, the extended ISA makes BF not that stubborn so this BXU can really do some complex work now (though not that complex).



## ISA

Here is the ISA of the BF extension.

BIT ORDER : HSB F E D C BA987654 3210 LSB

In most cases, we suggest the bits representing that

- bit[F] represents adding or subbing.
- bit[E] reserved.
- bit[D] represents using inst val or using memory val.
- bit[C] represents lower bits or higher bits operating.
- inst val is [B:4] or [E:4] or [F:4].
- bits[3:0] is op code.

### NOP

- nop: nop:

    X X X X XXXXXXXX 0000

### DATA

Data operations, inc/dec/set the pointed memory.

- dinc: [s] += #inst:
  
    0 0 0 0 ##inst## 0010
  
- ddec: [s] -= #inst:
  
    1 0 0 0 ##inst## 0010
  
- dset: [s] = #inst:

    0 0 0 0 ##inst## 1010
  
- dset: [s] = [s]:

    0 0 1 0 00000000 1010

### SEEK

Data seeking operations, inc/dec/set the pointer.

- sinc: s += #inst:

    0 # # # #inst### 0110

- sdec: s -= #inst:
  
    1 # # # #inst### 0110

- ssetli: s[7:0] = #inst:
  
    0 0 0 0 ##inst## 1110

- ssethi: s[15:8] = #inst:

    0 0 0 1 ##inst## 1110

- ssetlm: s[7:0] = [s]:
  
    0 0 1 0 XXXXXXXX 1110

- ssethm: s[15:8] = [s]:
  
    0 0 1 1 XXXXXXXX 1110

### JUMP

Jump operations, including jump and conditional jump.

- jinc: pc + #inst:
  
    0 # # # #inst### 0001
  
- jdec: pc - #inst:
  
    1 # # # #inst### 0001
  
- jmp: pc = #inst:
  
    \# # # # #inst### 1001

- jzinc: ([s]==0) ? pc + #isnt : pc + 1:
  
    0 # # # #inst### 1101

- jzdec: ([s]==0) ? pc - #isnt : pc + 1:
  
    1 # # # #inst### 1101

- jnzinc: ([s]!=0) ? pc + #inst : pc + 1:
  
    10 10     0 # # # #inst### 0101

- jnzdec: ([s]!=0) ? pc + #inst : pc + 1:
  
    10 10     1 # # # #inst### 0101

### IO

IO operations, blocking io input and output.

- in: input >> [s]:

    0 0 0 0 XXXXXXXX 1011
  
- outi: output << #inst:
  
    0 0 0 0 ##inst## 0011
  
- outm: output << [s]:
  
    0 0 1 0 XXXXXXXX 0011



## Perf

I managed to run at 100MHz on my Xilinx-A7. I think this BXU module is quite strong. Just try it.

I managed to optimize some parts of its power that some common UART implements are much too power-consuming.

I am still seeking a way to better program this module in the future. It is using ROM to do so and I don't think this is a good way.
