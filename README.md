# FIFO on TPU
 Asynchronous FIFO implementation on toy version of TPU.
 ## Simulation Tool
 To simulate the following files, I've used Icarus Verilog and GtkWave.<br/>
 Here's the link for installation - [Icarus Verilog](https://bleyer.org/icarus/) <br/>
 After installation, please save the files in the bin and use the commands below. 
## Commands
To run FIFO implementation on TPU, use the following command - <br />

1st Command - iverilog -o b.out FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v<br />
2nd Command - vvp b.out <br/>

To test Asynchronous FIFO files, use the command below - <br />

1st Command - iverilog -o a top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v <br />
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
- **FIFO_TPU.v**         - Implementation on FIFO on TPU.
- **systolicArray.v**    - Systolic Array is matrix multiplication block made up of MACUnits.
- **MACUnit.v**          - Basic matrix multiplication unit
- **QuantizationUnit.v** - This unit converts 24-bits values to 8-bits values
- **ActivationUnit.v**   - This unit passes the values that are greater than threshold value or else 0 is passed 

### Let's get Started -

#### FIFO -
 FIFO stands for First_in, First_out Buffer. <br/>
 <br/>
 There are two types of FIFO's. <br/>
 - Synchronous FIFO - This FIFO works in one clock domain.<br/>
 - Asynchronous FIFO - This FIFO works with two seperate clock domains.<br/>

 
In this Project, I have implemented Asynchronous FIFO as it is commonly used in real world.<br/>
#### What is a TPU? -

TPU stands for "Tensor Processing Unit" and systolic array is heart of TPU. 
#### Image of TPU-

![](https://github.com/MANISHBMK10/FIFO/blob/main/ASYNC_FIFO_TPU_C.png)
**Multiply and Accumulate (MAC)** units are the base of systolic array. I've implemented 16 MAC units to form a systolic array for 4*4 matrix mutliplication.<br/> 
The input values gets loaded into feature memory and weight memory. <br/>
#### Image of MAC -

![](https://github.com/MANISHBMK10/FIFO/blob/main/MAC.png)
The 8-bit values are loaded into column-wise asynchronous FIFOs from the weight memory and feature memory, as the memory clock domain differs from the systolic array clock domain. FIFOs are responsible for loading data into the systolic array.

As the values are loaded and multiplied within the MAC units, they are then passed down to other MAC units. The Carry-in values are 24-bits for top MAC units. <br/>

After the multiplication process, the values undergo quantization, converting 24-bit values to 8-bit values. Following quantization, the values pass through an activation unit, where the output value is checked against a threshold.<br/>

Finally, the values are updated in asynchronous FIFOs and written back into the feature memory.<br/>

## Simulation Results
### Asynchronous FIFO Testbench results -<br/>

To test the working of FIFO, I've used two memories with different clock domains and values are passed down from one memory to other using FIFO.

C:\iverilog\bin>iverilog -o a test_memfifo_tb.v test_memfifo.v wfull.v rempty.v sync_r2w.v sync_w2r.v top_fifo.v fifo_mem.v<br/>

C:\iverilog\bin>vvp a<br/>

![](https://github.com/MANISHBMK10/FIFO/blob/main/verilog.png)
#### GTKWave Results -

![](https://github.com/MANISHBMK10/FIFO/blob/main/gtk_fifofinal.png)
> The values are in hexadecimal data format.<br/>

### FIFO Implementation on TPU Results
**Simulation command #1** - iverilog -o result.out FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v<br/>

**command #2** - vvp result.out<br/>

![](https://github.com/MANISHBMK10/FIFO/blob/main/fifo_tpu.png)
> The last column values are lower than threshold value when passed through activation unit.<br/>
#### GTKWave Results -

![](https://github.com/MANISHBMK10/FIFO/blob/main/tpu_gtk.png)
> The values are in hexadecimal data format.<br/>
## References

[http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf](url)
