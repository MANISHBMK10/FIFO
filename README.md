# FIFO
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
To run use the command - <br />
iverilog -o a.out tb_fifo.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v <br />
vvp a.out<br />
## TPU modules
**modules** - FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v

## Let's get Started -
### What is a TPU? -
TPU stands for "Tensor Processing Unit" and Systolic Array is heart of TPU. 
### Image of TPU-
![](https://github.com/MANISHBMK10/FIFO/blob/main/ASYNC_FIFO_TPU.png)
**Multiply and Accumulate(MAC) units are the base of Systolic Array. I've implemented 16 MAC units to form a Systolic array i.e 4*4 matrices mutliplication.<br/> 
The input values gets loaded into Feature Memory and Weight Memory. <br/>**
### Image of MAC -
![](https://github.com/MANISHBMK10/FIFO/blob/main/MAC.png)
**These 8-bit values are loaded  into cloumn-wise Asynchronous FIFOs from Weight Memory and Feature Memory as Memory clock domain is different from systolic array clock domain. <br/>
FIFOs are responsible to load the data into systolic array. <br/>
As values get multiplied and passed down to other MAC units, they are passed through Quantization unit(i.e. which converts 24-bit values to 8-bit values).<br/>
After Quantization, the values are gone through Activation unit(i.e. the output value is checked if it's greater than threshold value).<br/>
Now, the vakues are updated into Asynchronous FIFOs and gets updated back into Feature Memory.<br/>**
# Simulation Results
Asynchronous FIFO Testbench results -<br/>
C:\iverilog\bin>iverilog -o a tb_fifo.v top_fifo.v sync_w2r.v sync_r2w.v rempty.v wfull.v fifo_mem.v<br/>

C:\iverilog\bin>vvp a<br/>
Time: 0 | wclk: 0 | rclk: 0 | wrst_n: 0 | rrst_n: 0 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1
Time: 5 | wclk: 1 | rclk: 0 | wrst_n: 0 | rrst_n: 0 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1
Time: 10 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1
Time: 15 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1
Time: 20 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1
Time: 25 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1
Time: 30 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: a5 | rdata: xx | wfull: 0 | rempty: 1
Time: 35 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: a5 | rdata: xx | wfull: 0 | rempty: 1
Time: 40 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 5a | rdata: xx | wfull: 0 | rempty: 1
Time: 45 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 5a | rdata: xx | wfull: 0 | rempty: 1
Time: 50 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 3c | rdata: xx | wfull: 0 | rempty: 1
Time: 55 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 3c | rdata: xx | wfull: 0 | rempty: 1
Time: 60 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1
Time: 65 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1
Time: 70 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1
Time: 75 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1
Time: 80 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1
Time: 85 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1
Time: 90 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0
Time: 95 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0
Time: 100 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0
Time: 105 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0
Time: 110 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0
Time: 115 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0
Time: 120 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0
Time: 125 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0
Time: 130 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: a5 | wfull: 0 | rempty: 0
Time: 135 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: a5 | wfull: 0 | rempty: 0
Time: 140 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: a5 | wfull: 0 | rempty: 0
Time: 145 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: a5 | wfull: 0 | rempty: 0
Time: 150 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 5a | wfull: 0 | rempty: 0
Time: 155 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 5a | wfull: 0 | rempty: 0
Time: 160 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 5a | wfull: 0 | rempty: 0
Time: 165 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 5a | wfull: 0 | rempty: 0
Time: 170 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 3c | wfull: 0 | rempty: 0
Time: 175 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 3c | wfull: 0 | rempty: 0
Time: 180 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 3c | wfull: 0 | rempty: 0
Time: 185 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 3c | wfull: 0 | rempty: 0
Time: 190 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1
Time: 195 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1
Time: 200 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1
Time: 205 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1
Time: 210 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1
Time: 215 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1
Time: 220 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 12 | rdata: c3 | wfull: 0 | rempty: 1
Time: 225 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 12 | rdata: c3 | wfull: 0 | rempty: 1
Time: 230 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 34 | rdata: c3 | wfull: 0 | rempty: 1
Time: 235 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 34 | rdata: c3 | wfull: 0 | rempty: 1
Time: 240 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 56 | rdata: c3 | wfull: 0 | rempty: 1
Time: 245 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 56 | rdata: c3 | wfull: 0 | rempty: 1
Time: 250 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 78 | rdata: c3 | wfull: 0 | rempty: 1
Time: 255 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 78 | rdata: c3 | wfull: 0 | rempty: 1
Time: 260 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 9a | rdata: c3 | wfull: 0 | rempty: 1
Time: 265 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 9a | rdata: c3 | wfull: 0 | rempty: 1
Time: 270 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: bc | rdata: c3 | wfull: 0 | rempty: 0
Time: 275 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: bc | rdata: c3 | wfull: 0 | rempty: 0
Time: 280 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: de | rdata: c3 | wfull: 0 | rempty: 0
Time: 285 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: de | rdata: c3 | wfull: 0 | rempty: 0
Time: 290 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: f0 | rdata: c3 | wfull: 0 | rempty: 0
Time: 295 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: f0 | rdata: c3 | wfull: 0 | rempty: 0
Time: 300 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 11 | rdata: c3 | wfull: 0 | rempty: 0
Time: 305 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 11 | rdata: c3 | wfull: 0 | rempty: 0
Time: 310 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 22 | rdata: c3 | wfull: 0 | rempty: 0
Time: 315 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 22 | rdata: c3 | wfull: 0 | rempty: 0
Time: 320 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 33 | rdata: c3 | wfull: 0 | rempty: 0
Time: 325 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 33 | rdata: c3 | wfull: 0 | rempty: 0
Time: 330 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 44 | rdata: c3 | wfull: 0 | rempty: 0
Time: 335 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 44 | rdata: c3 | wfull: 0 | rempty: 0
Time: 340 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 55 | rdata: c3 | wfull: 0 | rempty: 0
Time: 345 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 55 | rdata: c3 | wfull: 0 | rempty: 0
Time: 350 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 66 | rdata: c3 | wfull: 0 | rempty: 0
Time: 355 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 66 | rdata: c3 | wfull: 0 | rempty: 0
Time: 360 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 77 | rdata: c3 | wfull: 0 | rempty: 0
Time: 365 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 77 | rdata: c3 | wfull: 0 | rempty: 0
Time: 370 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 0 | rempty: 0
Time: 375 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Attempted to write to full FIFO at time 380
Time: 380 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 385 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 390 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 395 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 400 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 405 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 410 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 415 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 420 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 425 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0
Time: 430 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 12 | wfull: 1 | rempty: 0
Time: 435 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 12 | wfull: 1 | rempty: 0
Time: 440 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 12 | wfull: 1 | rempty: 0
Time: 445 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 12 | wfull: 1 | rempty: 0
Time: 450 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 34 | wfull: 1 | rempty: 0
Time: 455 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 34 | wfull: 1 | rempty: 0
Time: 460 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 34 | wfull: 1 | rempty: 0
Time: 465 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 34 | wfull: 1 | rempty: 0
Time: 470 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 56 | wfull: 1 | rempty: 0
Time: 475 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 56 | wfull: 0 | rempty: 0
Time: 480 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 56 | wfull: 0 | rempty: 0
Time: 485 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 56 | wfull: 0 | rempty: 0
Time: 490 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 78 | wfull: 0 | rempty: 0
Time: 495 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 78 | wfull: 0 | rempty: 0
Time: 500 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 78 | wfull: 0 | rempty: 0
Time: 505 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 78 | wfull: 0 | rempty: 0
Time: 510 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 9a | wfull: 0 | rempty: 0
Time: 515 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 9a | wfull: 0 | rempty: 0
Time: 520 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 9a | wfull: 0 | rempty: 0
Time: 525 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 9a | wfull: 0 | rempty: 0
Time: 530 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: bc | wfull: 0 | rempty: 0
Time: 535 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: bc | wfull: 0 | rempty: 0
Time: 540 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: bc | wfull: 0 | rempty: 0
Time: 545 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: bc | wfull: 0 | rempty: 0
Time: 550 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: de | wfull: 0 | rempty: 0
Time: 555 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: de | wfull: 0 | rempty: 0
Time: 560 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: de | wfull: 0 | rempty: 0
Time: 565 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: de | wfull: 0 | rempty: 0
Time: 570 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: f0 | wfull: 0 | rempty: 0
Time: 575 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: f0 | wfull: 0 | rempty: 0
Time: 580 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: f0 | wfull: 0 | rempty: 0
Time: 585 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: f0 | wfull: 0 | rempty: 0
Time: 590 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 11 | wfull: 0 | rempty: 0
Time: 595 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 11 | wfull: 0 | rempty: 0
Time: 600 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 11 | wfull: 0 | rempty: 0
Time: 605 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 11 | wfull: 0 | rempty: 0
Time: 610 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 22 | wfull: 0 | rempty: 0
Time: 615 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 22 | wfull: 0 | rempty: 0
Time: 620 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 22 | wfull: 0 | rempty: 0
Time: 625 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 22 | wfull: 0 | rempty: 0
Time: 630 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 33 | wfull: 0 | rempty: 0
Time: 635 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 33 | wfull: 0 | rempty: 0
Time: 640 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 33 | wfull: 0 | rempty: 0
Time: 645 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 33 | wfull: 0 | rempty: 0
Time: 650 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 44 | wfull: 0 | rempty: 0
Time: 655 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 44 | wfull: 0 | rempty: 0
Time: 660 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 44 | wfull: 0 | rempty: 0
Time: 665 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 44 | wfull: 0 | rempty: 0
Time: 670 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 55 | wfull: 0 | rempty: 0
Time: 675 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 55 | wfull: 0 | rempty: 0
Time: 680 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 55 | wfull: 0 | rempty: 0
Time: 685 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 55 | wfull: 0 | rempty: 0
Time: 690 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 66 | wfull: 0 | rempty: 0
Time: 695 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 66 | wfull: 0 | rempty: 0
Time: 700 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 66 | wfull: 0 | rempty: 0
Time: 705 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 66 | wfull: 0 | rempty: 0
Time: 710 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 77 | wfull: 0 | rempty: 0
Time: 715 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 77 | wfull: 0 | rempty: 0
Time: 720 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 77 | wfull: 0 | rempty: 0
Time: 725 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 77 | wfull: 0 | rempty: 0
Time: 730 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 735 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 740 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 745 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Attempted to read from empty FIFO at time 750
Attempted to read from empty FIFO at time 750
Attempted to read from empty FIFO at time 750
Attempted to read from empty FIFO at time 750
Attempted to read from empty FIFO at time 750
Attempted to read from empty FIFO at time 750
Time: 750 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 755 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 760 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 765 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 770 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 775 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 780 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 785 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 790 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 795 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 800 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 805 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 810 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 815 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 820 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 825 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 830 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 835 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 840 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 845 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
Time: 850 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1
# References
[http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf](url)
