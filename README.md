# FIFO on TPU
 Asynchronous FIFO implementation on TPU
 # Simulation
 To Simulate the following files, I've used Icarus Verilog.<br/>
 After installation, please save the files in the bin and use the commands below. 
# Commands
To run the FIFO implementation on TPU use the command <br />
iverilog -o b.out FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v<br />
vvp b.out
>".v" file stands for verilog files

## Asynchronous fifo modules(From Cummings paper)
**modules** - top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v <br />
**top_fifo.v** - This module instantiates all the other modules of FIFOs. <br />
**sync_r2w.v** - This module synchronzies read pointer to write pointer. <br />
**sync_w2r.v** - This module synchronzies write pointer to reat pointer. <br />
**rempty.v**  - This module checks empty condition. <br />
**fifo_mem.v** - This module uses memory for storing values for FIFOs. <br />
**wfull.v**    - This module checks full condition. <br />
To run use the command - <br />
iverilog -o a.out tb_fifo.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v <br />
vvp a.out<br />
## TPU modules
**modules** - FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v

## Let's get Started -
### FIFO -
 FIFO stands for First_in, First_out Buffer
### What is a TPU? -
TPU stands for "Tensor Processing Unit" and Systolic Array is heart of TPU. 
### Image of TPU-
![](https://github.com/MANISHBMK10/FIFO/blob/main/ASYNC_FIFO_TPU_C.png)
**Multiply and Accumulate(MAC)** units are the base of Systolic Array. I've implemented 16 MAC units to form a Systolic array i.e 4*4 matrices mutliplication.<br/> 
The input values gets loaded into Feature Memory and Weight Memory. <br/>
### Image of MAC -
![](https://github.com/MANISHBMK10/FIFO/blob/main/MAC.png)
These 8-bit values are loaded  into cloumn-wise Asynchronous FIFOs from Weight Memory and Feature Memory as Memory clock domain is different from systolic array clock domain. <br/>
FIFOs are responsible to load the data into systolic array. <br/>
As values get multiplied and passed down to other MAC units, they are passed through Quantization unit(i.e. which converts 24-bit values to 8-bit values).<br/>
After Quantization, the values are gone through Activation unit(i.e. the output value is checked if it's greater than threshold value).<br/>
Now, the values are updated into Asynchronous FIFOs and gets updated back into Feature Memory.<br/>
# Simulation Results
## Asynchronous FIFO Testbench results -<br/>
### C:\iverilog\bin>iverilog -o a test_memfifo_tb.v test_memfifo.v wfull.v rempty.v sync_r2w.v sync_w2r.v top_fifo.v fifo_mem.v<br/>
### C:\iverilog\bin>vvp a<br/>
![](https://github.com/MANISHBMK10/FIFO/blob/main/verilog.png)
### GTKWave Results -
![](https://github.com/MANISHBMK10/FIFO/blob/main/gtk_fifofinal.png)


# References
[http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf](url)
