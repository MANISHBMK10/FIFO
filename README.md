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
## Asynchronous FIFO Testbench results -<br/>
### C:\iverilog\bin>iverilog -o a tb_fifo.v top_fifo.v sync_w2r.v sync_r2w.v rempty.v wfull.v fifo_mem.v<br/>
### C:\iverilog\bin>vvp a<br/>
Time: 0 | wclk: 0 | rclk: 0 | wrst_n: 0 | rrst_n: 0 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 5 | wclk: 1 | rclk: 0 | wrst_n: 0 | rrst_n: 0 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 10 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 15 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 20 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 25 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 00 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 30 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: a5 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 35 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: a5 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 40 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 5a | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 45 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 5a | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 50 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 3c | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 55 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 3c | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 60 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 65 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 70 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 75 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 80 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 85 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 1 <br/>
Time: 90 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0 <br/>
Time: 95 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0 <br/>
Time: 100 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0 <br/>
Time: 105 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0 <br/>
Time: 110 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0 <br/>
Time: 115 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0 <br/>
Time: 120 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0 <br/>
Time: 125 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: xx | wfull: 0 | rempty: 0 <br/>
Time: 130 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: a5 | wfull: 0 | rempty: 0 <br/>
Time: 135 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: a5 | wfull: 0 | rempty: 0 <br/>
Time: 140 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: a5 | wfull: 0 | rempty: 0 <br/>
Time: 145 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: a5 | wfull: 0 | rempty: 0 <br/>
Time: 150 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 5a | wfull: 0 | rempty: 0 <br/>
Time: 155 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 5a | wfull: 0 | rempty: 0 <br/>
Time: 160 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 5a | wfull: 0 | rempty: 0 <br/>
Time: 165 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 5a | wfull: 0 | rempty: 0 <br/>
Time: 170 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 3c | wfull: 0 | rempty: 0 <br/>
Time: 175 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 3c | wfull: 0 | rempty: 0 <br/>
Time: 180 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 3c | wfull: 0 | rempty: 0 <br/>
Time: 185 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: 3c | wfull: 0 | rempty: 0 <br/>
Time: 190 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 195 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 200 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 205 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 210 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 215 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: c3 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 220 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 12 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 225 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 12 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 230 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 34 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 235 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 34 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 240 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 56 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 245 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 56 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 250 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 78 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 255 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 78 | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 260 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 9a | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 265 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 9a | rdata: c3 | wfull: 0 | rempty: 1 <br/>
Time: 270 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: bc | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 275 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: bc | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 280 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: de | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 285 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: de | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 290 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: f0 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 295 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: f0 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 300 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 11 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 305 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 11 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 310 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 22 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 315 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 22 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 320 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 33 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 325 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 33 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 330 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 44 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 335 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 44 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 340 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 55 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 345 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 55 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 350 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 66 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 355 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 66 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 360 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 77 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 365 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 77 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 370 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 0 | rempty: 0 <br/>
Time: 375 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 1 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Attempted to write to full FIFO at time 380 <br/>
Time: 380 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 385 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 390 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 395 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 400 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 405 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 410 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 415 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 420 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 425 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: c3 | wfull: 1 | rempty: 0 <br/>
Time: 430 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 12 | wfull: 1 | rempty: 0 <br/>
Time: 435 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 12 | wfull: 1 | rempty: 0 <br/>
Time: 440 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 12 | wfull: 1 | rempty: 0 <br/>
Time: 445 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 12 | wfull: 1 | rempty: 0 <br/>
Time: 450 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 34 | wfull: 1 | rempty: 0 <br/>
Time: 455 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 34 | wfull: 1 | rempty: 0 <br/>
Time: 460 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 34 | wfull: 1 | rempty: 0 <br/>
Time: 465 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 34 | wfull: 1 | rempty: 0 <br/>
Time: 470 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 56 | wfull: 1 | rempty: 0 <br/>
Time: 475 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 56 | wfull: 0 | rempty: 0 <br/>
Time: 480 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 56 | wfull: 0 | rempty: 0 <br/>
Time: 485 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 56 | wfull: 0 | rempty: 0 <br/>
Time: 490 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 78 | wfull: 0 | rempty: 0 <br/>
Time: 495 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 78 | wfull: 0 | rempty: 0 <br/>
Time: 500 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 78 | wfull: 0 | rempty: 0 <br/>
Time: 505 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 78 | wfull: 0 | rempty: 0 <br/>
Time: 510 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 9a | wfull: 0 | rempty: 0 <br/>
Time: 515 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 9a | wfull: 0 | rempty: 0 <br/>
Time: 520 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 9a | wfull: 0 | rempty: 0 <br/>
Time: 525 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 9a | wfull: 0 | rempty: 0 <br/>
Time: 530 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: bc | wfull: 0 | rempty: 0 <br/>
Time: 535 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: bc | wfull: 0 | rempty: 0 <br/>
Time: 540 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: bc | wfull: 0 | rempty: 0 <br/>
Time: 545 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: bc | wfull: 0 | rempty: 0 <br/>
Time: 550 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: de | wfull: 0 | rempty: 0 <br/>
Time: 555 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: de | wfull: 0 | rempty: 0 <br/>
Time: 560 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: de | wfull: 0 | rempty: 0 <br/>
Time: 565 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: de | wfull: 0 | rempty: 0 <br/>
Time: 570 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: f0 | wfull: 0 | rempty: 0 <br/>
Time: 575 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: f0 | wfull: 0 | rempty: 0 <br/>
Time: 580 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: f0 | wfull: 0 | rempty: 0 <br/>
Time: 585 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: f0 | wfull: 0 | rempty: 0 <br/>
Time: 590 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 11 | wfull: 0 | rempty: 0 <br/>
Time: 595 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 11 | wfull: 0 | rempty: 0 <br/>
Time: 600 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 11 | wfull: 0 | rempty: 0 <br/>
Time: 605 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 11 | wfull: 0 | rempty: 0 <br/>
Time: 610 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 22 | wfull: 0 | rempty: 0 <br/>
Time: 615 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 22 | wfull: 0 | rempty: 0 <br/>
Time: 620 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 22 | wfull: 0 | rempty: 0 <br/>
Time: 625 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 22 | wfull: 0 | rempty: 0 <br/>
Time: 630 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 33 | wfull: 0 | rempty: 0 <br/>
Time: 635 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 33 | wfull: 0 | rempty: 0 <br/>
Time: 640 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 33 | wfull: 0 | rempty: 0 <br/>
Time: 645 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 33 | wfull: 0 | rempty: 0 <br/>
Time: 650 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 44 | wfull: 0 | rempty: 0 <br/>
Time: 655 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 44 | wfull: 0 | rempty: 0 <br/>
Time: 660 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 44 | wfull: 0 | rempty: 0 <br/>
Time: 665 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 44 | wfull: 0 | rempty: 0 <br/>
Time: 670 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 55 | wfull: 0 | rempty: 0 <br/>
Time: 675 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 55 | wfull: 0 | rempty: 0 <br/>
Time: 680 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 55 | wfull: 0 | rempty: 0 <br/>
Time: 685 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 55 | wfull: 0 | rempty: 0 <br/>
Time: 690 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 66 | wfull: 0 | rempty: 0 <br/>
Time: 695 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 66 | wfull: 0 | rempty: 0 <br/>
Time: 700 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 66 | wfull: 0 | rempty: 0 <br/>
Time: 705 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 66 | wfull: 0 | rempty: 0 <br/>
Time: 710 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 77 | wfull: 0 | rempty: 0 <br/>
Time: 715 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 77 | wfull: 0 | rempty: 0 <br/>
Time: 720 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 77 | wfull: 0 | rempty: 0 <br/>
Time: 725 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 77 | wfull: 0 | rempty: 0 <br/>
Time: 730 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 735 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 740 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 745 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 1 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Attempted to read from empty FIFO at time 750<br/>
Attempted to read from empty FIFO at time 750<br/>
Attempted to read from empty FIFO at time 750<br/>
Attempted to read from empty FIFO at time 750<br/>
Attempted to read from empty FIFO at time 750<br/>
Attempted to read from empty FIFO at time 750<br/>
Time: 750 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 755 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 760 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 765 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 770 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 775 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 780 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 785 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 790 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 795 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 800 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 805 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 810 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 815 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 820 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 825 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 830 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 835 | wclk: 1 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 840 | wclk: 0 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 845 | wclk: 1 | rclk: 0 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
Time: 850 | wclk: 0 | rclk: 1 | wrst_n: 1 | rrst_n: 1 | winc: 0 | rinc: 0 | wdata: 88 | rdata: 88 | wfull: 0 | rempty: 1 <br/>
# References
[http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf](url)
