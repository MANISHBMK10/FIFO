# FIFO(First in, first out) implementation on TPU(Tensor Processing Unit)
 Asynchronous FIFO implementation on toy version of TPU.
 ## Simulation tool
 To simulate the following files, I've used icarus verilog and gtkwave.<br/>
 Here's the link for installation - [Icarus Verilog](https://bleyer.org/icarus/) <br/>
 After installation, please save the files in the bin and use the commands below. 
## Commands
To run FIFO implementation on TPU, use the following command - <br />

1st command - iverilog -o b.out FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v<br />
2nd command - vvp b.out <br/>

To test asynchronous FIFO files, use the command below - <br />

1st command - iverilog -o a top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v <br />
2nd command - vvp a.out<br />

>".v" file stands for verilog files<br/>
## Asynchronous FIFO modules
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
## Understanding FIFO in TPU design
#### FIFO -
 FIFO stands for First in, first out Buffer. <br/>
 <br/>
 There are two types of FIFO's. <br/>
 - Synchronous FIFO - This FIFO works in one clock domain.<br/>
 - Asynchronous FIFO - This FIFO works with two seperate clock domains.<br/>

 
In this Project, I have implemented asynchronous FIFO as it is commonly used in real world.<br/>
#### What is a TPU? -

TPU stands for "Tensor Processing Unit" and systolic array is heart of TPU. 
#### Image of TPU-

![](https://github.com/MANISHBMK10/FIFO/blob/main/tpu_1.png)
**Multiply and Accumulate (MAC)** units are the base of systolic array. I've implemented 16 MAC units to form a systolic array for 4*4 matrix mutliplication.<br/> 
The input values gets loaded into feature memory and weight memory. <br/>
#### Image of MAC -

![](https://github.com/MANISHBMK10/FIFO/blob/main/MAC.png)
The 8-bit values are loaded into column-wise asynchronous FIFOs from the weight memory and feature memory, as the memory clock domain differs from the systolic array clock domain. FIFOs are responsible for loading data into the systolic array.

As the values are loaded and multiplied within the MAC units, they are then passed down to other MAC units. The carry-in values are 24-bits for top MAC units. <br/>

After the multiplication process, the values undergo quantization, converting 24-bit values to 8-bit values. Following quantization, the values pass through an activation unit, where the output value is checked against a threshold.<br/>

Finally, the values are updated in asynchronous FIFOs and written back into the feature memory.<br/>

## **Manipulating read and write pointers of FIFO** 
**Modules** - FIFO_TPU_t.v top_fifo_t.v wptr_full_trojan.v rempty_t.v <br/>

**wptr_full_trojan.v** - This module manupilates write pointer<br/>
**rempty_t.v** - It manupilates read pointer<br/>
**top_fifo_t.v** - Instantiates the above modules.<br/>

#### Read/write pointers: manipulation and control
I've implemented the pointers in such a way that the data can be read from desired location.<br/>
The main aim was to attack read pointers but I've implementated on both pointers. Only one of the pointer can be manipulated at the same time.<br/>

## **Trojan I** 
**Modules** - top_fifo_trojan1.v wptr_full_trojan_1.v<br/>

**wptr_full_trojan_1.v** - This module manupilates write pointer.<br/>
**top_fifo_trojan1.v** - Instantiates the above module.<br/>

**Trojan I** - This trojan manipulates write pointer and reloactes behind read pointer.
![](https://github.com/MANISHBMK10/FIFO/blob/main/trojanIimage.png)

## Simulation results
### Asynchronous FIFO testbench results -<br/>

To test the working of FIFO, I've used two memories with different clock domains and values are passed down from one memory to other using FIFO.

C:\iverilog\bin>iverilog -o a test_memfifo_tb.v test_memfifo.v wfull.v rempty.v sync_r2w.v sync_w2r.v top_fifo.v fifo_mem.v<br/>

C:\iverilog\bin>vvp a<br/>

![](https://github.com/MANISHBMK10/FIFO/blob/main/verilog.png)
#### Gtkwave results -

![](https://github.com/MANISHBMK10/FIFO/blob/main/gtk_fifofinal.png)
> The values are in hexadecimal data format.<br/>

### Trojan I testbench results-<br/>

**Simulation command #1** - C:\iverilog\bin>iverilog -o a test_memfifo_tb.v test_memfifo.v wptr_full_trojan_1.v rempty.v sync_r2w.v sync_w2r.v top_fifo_trojan1.v fifo_mem.v<br/>

**Command #2** - C:\iverilog\bin>vvp a<br/>
![](https://github.com/MANISHBMK10/FIFO/blob/main/trojan_1imp.png)
#### Gtkwave results -

![](https://github.com/MANISHBMK10/FIFO/blob/main/trojan_1imp2.png)

### FIFO implementation on TPU results
**Simulation command #1** - iverilog -o result.out FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v<br/>

**command #2** - vvp result.out<br/>

![](https://github.com/MANISHBMK10/FIFO/blob/main/fifo_tpu.png)
> The last column values are lower than threshold value when passed through activation unit.<br/>
#### Gtkwave results -

![](https://github.com/MANISHBMK10/FIFO/blob/main/tpu_gtk.png)
> The values are in hexadecimal data format.<br/>

### Read and write pointers manipulation results
**Simulation command #1** - iverilog -o result2.out FIFO_TPU_TB.v FIFO_TPU_t.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v top_fifo_t.v wptr_full_trojan.v rempty_t.v <br/>

**Command #2** - vvp result2.out<br/>

![](https://github.com/MANISHBMK10/FIFO/blob/main/mp_results.png)
#### Gtkwave results -

![](https://github.com/MANISHBMK10/FIFO/blob/main/mp_results2.png)

## References

[http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf](url)
[https://ieeexplore.ieee.org/document/7282151](url)
