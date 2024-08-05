# FIFO on TPU
 Asynchronous FIFO implementation on TPU
 # Simulation Tool
 To Simulate the following files, I've used Icarus Verilog and GtkWave.<br/>
 Here's the link for Installation - [Icarus Verilog](https://bleyer.org/icarus/) <br/>
 After installation, please save the files in the bin and use the commands below. 
# Commands
To run FIFO implementation on TPU, use the following command - <br />

1st Command - iverilog -o b.out FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v<br />
2nd Command - vvp b.out <br/>

To test Asynchronous FIFO files, use the command below - <br />

1st Command - iverilog -o a.out tb_fifo.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v <br />
2nd Command - vvp a.out<br />

>".v" file stands for verilog files<br/>
## Asynchronous FIFO modules(From Cummings paper)
**modules** - top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v <br />

- **top_fifo.v** - This module instantiates all the other modules of FIFOs. <br />
- **sync_r2w.v** - This module synchronzies read pointer to write pointer. <br />
- **sync_w2r.v** - This module synchronzies write pointer to reat pointer. <br />
- **rempty.v**  - This module checks the "empty condition" of FIFO. <br />
- **fifo_mem.v** - This module uses memory for storing values for FIFOs. <br />
- **wfull.v**    - This module checks the "full condition" of FIFO. <br />

## TPU modules
**modules** - FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v

## Let's get Started -

### FIFO -
 FIFO stands for First_in, First_out Buffer. There are two types of FIFO's. 
 Synchronous FIFO - This FIFO works in one clock domain.
 Asynchronous FIFO - This FIFO works with two seperate clock domains.
 In this Project, I'd gone with Asynchronous FIFO as it's common in real world.
### What is a TPU? -

TPU stands for "Tensor Processing Unit" and Systolic Array is heart of TPU. 
### Image of TPU-

![](https://github.com/MANISHBMK10/FIFO/blob/main/ASYNC_FIFO_TPU_C.png)
**Multiply and Accumulate(MAC)** units are the base of systolic array. I've implemented 16 MAC units to form a systolic array i.e 4*4 matrices mutliplication.<br/> 
The input values gets loaded into feature memory and weight memory. <br/>
### Image of MAC -

![](https://github.com/MANISHBMK10/FIFO/blob/main/MAC.png)
The 8-bit values are loaded into column-wise asynchronous FIFOs from the weight memory and feature memory, as the memory clock domain differs from the systolic array clock domain. FIFOs are responsible for loading data into the systolic array.

As the values are multiplied within the MAC units, they are then passed down to other MAC units. After the multiplication process, the values undergo quantization, converting 24-bit values to 8-bit values. Following quantization, the values pass through an activation unit, where the output value is checked against a threshold.

Finally, the values are updated in asynchronous FIFOs and written back into the feature memory.
<br/>
# Simulation Results
## Asynchronous FIFO Testbench results -<br/>

To test the working of FIFO, I've used two memories with different clock domains and values are passed down from one memory to other using FIFO.

C:\iverilog\bin>iverilog -o a test_memfifo_tb.v test_memfifo.v wfull.v rempty.v sync_r2w.v sync_w2r.v top_fifo.v fifo_mem.v<br/>

C:\iverilog\bin>vvp a<br/>

![](https://github.com/MANISHBMK10/FIFO/blob/main/verilog.png)
### GTKWave Results -

![](https://github.com/MANISHBMK10/FIFO/blob/main/gtk_fifofinal.png)


# References

[http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf](url)
