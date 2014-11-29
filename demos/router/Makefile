VSCAN=../../bin/vscan

RBDIR := lib
_DEPS := fifo_ctrl_4d.rb \
	fifo_ctrl_8d.rb \
	generic_mem_4x64.rb \
	generic_mem_8x64.rb \
	rr_arb.rb \
	router_ctrl_64bit.rb 
DEPS  := $(addprefix $(RBDIR)/,$(_DEPS))

generic: $(DEPS) \
	build/generic_router.rb

chip1: $(DEPS) \
	build/chip1_router.rb

chip2: $(DEPS) \
	build/chip1_router.rb

all: $(DEPS) \
	build/generic_router.rb \
	build/chip1_router.rb \
	build/chip2_router.rb

$(DEPS): | $(RBDIR)
$(RBDIR):
	mkdir $(RBDIR)

$(RBDIR)/fifo_ctrl_4d.rb: rtl/fifo_ctrl.v
	$(VSCAN) DEPTH=4 -class fifo_ctrl_4d $<
	mv rtl/fifo_ctrl_4d.rb $(RBDIR)/fifo_ctrl_4d.rb

$(RBDIR)/fifo_ctrl_8d.rb: rtl/fifo_ctrl.v
	$(VSCAN) DEPTH=8 -class fifo_ctrl_8d $<
	mv rtl/fifo_ctrl_8d.rb $(RBDIR)/fifo_ctrl_8d.rb

$(RBDIR)/generic_mem_4x64.rb: rtl/generic_mem.v
	$(VSCAN) DEPTH=4 WIDTH=64 -class generic_mem_4x64 $<
	mv rtl/generic_mem_4x64.rb $(RBDIR)/generic_mem_4x64.rb

$(RBDIR)/generic_mem_8x64.rb: rtl/generic_mem.v
	$(VSCAN) DEPTH=8 WIDTH=64 -class generic_mem_8x64 $<
	mv rtl/generic_mem_8x64.rb $(RBDIR)/generic_mem_8x64.rb

$(RBDIR)/rr_arb.rb: rtl/rr_arb.v
	$(VSCAN) $<
	mv rtl/rr_arb.rb $(RBDIR)/rr_arb.rb

$(RBDIR)/router_ctrl_64bit.rb: rtl/router_ctrl.v
	$(VSCAN) WIDTH=64 -class router_ctrl_64bit $<
	mv rtl/router_ctrl_64bit.rb $(RBDIR)/router_ctrl_64bit.rb

.PHONY: clean
clean:
	rm -rf lib
