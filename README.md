# FIFO
 FIFO implementation on TPU
# command
iverilog -o a.out FIFO_TPU_TB.v FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v
# asynchronous fifo modules(Cummings)
top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v
\nTo run use the command - 
iverilog -o a.out tb_fifo.v top_fifo.v sync_r2w.v sync_w2r.v rempty.v fifo_mem.v wfull.v
vvp a.out
# TPU modules
FIFO_TPU.v systolicArray.v MACUnit.v QuantizationUnit.v ActivationUnit.v
