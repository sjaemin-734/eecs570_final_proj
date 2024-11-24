# Makefile
CXX=g++
VERILATOR=verilator
VERILATOR_ROOT ?= $(shell $(VERILATOR) -V | grep VERILATOR_ROOT | head -1 | awk '{print $$3}')
VINC=$(VERILATOR_ROOT)/include

# Verilator flags
VFLAGS = -Wall --trace --cc --threads 0

# C++ flags
CXXFLAGS = -Wall -I$(VINC) -I$(VINC)/vltstd -I obj_dir
LDFLAGS = -L$(VINC)

# Targets
PARTIAL_TARGET = partial_testbench
UNIT_TARGET = unit_testbench

# Object files for PartialSATEvaluator
PARTIAL_VOBJ = obj_dir/VPartialSATEvaluator.cpp
PARTIAL_VHEAD = obj_dir/VPartialSATEvaluator.h
PARTIAL_VLIB = obj_dir/VPartialSATEvaluator__ALL.a

# Object files for UnitClauseEvaluator
UNIT_VOBJ = obj_dir/VUnitClauseEvaluator.cpp
UNIT_VHEAD = obj_dir/VUnitClauseEvaluator.h
UNIT_VLIB = obj_dir/VUnitClauseEvaluator__ALL.a

all: $(PARTIAL_TARGET) $(UNIT_TARGET)

# Verilate the SystemVerilog files
$(PARTIAL_VOBJ) $(PARTIAL_VHEAD): PartialSATEvaluator.sv
	$(VERILATOR) $(VFLAGS) PartialSATEvaluator.sv

$(UNIT_VOBJ) $(UNIT_VHEAD): UnitClauseEvaluator.sv
	$(VERILATOR) $(VFLAGS) UnitClauseEvaluator.sv

# Build the verilated objects
$(PARTIAL_VLIB): $(PARTIAL_VOBJ)
	cd obj_dir && make -f VPartialSATEvaluator.mk

$(UNIT_VLIB): $(UNIT_VOBJ)
	cd obj_dir && make -f VUnitClauseEvaluator.mk

# Build the testbenches
$(PARTIAL_TARGET): partial_main.cpp $(PARTIAL_VLIB) $(PARTIAL_VHEAD)
	$(CXX) $(CXXFLAGS) -o $@ $< $(PARTIAL_VLIB) \
		$(VINC)/verilated.cpp \
		$(VINC)/verilated_vcd_c.cpp

$(UNIT_TARGET): unit_main.cpp $(UNIT_VLIB) $(UNIT_VHEAD)
	$(CXX) $(CXXFLAGS) -o $@ $< $(UNIT_VLIB) \
		$(VINC)/verilated.cpp \
		$(VINC)/verilated_vcd_c.cpp

clean:
	rm -rf obj_dir $(PARTIAL_TARGET) $(UNIT_TARGET) *.vcd

.PHONY: clean all
