# FIFO
 FIFO implementation on TPU
# Commands
To run the FIFO implementation on TPU use the command <br />
iverilog -o b.out FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v<br />
vvp b.out
## Asynchronous fifo modules(From Cummings paper)
top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v <br />
To run use the command - <br />
iverilog -o a.out tb_fifo.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v <br />
vvp a.out<br />
## TPU modules
FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v
# References
[http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf](url)
## Let's get Started -
### What is a TPU? -
TPU stands for "Tensor Processing Unit" and Systolic Array is heart of TPU. 
# IMAGE of TPU-
Multiply and Accumulate(MAC) units are the base of Systolic Array. I've implemented 16 MAC units to form a Systolic array i.e 4*4 matrices mutliplication. 
>".v" file stands for verilog files
