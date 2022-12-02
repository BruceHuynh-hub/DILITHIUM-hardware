export DESIGN_NAME = decomposer_unit
export PLATFORM    = sky130hd

export VERILOG_FILES = /OpenROAD-flow-scripts/flow/mydesign/decomp/decomp/decomposer_unit.v \
/OpenROAD-flow-scripts/flow/mydesign/decomp/decomp/decomp_map1.v \
/OpenROAD-flow-scripts/flow/mydesign/decomp/decomp/coeff_decomposer.v 

export SDC_FILE      = /OpenROAD-flow-scripts/flow/mydesign/decomp/config/constraint.sdc

# These values must be multiples of placement site
export DIE_AREA    =  0  0 180 180
export CORE_AREA   =  0  0 180 180