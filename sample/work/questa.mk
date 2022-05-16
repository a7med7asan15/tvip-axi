VLOG_ARGS	+= -64
VLOG_ARGS	+= -sv
VLOG_ARGS	+= -l compile.log
VLOG_ARGS	+= -timescale=1ns/1ps
VLOG_ARGS	+= +define+UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTO

VSIM_ARGS	+= -l vsim.log
VSIM_ARGS	+= -f ./$(TEST)/test.f
VSIM_ARGS	+= top_opt

ifeq ($(strip $(RANDOM_SEED)), auto)
	VSIM_ARGS	+= -sv_seed 1
else
	VSIM_ARGS	+= -sv_seed $(RANDOM_SEED)
endif

ifeq ($(strip $(DUMP)), vpd)
	VLOG_ARGS	+= -debug_access
	VLOG_ARGS	+= +vcs+vcdpluson
	VSIM_ARGS	+= -vpd_file dump.vpd
endif

ifeq ($(strip $(DUMP)), fsdb)
	VLOG_ARGS	+= -debug_access
	VLOG_ARGS	+= -kdb
	VLOG_ARGS	+= +vcs+fsdbon
	VSIM_ARGS	+= +fsdbfile+dump.fsdb
endif

ifeq ($(strip $(GUI)), dve)
	VLOG_ARGS	+= -debug_access+all
	VLOG_ARGS	+= +vcs+vcdpluson
	VSIM_ARGS	+= -gui=dve
endif

ifeq ($(strip $(GUI)), verdi)
	VLOG_ARGS	+= -debug_access+all
	VLOG_ARGS	+= -kdb
	VLOG_ARGS	+= +vcs+fsdbon
	VSIM_ARGS	+= -gui=verdi
endif

ifeq ($(strip $(GUI)), off)
	VSIM_ARGS	+= -c
endif

CLEAN_TARGET	+= simv*
CLEAN_TARGET	+= csrc
CLEAN_TARGET	+= *.h

CLEAN_ALL_TARGET += *.vpd
CLEAN_ALL_TARGET += *.fsdb
CLEAN_ALL_TARGET += *.key
CLEAN_ALL_TARGET += *.conf
CLEAN_ALL_TARGET += *.rc
CLEAN_ALL_TARGET += DVEfiles
CLEAN_ALL_TARGET += verdiLog
CLEAN_ALL_TARGET += .inter.vpd.uvm

.PHONY: sim_questa compile_questa

sim_questa:
	[ -f simv ] || ($(MAKE) compile_questa)
	vopt top -o top_opt -suppress 7033; vsim $(VSIM_ARGS) -suppress 7033

compile_questa:
	vlog $(VLOG_ARGS) $(addprefix -f , $(FILE_LISTS)) $(SOURCE_FILES)
