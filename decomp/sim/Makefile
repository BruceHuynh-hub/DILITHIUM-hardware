SYSDIR = ../decomp

TOPLEVEL = decomposer_sim.v


all:
	@echo "iver		Simulate with iVerilog"
	@echo "clean		Cleanup"

iver:
	iverilog -y ../decomp -y . decomposer_sim.v

clean:
	rm -rf a.out *~ trace.vcd